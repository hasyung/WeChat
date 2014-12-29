Canard::Abilities.for(:album_manager) do

  can :manage, Album
  can :manage, AlbumProfile

end