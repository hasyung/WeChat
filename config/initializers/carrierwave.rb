CarrierWave.configure do |config|
  config.storage = :file
  config.asset_host = Setting.upload_url
  config.directory_permissions = 0777
  config.permissions = 0666
end
