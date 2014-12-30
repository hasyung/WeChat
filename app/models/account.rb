class Account < ActiveRecord::Base

  include Extension::DataTable

  audited

  attr_accessible :name, :alias, :description, :identifier, :token, :app_id, \
  :app_secret, :access_token, :expires_in, \
  :lottery_time_start, :lottery_time_end


  # Relations
  has_many :members,      dependent: :destroy
  has_many :menus,        dependent: :destroy, conditions: { soft_delete: false }, order: '`order` ASC'
  has_many :replies,      dependent: :destroy, order: '`id` DESC'
  has_many :resources,    dependent: :destroy
  has_many :kits,         dependent: :destroy
  has_many :albums,       dependent: :destroy

  # Validates
  validates :name, :alias, :token, presence: true
  with_options if: :name? do |account|
    account.validates :name, length: { in: 3..50 }
    account.validates :name, uniqueness: true
  end
  with_options if: :alias? do |account|
    account.validates :alias, length: { in: 3..50 }
    account.validates :alias, uniqueness: true
  end
  with_options if: :token? do |account|
    account.validates :token, length: { maximum: 32 }
  end
  with_options if: :description? do |account|
    account.validates :description, length: { maximum: 1000 }
  end

  # Callbacks
  before_validation :build_token
  before_update :update_access_token_at
  before_create :generate_system_replies

  # Methods

  def messages_count
    Message.joins(member: :account).where("`accounts`.`id` = ?", self.id).count
  end

  def is_complete?
    app_id.present? or app_secret.present? or token.present?
  end

  def access_token_expires?
    access_token.blank? || ((DateTime.now.to_i - updated_access_token_at.to_i) >= expires_in)
  end

  def refresh_access_token
    RestClient.get Setting.we_chat.access_token_url,
    params: { grant_type: :client_credential, appid: self.app_id, secret: self.app_secret } do |response, request|
      result = JSON.parse(response.body).symbolize_keys
      self.access_token = result[:access_token]
      self.expires_in = result[:expires_in]
      self.save
    end
  end

  def menus_json
    {
      "button" => menus.roots.non_deleted.each do |menu|
        Jbuilder.encode do |js|
          js.name menu.name
          if menu.subs.count.zero?
            js.type %(text resource).include?(menu.category.to_s) ? 'click' : 'view'
            js.key menu.id if %(text resource).include?(menu.category.to_s)
            js.url menu.body if %(view).include?(menu.category.to_s)
          else
            js.sub_button menu.subs.non_deleted do |sub_menu|
              js.name sub_menu.name
              js.type %(text resource).include?(sub_menu.category.to_s) ? 'click' : 'view'
              js.key sub_menu.id if %(text resource).include?(sub_menu.category.to_s)
              js.url sub_menu.body if %(view).include?(sub_menu.category.to_s)
            end
          end
        end
      end
    }
  end

  def create_menus
    refresh_access_token if access_token_expires?
    RestClient.post "#{Setting.we_chat.menus.create}?access_token=#{access_token}", menus_json do |response|
      return JSON.parse(response.body).symbolize_keys
    end
  end

  def get_menus
    refresh_access_token if access_token_expires?
    RestClient.get Setting.we_chat.menus.show, params: { access_token: access_token } do |response|
      return JSON.parse(response.body).symbolize_keys
    end
  end

  def destroy_menus
    refresh_access_token if access_token_expires?
    RestClient.get Setting.we_chat.menus.destroy, params: { access_token: access_token } do |response|
      return JSON.parse(response.body).symbolize_keys
    end
  end

  def get_member_info(open_id)
    refresh_access_token if access_token_expires?
    RestClient.get Setting.we_chat.member_info, params: { access_token: access_token, openid: open_id } do |response|
      return JSON.parse(response.body).symbolize_keys
    end
  end

  private
  def build_token
    self.token = "#{SecureRandom.hex(15)}" if self.token.blank?
  end

  def update_access_token_at
    self.updated_access_token_at = DateTime.now if self.access_token_changed?
  end

  def generate_system_replies
    Setting.system_messages.each do |k, v|
      reply = self.replies.new number: v.to_s, name: I18n.t("system_messages.#{k}")
      reply.is_system = true
    end
  end
end
