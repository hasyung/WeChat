require 'rabl'
Rabl.configure do |config|
  config.include_json_root = false
  config.include_bson_root = false
  config.include_child_root = false
  config.include_xml_root = false
end