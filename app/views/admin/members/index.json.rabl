object false
node(:sEcho) { @data_tables.s_echo }
node(:iTotalRecords) { @data_tables.total_records }
node(:iTotalDisplayRecords) { @data_tables.display_total_records }
child @data_tables.records => :aaData do
  if @data_tables.records.any?
    node(:DT_RowId) { |o| o.id.to_s }
    node(:open_id) { |o| o.open_id }
    node(:nickname) { |o| o.nickname }
    node(:city) { |o| o.city }
    node(:sex_cd) { |o| o.human_sex }
    node(:subscribe) { |o| o.subscribe }
    node(:action_cd) { |o| o.human_action }
    node(:actions) { |o| partial('admin/members/actions', object: o) }
  end
end