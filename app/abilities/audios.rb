Canard::Abilities.for(:audio) do

  can [:read, :create, :update, :destroy], Audio, admin_user_id: user.id
  can [:read, :create, :update, :destroy], AudioProfile

end