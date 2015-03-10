class Customer < ActiveRecord::Base
  require 'spreadsheet'
  include Extension::DataTable
  include ActiveModel::Validations

  attr_accessible :name, :identity, :phone, :department, :address_attributes, :type_cd
  attr_accessor   :import_file

  # Relations
  has_one     :member,  inverse_of: :customer
  has_one     :address, dependent: :destroy, inverse_of: :customer, :autosave => true
  belongs_to  :admin_user
  has_many    :indents

  audited

  as_enum :type, Setting.enums.customer_type.dup.symbolize_keys, prefix: true

  # Validates
  validate do
    errors.add(:identity, "长度为15或18") if self.identity.length != 15 && self.identity.length != 18
  end

  validates :name, :identity, :phone, presence: true
  with_options if: :name? do |customer|
    customer.validates :name, length: { in: 2..10 }
  end
  with_options if: :identity? do |customer|
    customer.validates :identity, uniqueness: true
    customer.validates :identity, format: { with: /^[a-zA-Z\d]+$/ }
  end
  with_options if: :phone? do |customer|
    customer.validates :phone, length: { in: 6..15 }
    customer.validates :phone, format: { with: /^\d+$/ }
  end
  with_options if: :department? do |customer|
    customer.validates :department, length: { in: 2..50 }
  end

  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: proc { |att| att['name'].blank? && att['phone'].blank? && att['address'].blank? }

  def import_excel_file
    return I18n.t('errors.messages.fileupload.not_null') if self.import_file.blank?
    f = self.import_file.original_filename
    return I18n.t('errors.messages.fileupload.accept_file_types') unless Setting.upload_excel_extension.include?(f[f.length-3, f.length])
    
    Customer.transaction do
      Spreadsheet.client_encoding = 'UTF-8'
      book = Spreadsheet.open self.import_file.tempfile
      sheet = book.worksheet 0
      sheet.each_with_index do |row, index|
        cus = Customer.create name: row[0], identity: row[1], phone: row[2], department: row[3]
        return I18n.t('errors.messages.some_row_errors', index: index + 1) if cus.errors.messages.size > 0
      end
    end
    return
  end

end
