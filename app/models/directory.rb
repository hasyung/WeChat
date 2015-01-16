class Directory < Resource

  # Relations
  has_many    :directory_kits
  has_many    :kits, through: :directory_kits
  belongs_to  :admin_user
  belongs_to  :account, counter_cache: true
  has_many   :indents

  audited
  
  # Validates

end
