# encoding : utf-8

namespace :db do
  desc "Backup db votes"
  task :bak_votes, :user_name, :db_name, :bak_path do |t, args|
    if args[:user_name].blank? || args[:db_name].blank? || args[:bak_path].blank?
      puts '==========输入参数不能为空！=========='
    else
      db_path = "#{args[:bak_path]}/#{Time.now.to_i}_bak_votes.sql"
      msg = system "mysqldump -u #{args[:user_name]} -p #{args[:db_name]} votes > #{db_path}"
      if msg == true
        puts '==========数据已成功备份！=========='
        puts "备份地址：#{db_path}"
      end
    end
  end
end