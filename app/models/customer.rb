class Customer < ActiveRecord::Base
  
  include Extension::DataTable

  attr_accessible :name, :identity, :phone, :department, :address_attributes

  # Relations
  has_one     :member,  inverse_of: :customer
  has_one     :address, dependent: :destroy, inverse_of: :customer, :autosave => true
  belongs_to  :admin_user

  audited

  # Validates
  validates :name, :identity, :phone, presence: true
  with_options if: :name? do |customer|
    customer.validates :name, length: { in: 2..10 }
  end
  with_options if: :identity? do |customer|
    customer.validates :identity, length: { in: 15..18 }
    customer.validates :identity, format: { with: /^[a-zA-Z]?\d+$/ }
  end
  with_options if: :phone? do |customer|
    customer.validates :phone, length: { in: 6..15 }
    customer.validates :phone, format: { with: /^\d+$/ }
  end
  with_options if: :department? do |customer|
    customer.validates :department, length: { in: 2..50 }
  end

  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: proc { |att| att['name'].blank? && att['phone'].blank? && att['address'].blank? }

end
