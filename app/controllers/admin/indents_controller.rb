class Admin::IndentsController < Admin::ApplicationController

  before_filter :add_breadcrumbs
  before_filter :find_indent, only: [:edit, :update, :destroy]

  def index
    # 授权
    authorize! :read, Indent, message: t('unauthorized.indent_read')
    
    @indent = Indent.new
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

  def export
    # 授权
    authorize! :read, Indent, message: t('unauthorized.indent_read')

    if params[:indent][:start_date].blank? || params[:indent][:end_date].blank?
      redirect_to admin_indents_path, notice: t('errors.messages.indent.date_null')
    else
      @type_cd = params[:indent][:type_cd]
      @start_date = params[:indent][:start_date].to_date
      @end_date = params[:indent][:end_date].to_date

      filename = (@start_date.to_s + @end_date.to_s).gsub("-","").strip
      filename = @type_cd.blank? ? filename + "X" : filename + @type_cd
      FileUtils.mkdir_p("export/indents/") unless File.directory?("export/indents/")
      path = "export/indents/#{filename}.xls"
      unless File.exist?(path)
        indents = Indent.where data_search
        if indents.blank?
          redirect_to admin_indents_path, alert: t('errors.messages.indent.nil_data')
          return
        end
        Indent.export_indents_file indents, filename, @start_date.to_s, @end_date.to_s
      end
      send_file path
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

  def data_search
    if @type_cd.blank?
      ["created_at >= ? and created_at <= ?", @start_date, @end_date]
    else
      ["created_at >= ? and created_at <= ? and type_cd = ?", @start_date, @end_date, @type_cd]
    end
  end
end
