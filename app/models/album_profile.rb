class AlbumProfile < ActiveRecord::Base
  attr_accessible :type_cd

  as_enum :type, Setting.enums.album.dup.symbolize_keys, prefix: true

  belongs_to :album

  audited associated_with: :album

  validates :type_cd, presence: true
end
