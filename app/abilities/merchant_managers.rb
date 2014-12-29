Canard::Abilities.for(:merchant_manager) do

  can :manage, Merchant
  can :manage, MerchantProfile

end