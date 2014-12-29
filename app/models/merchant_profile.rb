class MerchantProfile < ActiveRecord::Base
  attr_accessible :type_cd, :url, :body

  as_enum :type, Setting.enums.merchant.dup.symbolize_keys, prefix: true

  belongs_to :merchant

  audited associated_with: :merchant

  validates :type_cd, presence: true
  validates :body, presence: true, if: ->(m) { m.url.blank? }
  validates :url, format: /http:\/\/([\w-]+\.)+[\w-]+(.*)?/, if: ->(m) { m.url.present? }
end
