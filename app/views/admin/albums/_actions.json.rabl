object false
node(:html) do
  picture_link = link_to admin_album_images_path(data), remote: true, class: 'btn btn-small btn-inverse',
  data: { toggle: 'tooltip' }, title: t("buttons.images") do
    content_tag :i, '', class: 'icon-picture'
  end
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
  
  if can? :manage, Album
    "#{assign_link}#{picture_link}#{edit_link}#{destroy_link}"
  else
    "#{picture_link}#{edit_link}#{destroy_link}"
  end
end