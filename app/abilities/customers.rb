Canard::Abilities.for(:customer) do

  can [:read, :create, :update, :destroy], Customer, admin_user_id: user.id
  can [:read, :create, :update, :destroy], Address

end