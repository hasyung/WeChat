object false
node(:html) do
  destroy_link = link_to polymorphic_path([:admin, data]), class: 'btn btn-small btn-inverse', method: :delete,
  data: { confirm: t('messages.confirm_destroy'), toggle: 'tooltip' },
  title: t("buttons.destroy") do
    content_tag :i, '', class: 'icon-trash'
  end
  info_link = link_to info_admin_member_path(data), class: 'btn btn-small btn-inverse', remote: true,
  title: t("buttons.destroy") do
    content_tag :i, '', class: 'icon-info'
  end
  can?(:destroy, Member) ? "#{destroy_link}" : ""
end