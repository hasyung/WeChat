# encoding : utf-8

namespace :api do

  desc '导入当前时间点天气信息至数据库'
  task :weather => :environment do

    puts "========开始导入：========"
    a = 0
    Account.all.each{|account| a += Api::Weath.insert_weather_to_db(account)}
    puts "========导入结束，此次共导入#{a}条数据。========"

  end

end