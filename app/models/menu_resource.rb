class MenuResource < ActiveRecord::Base
  
  # Relations
  belongs_to :menu,     counter_cache: true
  belongs_to :resource
  
end
