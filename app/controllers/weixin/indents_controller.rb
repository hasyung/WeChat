class Weixin::IndentsController < Weixin::ApplicationController

  def index
    indents = Indent.includes(:kit, :directory).all
    @models = indents.group_by{|m| m.directory.blank? ? '' : m.directory.title}
    change_models = indents.select{|m| m.type_cd == 3 && m.logistics_code.present? && (DateTime.now.to_i - m.created_at.to_i) >= Setting.kit_exprise_in}
    change_models.each do |model|
      model.update_attributes(type_cd: 4)
    end
    @customer = Customer.find params[:customer_id]
  end

  def show
    @model = Indent.find params[:id]
    @model.update_attributes(type_cd: 4) if @model.type_cd == 3 && @model.logistics_code.present? && (DateTime.now.to_i - @model.created_at.to_i) >= Setting.kit_exprise_in
    @customer = Customer.find params[:customer_id]
  end

  def change
    if request.get?
      @indent = Indent.new
      @kit = Kit.find params[:kit_id]
      @customer = Customer.find params[:customer_id]
    else
      @indent = Indent.new customer_id: params[:customer_id], kit_id: params[:kit_id], directory_id: params[:directory_id], item_count: params[:item_count]
       if @indent.save
        redirect_to weixin_indents_path(customer_id: params[:customer_id]), notice: t('successes.messages.indent.create')
      else
        redirect_to weixin_directory_kit_path(params[:directory_id], params[:kit_id], customer_id: params[:customer_id]), alert: t('errors.messages.indent.create')
      end
    end
  end

  def unpass
    @model = Indent.find params[:id]
    @model.type_cd = 5
    if @model.save
      redirect_to weixin_indents_path(customer_id: params[:customer_id]), notice: t('successes.messages.indent.unpass')
    else
      redirect_to weixin_indents_path(customer_id: params[:customer_id]), alert: t('errors.messages.indent.unpass')
    end
  end

  def checks
    @customer = Customer.find params[:customer_id]
    redirect_to weixin_indents_path(customer_id: @customer), alert: t('errors.messages.indent.check_authority') and return if @customer.type_cd == 0
    @models = Indent.includes(:kit, :directory).where(type_cd: 0).group_by{|m| m.directory.blank? ? '' : m.directory.title}
  end

  def check
    @customer = Customer.find params[:customer_id]
    redirect_to weixin_indents_path(customer_id: @customer), alert: t('errors.messages.indent.check_authority') and return if @customer.type_cd == 0
    @model = Indent.find params[:id]
    if params[:type].present?
      @model.type_cd = params[:type].to_i == 1 ? 1 : 2
      if @model.save
        redirect_to checks_weixin_indents_path(customer_id: params[:customer_id]), notice: t('successes.messages.indent.check')
      else
        redirect_to checks_weixin_indents_path(customer_id: params[:customer_id]), alert: t('errors.messages.indent.check')
      end
    end
  end

  def records
    @customer = Customer.find params[:customer_id]
    redirect_to weixin_indents_path(customer_id: @customer), alert: t('errors.messages.indent.check_authority') and return if @customer.type_cd == 0
    @models = Indent.includes(:kit, :directory).where("type_cd in (?)", [1, 3, 4]).group_by{|m| m.directory.blank? ? '' : m.directory.title}
  end
end