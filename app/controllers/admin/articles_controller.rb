class Admin::ArticlesController < Admin::ApplicationController

  before_filter :add_breadcrumbs
  before_filter :find_article, only: [:edit, :update, :destroy, :assign]

  def index
    # 授权
    authorize! :read, Article, message: t('unauthorized.article_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = current_account.articles.includes(:directory)
        @data_tables = @data_tables.where(admin_user_id: current_admin_user.id) if cannot? :manage, Article
        @data_tables = @data_tables.to_datatable(self)
        render layout: false
      end
    end
  end

  def new
    # 授权
    authorize! :create, Article, message: t('unauthorized.article_create')
    
    add_breadcrumb :new
    @article = current_account.articles.new
  end

  def create
    # 授权
    authorize! :create, Article, message: t('unauthorized.article_create')
    
    add_breadcrumb :new
    @article = current_account.articles.new params[:article]
    if @article.save
      redirect_to admin_articles_path, notice: t('successes.messages.articles.create')
    else
      render :new
    end
  end

  def edit
    # 授权
    authorize! :update, @article, message: t('unauthorized.article_update')
    
    add_breadcrumb :edit
  end

  def update
    # 授权
    authorize! :update, @article, message: t('unauthorized.article_update')
    
    if @article.update_attributes params[:article]
      redirect_to admin_articles_path, notice: t('successes.messages.articles.update')
    else
      add_breadcrumb :edit
      render :edit
    end
  end

  def destroy
    # 授权
    authorize! :destroy, @article, message: t('unauthorized.article_destroy')
    
    if @article.destroy
      redirect_to admin_articles_path, notice: t('successes.messages.articles.destroy')
    else
      redirect_to admin_articles_path, alert: t("errors.messages.articles.destroy")
    end
  end
  
  def assign
    # 授权
    authorize! :assign, Article, message: t('unauthorized.article_assign')
    
    if request.put?
      @article.update_attributes params[:article]
    end
  end

  private

  def find_article
    @article = Article.find params[:id]
    raise ActiveRecord::RecordNotFound unless @article
  end

  def add_breadcrumbs
    add_breadcrumb I18n.t('breadcrumbs.admin.resources.application.index'), admin_articles_path
    add_breadcrumb :index, admin_articles_path
  end

end