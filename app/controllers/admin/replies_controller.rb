class Admin::RepliesController < Admin::ApplicationController

  add_breadcrumb :index, :admin_replies_path

  skip_authorization_check only: [:resources, :map]

  before_filter :find_reply, only: [:show, :edit, :update, :destroy, :assign, :qrcode, :create_qrcode, :cancel_qrcode]

  def index
    # 授权
    authorize! :read, Reply, message: t('unauthorized.reply_read')

    @replies = current_account.replies.non_system.page(params[:page]).per(Setting.page_size)
    @replies = @replies.where(admin_user_id: current_admin_user) if cannot? :manage, Reply
    if params[:reply].blank?
      @filter = Reply.new
    else
      @filter = Reply.new params[:reply]
      build_filters(params[:reply]).each { |array| @replies = @replies.where array }
    end
  end

  def show
    # 授权
    authorize! :read, @reply, message: t('unauthorized.reply_read')
  end

  def new
    # 授权
    authorize! :create, Reply, message: t('unauthorized.reply_create')

    @reply = current_account.replies.new
  end

  def create
    # 授权
    authorize! :create, Reply, message: t('unauthorized.reply_create')

    @reply = current_account.replies.new params[:reply]
    if @reply.save
      if params[:reply][:resource_ids].present?
        params[:reply][:resource_ids].each_with_index do |id, index|
          ReplyResource.update_all({ order: index + 1 }, { reply_id: @reply.id, resource_id: id })
        end
      end
    end
  end

  def create_qrcode
    # 授权
    authorize! :create_qrcode, Reply, message: t('unauthorized.reply_create_qrcode')

    respond_to do |format|
      format.js do
        if params[:type] != 'rebuild' and @reply.is_exceed_qrcode_limit?
          @result = { result: false, message: t('errors.messages.replies.qrcode_limit') }
        else
          begin
            if params[:type] == 'rebuild'
              build_qrcode
            elsif @reply.build_qrcode_scene_id?
              build_qrcode
            end
            if @reply.save
              @result = { result: true, message: t('successes.messages.replies.qrcode') }
            else
              @result = { result: false, message: t('errors.messages.replies.qrcode') }
            end
          rescue
            @result = { result: false, message: t('errors.messages.replies.qrcode') }
          end
        end
      end
    end
  end

  def cancel_qrcode
    # 授权
    authorize! :cancel_qrcode, Reply, message: t('unauthorized.reply_cancel_qrcode')
    respond_to do |format|
      format.js do
        @reply.scene_delete = true
        if @reply.save
          @result = { result: true, message: t('successes.messages.replies.cancel_qrcode') }
        else
          @result = { result: false, message: t('errors.messages.reply.cancel_qrcode') }
        end
      end
    end

  end

  def edit
    # 授权
    authorize! :update, @reply, message: t('unauthorized.reply_update')
  end

  def update
    # 授权
    authorize! :update, @reply, message: t('unauthorized.reply_update')

    if @reply.update_attributes params[:reply]
      if params[:reply][:resource_ids].present?
        params[:reply][:resource_ids].each_with_index do |id, index|
          ReplyResource.where(reply_id: @reply.id, resource_id: id).each{|r| r.update_attributes(order: index + 1)}
        end
      else
        ReplyResource.where(reply_id: @reply.id).each{|r| r.destroy}
      end
      render :show
    else
      @resources = current_account.resources.where(id: params[:reply][:resource_ids])
    end
  end

  def destroy
    # 授权
    authorize! :destroy, @reply, message: t('unauthorized.reply_destroy')

    @reply.destroy
  end

  def resources
    @reply = if current_account.replies.find_by_id(params[:id]).blank?
      current_account.replies.new
    else
      current_account.replies.find_by_id params[:id]
    end
    @resources = current_account.resources.where(id: params[:resource_ids]) if request.post?
  end

  def map
  end

  def assign
    # 授权
    authorize! :assign, Reply, message: t('unauthorized.reply_assign')

    if request.put?
      @reply.update_attributes params[:reply]
    end
  end

  private
  def find_reply
    @reply = current_account.replies.find params[:id]
    raise ActiveRecord::RecordNotFound unless @reply
  end

  def build_filters params
    params.each_with_object([]) do |(key, value), array|
      next if value.blank?
      array << ["#{key} like ?", "%#{value}%"]
    end
  end

  # 生成二维码图片
  def build_qrcode
    @account = @reply.account
    @account.refresh_access_token if @account.access_token_expires?
    RestClient.post "#{Setting.we_chat.qr_code_url}?access_token=#{@account.access_token}", @reply.build_request_qrcode_json do |response|
      result = JSON.parse(response.body).symbolize_keys
      @reply.ticket = result[:ticket]
    end
  end
end
