Canard::Abilities.for(:customer) do

  can :manage, Customer
  can :manage, Address

end