class Admin::IndentsController < Admin::ApplicationController

  before_filter :add_breadcrumbs
  before_filter :find_indent, only: [:edit, :update, :destroy]

  def index
    # 授权
    authorize! :read, Indent, message: t('unauthorized.indent_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = Indent.includes([:customer, :kit]).to_datatable(self)
        render layout: false
      end
    end
  end

  def new
    # 授权
    authorize! :create, Indent, message: t('unauthorized.indent_create')
    
    add_breadcrumb :new
    @indent = Indent.new
  end

  def create
    # 授权
    authorize! :create, Indent, message: t('unauthorized.indent_create')
    
    @indent = Indent.new params[:indent]
    if @indent.save
      redirect_to admin_indents_path, notice: t('successes.messages.indent.create')
    else
      add_breadcrumb :new
      render :new
    end
  end

  def edit
    # 授权
    authorize! :update, Indent, message: t('unauthorized.indent_update')
    
    add_breadcrumb :edit
  end

  def update
    # 授权
    authorize! :update, Indent, message: t('unauthorized.indent_update')
    
    if @indent.update_attributes(params[:indent])
      redirect_to admin_indents_path, notice: t('successes.messages.indent.update')
    else
      add_breadcrumb :edit
      render :edit
    end
  end

  def destroy
    # 授权
    authorize! :destroy, Indent, message: t('unauthorized.indent_destroy')
    
    if @indent.destroy
      redirect_to admin_indents_path, notice: t('successes.messages.indent.destroy')
    else
      redirect_to admin_indents_path, alert: t('errors.messages.indent.destroy')
    end
  end

  private

  def find_indent
    @indent = Indent.find params[:id]
    raise ActiveRecord::RecordNotFound unless @indent
  end

  def add_breadcrumbs
    add_breadcrumb :index, admin_indents_path
  end
end
