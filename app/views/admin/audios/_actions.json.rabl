object false
node(:html) do
  edit_link = link_to polymorphic_url([:admin, data], action: :edit), class: 'btn btn-small btn-inverse', 
  data: { toggle: 'tooltip' }, title: t("buttons.edit") do
    content_tag :i, '', class: 'icon-pencil'
  end
  destroy_link = link_to polymorphic_path([:admin, data]), class: 'btn btn-small btn-inverse', method: :delete,
  data: { confirm: t('messages.confirm_destroy'), toggle: 'tooltip' },
  title: t("buttons.destroy") do
    content_tag :i, '', class: 'icon-trash'
  end
  assign_link = link_to polymorphic_path([:admin, data], action: :assign), class: 'btn btn-small btn-inverse', \
  data: { toggle: 'tooltip' }, title: t("buttons.assign_user"), remote: true do
    content_tag :i, '', class: 'icon-male'
  end
  if can? :manage, Audio
    "#{assign_link}#{edit_link}#{destroy_link}"
  else
    "#{edit_link}#{destroy_link}"
  end
end