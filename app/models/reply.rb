class Reply < ActiveRecord::Base

  include Extension::WeiXin::XML

  attr_accessible :body, :name, :number, :tag_list, :account_id, :category_cd, :parent_id, :resource_ids, :lng, :lat, :admin_user_id

  acts_as_taggable
  acts_as_mappable default_units: :kms, default_formula: :sphere, distance_field_name: Setting.distance,
    lat_column_name: :lat, lng_column_name: :lng

  as_enum :category, Setting.enums.reply_category.dup.symbolize_keys, prefix: true

  # Relations
  has_many    :subs,             class_name: 'Reply', foreign_key: 'parent_id', dependent: :destroy
  has_many    :reply_resources,  dependent: :destroy
  has_many    :resources,        through: :reply_resources, order: '`reply_resources`.`order` ASC'
  belongs_to  :account,          counter_cache: true
  belongs_to  :parent,           class_name: 'Reply'
  belongs_to  :admin_user

  audited

  # Validates
  validates :number, :name, :category_cd, :account_id, :parent_id, presence: true
  validates :number, uniqueness: { scope: :account_id }
  validates :body, presence: true, if: ->(m) { m.category_text? and !m.is_system? }
  with_options if: :is_system? do |reply|
    validates :number, format: { with: /^\-?[a-zA-Z]?\d+$/ }, if: ->(m) { m.number.present? }
  end
  with_options unless: :is_system? do |reply|
    reply.validates :number, length: { maximum: 8 }, if: ->(m) { m.number.present? }
    reply.validates :number, format: { with: /^[a-zA-Z]?\d+$/ }, if: ->(m) { m.number.present? }
    reply.validates :scene_id, numericality: { less_than_or_equal_to: Setting.we_chat.limit_qr_code }, on: :update
  end
  with_options if: :name? do |reply|
    reply.validates :name, length: { maximum: 20 }
  end
  with_options if: :body? do |reply|
    reply.validates :body, length: { maximum: 1000 }
  end

  validates :resource_ids, length: { in: 1..10, message: I18n.t('messages.replies.resources') }, if: ->(m) { m.category_resource? }

  # Scopes
  scope :non_system, where(is_system: false)
  scope :is_system, where(is_system: true)
  scope :location, where('`lng` IS NOT NULL and `lat` IS NOT NULL')


  # Callbacks
  before_save :update_attribute

  # Methods
  def update_attribute
    self.resource_ids = [] if self.category_text?
    self.body = '' if self.category_resource?
  end

  def build_request_qrcode_json
    Jbuilder.encode do |json|
      json.action_name 'QR_LIMIT_SCENE'
      json.action_info do
        json.scene do
          json.scene_id self.scene_id
        end
      end
    end
  end

  def is_exceed_qrcode_limit?
    self.account.replies.where(["scene_id > ?", 0]).where(scene_delete: false).count >= Setting.we_chat.limit_qr_code
  end

  def build_qrcode_scene_id?
    return (cancel_scene_delete? or replace_other_scene_delete? or !scene_id_inc.zero?)
  end

  private
  # 取消自身软删除
  def cancel_scene_delete?
    self.scene_delete = false if !self.scene_id.zero? and self.ticket.present?
    return (!self.scene_id.zero? and self.ticket.present?)
  end

  # 替换其它软删除
  def replace_other_scene_delete?
    reply = self.account.replies.where(scene_delete: true).where(["scene_id > 0 and scene_id <= ?", Setting.we_chat.limit_qr_code]).reorder('scene_id ASC').first
    if reply.present?
      self.scene_id, self.ticket, self.scene_delete = reply.scene_id, reply.ticket, false
      reply.scene_id, reply.ticket = 0, ''
      raise ArgumentError if !reply.save and reply.errors.any?
      return true
    end
    return false
  end

  # 二维码id自增
  def scene_id_inc
    max_id = self.account.replies.maximum(:scene_id) + 1
    if max_id > Setting.we_chat.limit_qr_code
      scene_ids = self.account.replies.select('scene_id').where(["scene_id > 0 and scene_id <= ?", Setting.we_chat.limit_qr_code])
      self.scene_id = ((1..Setting.we_chat.limit_qr_code).to_a - scene_ids.map(&:scene_id)).first
    else
      self.scene_id = max_id
    end
    return self.scene_id
  end

end
