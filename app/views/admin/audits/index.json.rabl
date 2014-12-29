object false
node(:sEcho) { @data_tables.s_echo }
node(:iTotalRecords) { @data_tables.total_records }
node(:iTotalDisplayRecords) { @data_tables.display_total_records }
child @data_tables.records => :aaData do
  if @data_tables.records.any?
    node(:DT_RowId) { |o| o.id.to_s }
    node(:user_id) { |o| o.user.blank? ? "" : o.user.realname }
    node(:auditable_type) { |o| o.auditable_type.constantize.model_name.human if o.auditable_type.present? }
    node(:auditable_id) { |o| o.auditable_id }
    node(:action) { |o| t("activerecord.enums.audit.actions.#{o.action}") }
    node(:version) { |o| o.version }
    node(:created_at) { |o| I18n.l o.created_at, format: :long }
    node(:actions) { |o| partial('admin/audits/actions', object: o) }
  end
end