object false
child [@image] => 'files' do
  node(:name) { |o| o.title.blank? ? params[:image][:file].original_filename : o.title }
  node(:size) { |o| o.file_size }
  node(:url)  { |o| o.file.url }
  node(:add_type) { 'get' }
  node(:delete_url)  { |o| admin_album_image_path(@album, o.id) }
  node(:delete_type) { |o| "DELETE" }
end
