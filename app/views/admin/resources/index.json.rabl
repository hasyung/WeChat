object false
node(:sEcho) { @data_tables.s_echo }
node(:iTotalRecords) { @data_tables.total_records }
node(:iTotalDisplayRecords) { @data_tables.display_total_records }
child @data_tables.records => :aaData do
  if @data_tables.records.any?
    node(:DT_RowId) { |o| o.id.to_s }
    node(:title) { |o| truncate o.title, length: 30 }
    node(:type) { |o| o.type.constantize.model_name.human }
    node(:created_at) { |o| I18n.l o.created_at, format: :long }
  end
end