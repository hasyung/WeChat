class Resource < ActiveRecord::Base

  include Extension::DataTable
  include Extension::Uploader

  attr_accessible :title, :description, :account_id, :cover, :cover_cache, :type, :admin_user_id, :price

  # Relations
  belongs_to :account

  # Extension::Uploader
  uploader_image :cover, WeiXinCoverUploader, size: Setting.image_upload_size

  # Validates
  validates :title, :cover, :account_id, :price, presence: true
  with_options if: :title? do |resource|
    resource.validates :title, length: { in: 2..100 }
  end
  with_options if: :description? do |resource|
    resource.validates :description, length: { in: 1..1000 }
  end
  with_options if: :price? do |price|
    price.validates :price,numericality:{greater_than: 0,less_than_or_equal_to: 99999}
  end

end
