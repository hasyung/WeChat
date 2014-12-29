Canard::Abilities.for(:kit) do

  can [:read, :create, :update, :destroy], Kit, admin_user_id: user.id
  can [:read, :create, :update, :destroy], KitProfile

end