module ReplyHelper
  
  def qrcode_link reply
    link_to t('buttons.qrcode_download'), "#{Setting.we_chat.get_qr_code_url}?ticket=#{reply.ticket}", target: '_blank'
  end
  
end