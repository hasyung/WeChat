class Indent < ActiveRecord::Base
  include Extension::DataTable

  attr_accessible :customer_id, :kit_id, :item_count, :logistics, :logistics_code, :freight, :type_cd

  # Relations
  belongs_to  :customer
  belongs_to  :kit

  audited

  as_enum :type, Setting.enums.indent_type.dup.symbolize_keys, prefix: true

  before_create :set_code
  before_save   :set_price_count

  # Validates
  validates :customer_id, :kit_id, :item_count, presence: true
  with_options if: :code? do |indent|
    indent.validates :code, uniqueness: true
  end

  private
  def set_code
  	code = Time.now.to_i
    if Indent.find_by_code(code).blank?
      self.code = code
    else
      self.set_code
    end
  end

  def set_price_count
    self.price_count = self.kit.price * self.item_count - self.freight
  end
  
end
