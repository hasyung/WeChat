module ApplicationHelper

  def controller_style
    params[:controller].split('/').join('-')
  end

  def number_html_highlight number
    class_name = case number
    when 0..10 then ''
    when 11..20 then 'badge-grey'
    when 21..30 then 'badge-success'
    when 31..40 then 'badge-warning'
    when 41..50 then 'badge-important'
    when 51..60 then 'badge-info'
    when 61..70 then 'badge-purple'
    when 71..80 then 'badge-inverse'
    when 81..90 then 'badge-pink'
    when 91..100 then 'badge-yellow'
    else
      ''
    end
    content_tag :span, number, class: "badge #{class_name}"
  end

  def message_type_highlight message
    class_name = case message.category
    when :text then 'label-success'
    when :image then 'label-warning'
    when :event then 'label-important'
    when :video then 'label-info'
    when :location then 'label-inverse'
    when :voice then 'label-pink'
    when :link then 'label-yellow'
    else
      ''
    end
    content_tag :span, message.human_category, class: "label #{class_name}"
  end

  def message_render_body message
    case message.category
    when :text
      message.body[:text]
    when :event
      message_event message.body
    when :location
      message_location message.body
    when :voice
      message_voice message.body
    end
  end

  def message_event msg_body
    case msg_body[:event].to_sym
    when :unsubscribe
      t('messages.messages.events.unsubscribe')
    when :subscribe
      t('messages.messages.events.subscribe')
    else
      menu = Menu.where(id: msg_body[:event_key]).first
      t('messages.messages.events.click', menu_name: (menu.present? ? menu.name : t('errors.messages.menus.not_record')))
    end
  end
  
  def message_location msg_body
    t('messages.messages.events.location', lng: msg_body[:x], lat: msg_body[:y], label: msg_body[:label])
  end
  
  def message_voice msg_body
    t('messages.messages.events.voice', recognition: msg_body[:recognition])
  end

end
