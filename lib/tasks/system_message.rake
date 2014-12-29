# encoding : utf-8

namespace :seed do
  desc "create default votes message"
    task votes: :environment do
      msgs = ["vote_success", "vote_exist", "vote_time_start", "vote_time_end", "vote_switch_off"]
      Account.all.each do |account|
        msgs.each do |msg|
          if not account.replies.exists?(number: Setting.system_messages.send(msg))
            reply = account.replies.new number: Setting.system_messages.send(msg), name: I18n.t("system_messages.#{msg}")
            reply.is_system = true
            reply.save
          end
        end
      end
    end

    desc "update wechat reply message"
    task update: :environment do
      Account.all.each do |account|
        Setting.system_messages.each do |k, v|
          if not account.replies.exists?(number: v.to_s)
            reply = account.replies.new number: v.to_s, name: I18n.t("system_messages.#{k}")
            reply.is_system = true
            reply.save
          end
        end
      end
      puts '========操作结束========'
    end
end