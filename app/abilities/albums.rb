Canard::Abilities.for(:album) do

  can [:read, :create, :update, :destroy], Album, admin_user_id: user.id
  can [:read, :create, :update, :destroy], AlbumProfile

end