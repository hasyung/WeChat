object false
node(:html) do
  destroy_link = link_to admin_kit_image_path(@kit, data), class: 'btn btn-small btn-inverse', method: :delete,
  data: { confirm: t('messages.confirm_destroy'), toggle: 'tooltip' },
  title: t("buttons.destroy") do
    content_tag :i, '', class: 'icon-trash'
  end
  "#{destroy_link}"
end