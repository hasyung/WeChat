object false
node(:sEcho) { @data_tables.s_echo }
node(:iTotalRecords) { @data_tables.total_records }
node(:iTotalDisplayRecords) { @data_tables.display_total_records }
child @data_tables.records => :aaData do
  if @data_tables.records.any?
    node(:DT_RowId) { |o| o.id.to_s }
    child :member do
      node(:open_id) { |o| o.nickname.present? ? o.nikename : o.open_id }
    end
    node(:category_cd) { |o| message_type_highlight o }
    node(:body) do |o|
      message_render_body o
    end
    node(:created_at) { |o| I18n.l o.created_at, format: :long }
  end
end