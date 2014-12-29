object false
node(:sEcho) { @data_tables.s_echo }
node(:iTotalRecords) { @data_tables.total_records }
node(:iTotalDisplayRecords) { @data_tables.display_total_records }
child @data_tables.records => :aaData do
  if @data_tables.records.any?
    node(:DT_RowId) { |o| o.id.to_s }
    attributes :email, :realname, :sign_in_count, :current_sign_in_ip, :last_sign_in_ip
    node(:created_at) { |o| I18n.l o.created_at, format: :long }
    node(:current_sign_in_at) do |o|
      o.current_sign_in_at.present? ? I18n.l(o.current_sign_in_at, format: :long) : ""
    end
    node(:last_sign_in_at) do |o|
      o.last_sign_in_at.present? ? I18n.l(o.last_sign_in_at, format: :long) : ""
    end
    node(:actions) { |o| partial('admin/commons/actions', object: o) }
  end
end