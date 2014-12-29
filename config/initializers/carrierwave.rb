if Rails.env.test? or Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
    config.asset_host = Setting.upload_url
    config.directory_permissions = 0777
    config.permissions = 0666
  end
end

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :ftp
    config.ftp_host = 'assets.1trip.me'
    config.ftp_port = 21
    config.ftp_user = 'uploader'
    config.ftp_passwd = '123123'
    config.ftp_folder = ''
    config.ftp_url = 'http://assets.1trip.me'
  end
end