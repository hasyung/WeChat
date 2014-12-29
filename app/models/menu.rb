class Menu < ActiveRecord::Base
  
  include Extension::WeiXin::XML
  
  attr_accessible :name, :body, :account_id, :menu_type, :parent_id,
  :category_cd, :action_cd, :soft_delete, :resource_ids
  
  # SimpleEnum
  as_enum :category, Setting.enums.menu_category.dup.symbolize_keys, prefix: true
  as_enum :action, Setting.enums.action.dup.symbolize_keys, prefix: true
  
  # Relations
  has_many    :subs,            class_name: 'Menu', foreign_key: 'parent_id', \
  dependent: :destroy, conditions: { soft_delete: false }, order: '`order` ASC'
  has_many    :menu_resources,  dependent: :destroy
  has_many    :resources,       through: :menu_resources, order: '`order` ASC'
  belongs_to  :account,         counter_cache: true
  belongs_to  :parent,          class_name: 'Menu'

  audited

  # Validates
  validates :name, :account_id, :category_cd, :action_cd, presence: true
  with_options if: :name? do |menu|
    menu.validates :name, length: { maximum: 5 }, if: ->(m) { m.parent_id.zero? }
    menu.validates :name, length: { maximum: 10 }, if: ->(m) { !m.parent_id.zero? }
  end
  with_options if: :body? do |menu|
    menu.validates :body, length: { maximum: 1000 }, if: ->(m) { m.category_text? }
    menu.validates :body, format: /http:\/\/([\w-]+\.)+[\w-]+(.*)?/, if: ->(m) { m.category_view? }
  end
  validate :limit_menu, :limit_sub_menu, on: :create
  
  # Scope
  scope :roots, where(parent_id: 0)
  scope :non_deleted, where(soft_delete: false)
  
  # Callbacks
  before_update :update_attribute
  
  # Methods
  def parent?
    parent_id.zero?
  end
  
  def to_weixin_json
    Jbuilder.encode do |json|
      json.name name
      if subs.count.zero?
        json.type %(text resource).include?(category.to_s) ? 'click' : 'view'
        json.key id if %(text resource).include?(category.to_s)
        json.url body if %(view).include?(category.to_s)
      else
        json.sub_button subs.non_deleted do |sub|
          json.name sub.name
          json.type %(text resource).include?(sub.category.to_s) ? 'click' : 'view'
          json.key sub.id if %(text resource).include?(sub.category.to_s)
          json.url sub.body if %(view).include?(sub.category.to_s)
        end
      end
    end
  end
  
  private
  
  def limit_menu
    if parent_id.zero? and account.menus.roots.non_deleted.count >= Setting.we_chat.limit_menus
      errors.add(:name, I18n.t('errors.messages.menus.limit_menu', count: Setting.we_chat.limit_menus))
    end
  end
  
  def limit_sub_menu
    if !parent_id.zero? and Menu.where(parent_id: parent_id).non_deleted.count >= Setting.we_chat.limit_sub_menus
      errors.add(:name, I18n.t('errors.messages.menus.limit_sub_menu', count: Setting.we_chat.limit_sub_menus))
    end
  end
  
  def update_attribute
    self.resource_ids = [] if self.category_text? or self.category_view?
    self.body = '' if self.category_resource?
  end
end
