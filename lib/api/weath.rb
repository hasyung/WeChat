# encoding:utf-8

require 'httpclient'

module Api

  class Weath
    WS_URL = "http://data.scta.gov.cn/rest/app?app_key=bd0b88e53f2732fb013f2765d9380012&format=json&method=weather.list&sign=8ef7cf542046748d16d2d6ad1841c8cc"
    INTERVAL = 3 * 24 * 60 * 60

    def self.insert_weather_to_db(account)
      count = 0
      initialize_url = WS_URL + "&pageNo=1" + "&pageSize=0" + "&timestamp=" + URI.escape(Time.now.to_formatted_s(:db))
      begin
        response = HTTPClient.new.get_content(initialize_url)

        total = JSON.parse(response)["total"]
        return count if total.to_i == 0

        url = WS_URL + "&pageNo=1" + "&pageSize="+ total.to_s + "&timestamp=" + URI.escape(Time.now.to_formatted_s(:db))
        response = HTTPClient.new.get_content(url)

        sum = account.weathers.count
        JSON.parse(response)["rows"].each do |weath|
          next if weath["FH"].to_i != 24
          weathers = account.weathers.where(name: weath["CITY"]).weather_at_desc

          a = 0
          weathers.each do |w|
            w.destroy if Time.now - w.created_at > INTERVAL
            a += 1 if w.weather_at == weath["STRDATE"].to_datetime
          end

          next if a != 0
          tag = weathers.blank? ? weath["CITY"] : weathers.first.tag_list
          wea = account.weathers.new name: weath["CITY"], tag_list: tag, body: weath.to_json, weather_at: weath["STRDATE"].to_datetime, 
                keyword: weathers.present? ? weathers.first.keyword : (sum + 1).to_s
          if wea.save
            count += 1 
            sum += 1 if weathers.blank?
          end
        end
        count
      rescue
        count
      end
    end

  end

end