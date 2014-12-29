Canard::Abilities.for(:merchant) do

  can [:read, :create, :update, :destroy], Merchant, admin_user_id: user.id
  can [:read, :create, :update, :destroy], MerchantProfile

end