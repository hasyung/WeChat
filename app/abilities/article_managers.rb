Canard::Abilities.for(:article_manager) do

  can :manage, Article
  can :manage, ArticleProfile

end