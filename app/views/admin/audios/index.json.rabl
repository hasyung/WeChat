object false
node(:sEcho) { @data_tables.s_echo }
node(:iTotalRecords) { @data_tables.total_records }
node(:iTotalDisplayRecords) { @data_tables.display_total_records }
child @data_tables.records => :aaData do
  if @data_tables.records.any?
    node(:DT_RowId) { |o| o.id.to_s }
    node(:title) { |o| o.title }
    child :directory do
      attributes :name
    end
    child :audio_profile do
      node(:file) { |o| o.file.url }
    end
    node(:realname_at) { |o| o.admin_user.nil? ? "" : o.admin_user.realname }
    node(:created_at) { |o| I18n.l o.created_at, format: :long }
    node(:actions) { |o| partial('admin/audios/actions', object: o) }
  end
end
