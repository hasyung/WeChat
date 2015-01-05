class AdminUser < ActiveRecord::Base

  include Extension::DataTable
  include Extension::Uploader

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :captcha, :avatar, :realname, :roles

  attr_accessor :captcha, :current_password
  
  acts_as_user roles: Setting.admin_user_roles.map { |role| role.to_sym }

  #audited only: [:email, :password, :avatar, :realname]

  uploader_image :avatar, AvatarUploader, size: Setting.image_upload_size
  
  has_many :replies
  has_many :audios
  has_many :articles
  has_many :albums

  has_many :kits
  has_many :directories

  validates :email, presence: true
  validates :realname, presence: true, length: { in: 2..60 }

end
