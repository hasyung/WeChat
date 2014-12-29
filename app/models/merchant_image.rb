class MerchantImage < ActiveRecord::Base
  include Extension::Uploader
  include Extension::DataTable

  attr_accessible :file, :title, :order

  # Extension::Uploader
  uploader_image :file, PictureUploader, size: Setting.image_upload_size

  # Relations
  belongs_to :merchant

  default_scope order("`order` ASC")

  before_create do
    self.order = MerchantImage.where(merchant_id: self.merchant_id).count + 1
  end

  def to_jq_images(type, type_id)
    {
      'name' => read_attribute(:title),
      'size' => read_attribute(:file_size),
      "url"  => self.file.url,
      "add_type" => "get",
      "delete_url" => "/admin/images/#{id}?type=#{type}&type_id=#{type_id}",
      "delete_type" => "DELETE"
    }
  end
end