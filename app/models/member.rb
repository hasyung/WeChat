class Member < ActiveRecord::Base
  include Extension::DataTable

  attr_accessible :open_id, :nickname, :sex, :city, :language, :subscribe

  # SimpleEnum
  as_enum :sex, Setting.enums.sex.dup.symbolize_keys, prefix: true
  as_enum :action, Setting.enums.action.dup.symbolize_keys, prefix: true

  # Relations
  has_many    :messages,  dependent: :destroy
  belongs_to  :account,   counter_cache: true

  # Validates
  validates :open_id, presence: true

end
