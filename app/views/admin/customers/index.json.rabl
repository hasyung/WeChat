object false
node(:sEcho) { @data_tables.s_echo }
node(:iTotalRecords) { @data_tables.total_records }
node(:iTotalDisplayRecords) { @data_tables.display_total_records }
child @data_tables.records => :aaData do
  if @data_tables.records.any?
    node(:DT_RowId) { |o| o.id.to_s }
    node(:name) { |o| o.name }
    node(:identity) { |o| o.identity }
    node(:phone) { |o| o.phone }
    node(:type_cd) { |o| Customer.types_for_select[o.type_cd][0] }
    node(:created_at) { |o| I18n.l o.created_at, format: :long }
    node(:actions) { |o| partial('admin/customers/actions', object: o) }
  end
end
