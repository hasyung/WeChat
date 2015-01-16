object false
node(:sEcho) { @data_tables.s_echo }
node(:iTotalRecords) { @data_tables.total_records }
node(:iTotalDisplayRecords) { @data_tables.display_total_records }
child @data_tables.records => :aaData do
  if @data_tables.records.any?
    node(:DT_RowId) { |o| o.id.to_s }
    node(:code) { |o| o.code }
    child :customer do
      node(:name) { |o| o.name }
    end
    child :kit do
      node(:title) { |o| o.title }
    end
    child :directory do
      node(:title) { |o| o.title }
    end
    node(:item_count) { |o| o.item_count }
    node(:price_count) { |o| o.price_count }
    node(:type_cd) { |o| Indent.types_for_select[o.type_cd][0] }
    node(:created_at) { |o| I18n.l o.created_at, format: :long }
    node(:actions) { |o| partial('/admin/indents/actions', object: o) }
  end
end
