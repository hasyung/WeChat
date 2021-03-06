class Indent < ActiveRecord::Base
  include Extension::DataTable

  attr_accessible :customer_id, :kit_id, :directory_id, :item_count, :logistics, :logistics_code, :freight, :type_cd, :price_count

  attr_accessor   :start_date, :end_date

  # Relations
  belongs_to  :customer
  belongs_to  :kit
  belongs_to  :directory

  audited
  
  # Scopes
  default_scope order("created_at DESC")

  as_enum :type, Setting.enums.indent_type.dup.symbolize_keys, prefix: true

  before_create :set_code
  before_save   :set_price_count

  # Validates
  validates :customer_id, :kit_id, :item_count, presence: true
  with_options if: :code? do |indent|
    indent.validates :code, uniqueness: true
  end

  def self.export_indents_file indents, filename, start_date, end_date
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet name: I18n.t('breadcrumbs.admin.indents.index')
    sheet.row(0).default_format = Spreadsheet::Format.new :color => :blue,
                                                          :weight => :bold,
                                                          :size => 18,
                                                          :align => :center
    sheet.row(0).height = 28
    sheet.merge_cells 0, 0, 0, 9
    sheet.row(0).push "从#{start_date}到#{end_date}"+I18n.t('breadcrumbs.admin.indents.index')
    sheet.row(1).height = 22

    sheet.column(0).default_format.align = :center
    sheet.column(0).width = sheet.row(indents.count + 2).height = 25
    sheet.row(1).push I18n.t('activerecord.attributes.indent.code')
    sheet.column(1).width = 15
    sheet.row(1).push I18n.t('activerecord.attributes.indent.kit')
    sheet.column(2).width = 10
    sheet.row(1).push I18n.t('activerecord.attributes.indent.directory')
    sheet.column(3).width = 10
    sheet.row(1).push I18n.t('activerecord.attributes.indent.item_count')
    sheet.column(4).width = 15
    sheet.row(1).push I18n.t('activerecord.attributes.indent.customer')
    sheet.column(5).width = 10
    sheet.row(1).push I18n.t('activerecord.attributes.indent.type_cd')
    sheet.column(6).width = 25
    sheet.row(1).push I18n.t('activerecord.attributes.indent.logistics_code')
    sheet.column(7).width = 16
    sheet.row(1).push I18n.t('activerecord.attributes.indent.freight')
    sheet.column(8).width = 15
    sheet.row(1).push I18n.t('activerecord.attributes.indent.created_at')
    sheet.column(9).width = 16
    sheet.row(1).push I18n.t('activerecord.attributes.indent.price_count')
    count = 0
    indents.each_with_index do |indent, index|
      sheet.row(index+2).height = 18
      sheet.row(index+2).push indent.code
      sheet.row(index+2).push indent.kit.title
      sheet.row(index+2).push indent.directory.title
      sheet.row(index+2).push indent.item_count
      sheet.row(index+2).push indent.customer.name
      sheet.row(index+2).push Indent.types_for_select[indent.type_cd][0]
      sheet.row(index+2).push indent.logistics_code
      sheet.row(index+2).push indent.freight
      sheet.row(index+2).push indent.created_at.to_date.to_s
      sheet.row(index+2).push indent.price_count
      count += indent.price_count
    end

    sheet.merge_cells indents.count + 2, 0, indents.count + 2, 8
    sheet.row(indents.count + 2).default_format = Spreadsheet::Format.new :color => :red,
                                                                          :weight => :bold,
                                                                          :size => 18,
                                                                          :align => :right
    sheet.row(indents.count + 2).push I18n.t('activerecord.attributes.indent.count') + "： "
    sheet.row(indents.count + 2).insert 9, "#{count}"

    book.write "export/indents/#{filename}.xls"
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
    self.price_count = self.kit.price * self.item_count - self.freight if self.price_count.blank? || !self.new_record?
    self.type_cd = 0 if self.type_cd.blank?
  end
  
end
