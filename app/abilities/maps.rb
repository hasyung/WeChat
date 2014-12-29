Canard::Abilities.for(:map) do

  can [:read, :create, :update, :destroy], Map, admin_user_id: user.id
  can [:read, :create, :update, :destroy], MapProfile

end