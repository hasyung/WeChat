# encoding : utf-8
class Api::V1::AccountsController < Api::ApplicationController

  before_filter :fault_request
  before_filter :find_account, :authorization_weixin
  before_filter :update_account_identifier, :find_or_create_member, :create_message, except: [:authorization]
  after_filter :save_member, except: [:authorization]

  def authorization
    if weixin_request.echostr
      render text: weixin_request.echostr, layout: false
    else
      render text: t('errors.messages.weixin.request_invalid'), layout: false
    end
  end

  def request_vote
    reply = nil
    if vote_switch_on?
      system_reply_id = nil
      if vote_time?
        vote_info = weixin_request.body[:text]
        vote = Vote.new account_id: @account.id, booth: vote_info[0..3], open_id: @member.open_id, phone: vote_info[5..16]
        if vote.save
          system_reply_id = -61
        else
          system_reply_id = -62
        end
      elsif vote_time_start?
        system_reply_id = -63
      elsif vote_time_end?
        system_reply_id = -64
      end
      reply = system_message(system_reply_id)
    else
      replies = with_action
      reply = build_reply(replies) if replies.present?
      reply = system_message(-65) if reply.blank?
    end
    response_reply reply
  end

  def request_number
    reply = reply_number(weixin_request.body[:text])
    reply = system_message(-1) if reply.blank?
    response_reply reply
  end

  def request_text
    replies = with_action
    reply = build_reply(replies) if replies.present?
    reply = reply_system_message if reply.blank?
    response_reply reply
  end

  def request_event
    @object = Menu.where(id: weixin_request.body[:event_key]).first
    @oauth = Menu.where(body: weixin_request.body[:event_key]).first
    if @object.blank? && @oauth.present?
      redirect_to @oauth.body(openid: @member.open_id)
    end
    @member.action = @object.action
    render xml: @object.to_weixin_xml(@member.open_id)
  end

  def request_subscribe
    @member.subscribe = true
    render xml: Reply.find_by_number(-1000).to_weixin_xml(@member.open_id)
  end

  # 二维码订阅
  def request_subscribe_qrcode
    @member.subscribe = true
    qrcode_val = /^qrscene_(.)/.match(weixin_request.body[:event_key])
    qrcode = Reply.find_by_scene_id_and_scene_delete(qrcode_val[1], false)
    qrcode = system_message(-105) if qrcode.blank?
    render xml: qrcode.to_weixin_xml(@member.open_id)
  end

  def request_qrcode
    qrcode = Reply.find_by_scene_id_and_scene_delete(weixin_request.body[:event_key], false)
    qrcode = system_message(-105) if qrcode.blank?
    render xml: qrcode.to_weixin_xml(@member.open_id)
  end

  def request_unsubscribe
    @member.subscribe = false
    render nothing: true
  end

  def request_image
    response_reply system_message(-100)
  end

  def request_video
    response_reply system_message(-101)
  end

  def request_location
    replies = Reply.within(Setting.distance, origin: [weixin_request.body[:x].to_f, weixin_request.body[:y].to_f]).non_system
    reply = nil
    if replies.present?
      reply = build_reply(replies)
    else
      reply = system_message(-21)
    end
    response_reply reply
  end

  def request_voice
    reply = nil
    if (weixin_request.body[:recognition].match(/^\d*$/)).present?
      reply = reply_number(weixin_request.body[:recognition])
      reply = system_message(-1) if reply.blank?
    else
      replies = with_action
      reply = build_reply(replies) if replies.present?
    end
    reply = reply_system_message if reply.blank?
    response_reply reply
  end

  def request_link
    response_reply system_message(-103)
  end

  private

  def vote_switch_on?
    @account.settings(:vote).switch.to_i == 1
  end

  def vote_time?
    @account.settings(:vote_time).start.to_time(:local) < Time.now && \
    Time.now < @account.settings(:vote_time).end.to_time(:local) + 59
  end

  def vote_time_start?
    @account.settings(:vote_time).start.to_time(:local) > Time.now
  end

  def vote_time_end?
    @account.settings(:vote_time).end.to_time(:local) + 59 < Time.now
  end

  def fault_request
    if params[:signature].blank? and params[:timestamp].blank? and params[:nonce].blank? and params[:echostr].blank?
      return render text: t('errors.messages.weixin.request_invalid'), layout: false
    end
  end

  def authorization_weixin
    if weixin_request.timestamp.blank? and weixin_request.nonce.blank? and weixin_request.signature.blank?
      return false
    end
    sha1_sources = [@account.token, weixin_request.timestamp, weixin_request.nonce].sort.join
    if weixin_request.signature != Digest::SHA1.hexdigest(sha1_sources)
      return false
    end
  end

  def find_account
    @account = Account.find_by_alias weixin_request.alias
    raise ActiveRecord::RecordNotFound unless @account
  end

  def update_account_identifier
    if @account.identifier.blank?
      @account.identifier = weixin_request.to_user
      @account.save
    end
  end

  def find_or_create_member
    @member = Member.find_by_open_id weixin_request.from_user
    @member = @account.members.new(open_id: weixin_request.from_user) if @member.blank?
  end

  def create_message
    @member.messages.new category: weixin_request.type.to_sym, body: weixin_request.body.to_json
  end

  def save_member
    @member.save
  end

  # 查询图集
  def find_album
    resources = @account.albums.where("`title` like ?", "%#{weixin_request.body[:text]}%")
    if resources.blank?
      return []
    else
      reply = Reply.new name: 'album', category_cd: 1, account_id: @account.id
      if resources.class == Album
        reply.resources = [resources]
      else
        reply.resources = resources.sample(10)
      end
      return [reply]
    end
  end

  # 查询用户‘状态’的系统回复
  def reply_system_message(options = {})
    reply = nil
    case @member.action
    when :search
      if options[:type] == :list
        return system_message(-12)
      else
        return system_message(-11)
      end
    when :location
      if options[:type] == :list
        return system_message(-22)
      else
        return system_message(-21)
      end
    when :album
      return system_message(-51)
    when :global
      return system_message(-2)
    end

    if reply.blank? && weixin_request.body[:recognition].present?
      reply = system_message(-104)
      reply.body = reply.body.gsub('{{voice}}', weixin_request.body[:recognition]) if reply.body.include?("{{voice}}")
    end
    reply
  end

  # 查询天气
  def response_weather
    weathers = Weather.find_by_weather_tag(@account, weixin_request.body[:text])

    if weathers.count > 1
      reply = system_message(-32)
      reply.is_system = false
      if reply.body.present? && reply.body.include?("{{list}}")
        reply.body = reply.body.gsub("{{list}}", weathers.join("\n"))
      else
        reply.body = weathers.join("\n") if reply.category == :text
      end
    elsif weathers.count == 1
      reply = system_message(-33)
      reply.is_system = false
      if reply.body.present? && reply.body.include?("{{list}}")
        reply.body = reply.body.gsub("{{list}}", weathers.join("\n"))
      else
        reply.body = weathers.join("\n") if reply.category == :text
      end
    else
      reply = system_message(-31)
    end

    return reply
  end

  # 查询导游
  def response_guide
    guides = Guide.find_by_content(@account, weixin_request.body[:text])

    if guides.count > 1
      reply = system_message(-42)
      reply.is_system = false
      if reply.body.present? && reply.body.include?("{{list}}")
        reply.body = reply.body.gsub("{{list}}", guides.join("\n"))
      else
        reply.body = guides.join("\n") if reply.category == :text
      end
    elsif guides.count == 1
      reply = system_message(-43)
      reply.is_system = false
      if reply.body.present? && reply.body.include?("{{list}}")
        reply.body = reply.body.gsub("{{list}}", guides.join("\n"))
      else
        reply.body = guides.join("\n") if reply.category == :text
      end
    else
      reply = system_message(-41)
    end

    return reply
  end

  # 回复微信
  def response_reply(reply)
    render xml: reply.to_weixin_xml(@member.open_id)
  end

  # 查询系统消息
  def system_message(number)
    @account.replies.is_system.where(number: number).first
  end

  # 查询编号消息
  def reply_number(number)
    @account.replies.where(number: number).first
  end

  # 查询文本消息
  def with_action
    replies = nil
    case @member.action.to_sym
    when :search
      replies = Reply.tagged_with(weixin_request.body[:text], any: true).non_system
      if replies.blank?
        reply = reply_system_message
        replies = [reply]
      end
    when :weather
      reply = response_weather
      replies = [reply] if reply.present?
    when :guide
      reply = response_guide
      replies = [reply] if reply.present?
    when :album
      replies = find_album
    when :global
      if replies.blank?
        reply = reply_system_message
        replies = [reply]
      end
    end
    return replies
  end

  # 生成文本回复
  def build_reply(replies)
    reply = nil
    if replies.count == 1
      reply = replies.first
    elsif replies.count > 1
      reply = reply_system_message(type: :list)
      if reply.body.present? && reply.body.include?("{{list}}")
        reply.body = reply.body.gsub("{{list}}", build_reply_list(replies))
      else
        reply.body = build_reply_list(replies) if reply.category == :text
      end
    end
    reply
  end

  # 生成列表名称
  def build_reply_list(replies)
    replies.inject([]) do |array, reply|
      array << "[#{reply.number}] #{reply.name}"
      array
    end.join("\n")
  end
end
