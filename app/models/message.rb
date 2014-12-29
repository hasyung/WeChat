class Message < ActiveRecord::Base
  include Extension::DataTable

  attr_accessible :body, :category

  # SimpleEnum
  as_enum :category, Setting.enums.message_categroy.dup.symbolize_keys, prefix: true

  #Relations
  belongs_to :member, counter_cache: true

  #Methods
  def body
    begin
      JSON.parse(super).symbolize_keys
    rescue Exception => e
      {}
    end
  end
end
