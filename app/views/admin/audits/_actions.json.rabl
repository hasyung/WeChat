object false
node(:html) do
  show_link = link_to polymorphic_url([:admin, data]), class: 'btn btn-small btn-inverse', \
  data: { toggle: 'tooltip' }, title: t("buttons.show"), remote: true do
    content_tag :i, '', class: 'icon-eye-open'
  end
end