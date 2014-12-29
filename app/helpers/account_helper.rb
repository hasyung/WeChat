module AccountHelper
  
  def access_token_expires? account
    if (DateTime.now.to_i - account.updated_access_token_at.to_i) >= account.expires_in
      t('messages.valid')
    else
      t('messages.expires')
    end
  end
  
end