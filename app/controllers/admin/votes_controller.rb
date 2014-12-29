class Admin::VotesController < Admin::ApplicationController

  skip_authorization_check only: [:destroy]

  def index
    # 授权
    authorize! :read, Vote, message: t('unauthorized.vote_read')

    respond_to do |format|
      format.html
      format.json do
        @data_tables = current_account.votes.to_datatable(self)
        render layout: false
      end
    end
  end

  def export
    # 授权
    authorize! :manage, Vote, message: t('unauthorized.vote_manage')

    @votes = Vote.all
    respond_to do |format|
      format.xls do
        stream = render_to_string(partial: "export.xls")
        send_data(stream, filename: "votes.xls")
      end
      format.xml do
        stream = render_to_string(partial: "export.xml")
        send_data(stream, filename: "phone.xml")
      end
    end
  end

  def setting
    # 授权
    authorize! :manage, Vote, message: t('unauthorized.vote_manage')

    if request.put?
      current_account.vote_switch_cd  = params[:account][:vote_switch_cd]
      current_account.vote_time_start = params[:account][:vote_time_start]
      current_account.vote_time_end   = params[:account][:vote_time_end]
      if current_account.save
        redirect_to setting_admin_votes_path, notice: t('successes.messages.votes.save')
      else
        render :setting
      end
    end
  end

  def destroy
    @vote = Vote.find params[:id]
     if @vote.destroy
       redirect_to admin_votes_path
     else
       redirect_to admin_votes_path
     end
  end

end