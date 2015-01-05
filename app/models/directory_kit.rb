class DirectoryKit < ActiveRecord::Base
  # Relations
  belongs_to    :directory
  belongs_to    :kit
end
