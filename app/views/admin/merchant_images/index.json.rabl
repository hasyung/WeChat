collection @images, :root => false, :object_root => false
node(:name) { |o| o.title }
node(:size) { |o| o.file_size }
node(:url)  { |o| o.file.url }
node(:add_type) { 'get' }
node(:delete_url)  { |o| admin_merchant_merchant_image_path(@merchant, o.id) }
node(:delete_type) { |o| "DELETE" }
