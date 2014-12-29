Canard::Abilities.for(:system_reply) do

  can [:read, :update], Reply, is_system: true
  
  can :system, Reply

end