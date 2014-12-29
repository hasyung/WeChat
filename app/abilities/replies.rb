Canard::Abilities.for(:reply) do

  can [:update, :destroy], Reply, admin_user_id: user.id
  
  can [:read, :create], Reply
  
end