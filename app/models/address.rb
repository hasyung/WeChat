class Address < ActiveRecord::Base

  attr_accessible :name, :phone, :address, :postcode

  # Relations
  belongs_to  :customer,  inverse_of: :address

  audited associated_with: :customer

  # Validates
  validates :name, :phone, :address, presence: true
  with_options if: :name? do |address|
    address.validates :name, length: { in: 2..10 }
  end
  with_options if: :phone? do |address|
    address.validates :phone, length: { in: 6..15 }
    address.validates :phone, format: { with: /^\d+$/ }
  end
  with_options if: :address? do |address|
    address.validates :address, length: { in: 2..100 }
  end
  with_options if: :postcode? do |address|
    address.validates :postcode, length: { is: 6 }
    address.validates :postcode, format: { with: /^\d+$/ }
  end
end
