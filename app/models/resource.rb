class Resource < ActiveRecord::Base

  include Extension::DataTable
  include Extension::Uploader

  attr_accessible :title, :description, :account_id, :cover, :type, :admin_user_id

  # Relations
  belongs_to :account

  # Extension::Uploader
  uploader_image :cover, WeiXinCoverUploader, size: Setting.image_upload_size

  # Validates
  validates :title, :cover, :account_id, presence: true
  with_options if: :title? do |resource|
    resource.validates :title, length: { in: 2..100 }
  end
  with_options if: :description? do |resource|
    resource.validates :description, length: { in: 1..1000 }
  end

end
