class ReplyResource < ActiveRecord::Base

  attr_accessible :reply_id, :resource_id, :order

  # Relations
  belongs_to :reply, counter_cache: true
  belongs_to :resource

  audited associated_with: :reply

end
