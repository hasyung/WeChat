Canard::Abilities.for(:article) do

  can [:read, :create, :update, :destroy], Article, admin_user_id: user.id
  can [:read, :create, :update, :destroy], ArticleProfile

end