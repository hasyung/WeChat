class Vote < ActiveRecord::Base
  include Extension::DataTable

  # Attributes
  attr_accessible  :account_id, :booth, :open_id, :phone

  # Relations
  belongs_to :account

  # Validates
  validates :account_id, presence: true
  validates :booth,      presence: true
  validates :open_id,    presence: true, uniqueness: true
  validates :phone,      presence: true, uniqueness: true

  # Callbacks
  before_create :set_order

  private
  def set_order
    order = Vote.where(account_id: self.account_id).maximum(:order)
    if order.present?
      self.order = order + 1
    else
      self.order = 1
    end
  end
end
