# encoding:utf-8

require 'httpclient'

module Api

  class Guid
    WS_URL = "http://data.scta.gov.cn/rest/app?app_key=bd0b88e53f2732fb013f2765d9380012&format=json&method=guide.listGuideDataByCondition&sign=0e9b19ba65a0a68048236b91c2778daf&since=20010301"

    def self.find_by_guide_cardno(account, cardno)
      initialize_url = WS_URL + "&pageNo=1" + "&pageSize=50" + "&timestamp=" + URI.escape(Time.now.to_formatted_s(:db)) + "&cardno=" + URI.escape(cardno)

      begin
        response = HTTPClient.new.get_content(initialize_url)
        guid = []
        JSON.parse(response)["rows"].each do |g|
          guide = Guide.find_by_qualificationscardno g["QUALIFICATIONSCARDNO"]
          if guide.present?
            guide.update_attributes name: g["NAME"], qualificationscardno: g["QUALIFICATIONSCARDNO"], body: g.to_json
          else
            account.guides.create name: g["NAME"], qualificationscardno: g["QUALIFICATIONSCARDNO"], body: g.to_json
          end
          guid << g if g["QUALIFICATIONSCARDNO"] == cardno
        end
        guid
      rescue
        nil
      end
    end

    def self.find_by_guide_name(account, name)
      initialize_url = WS_URL + "&pageNo=1" + "&pageSize=0" + "&timestamp=" + URI.escape(Time.now.to_formatted_s(:db)) + "&keyword=" + URI.escape(name)

      begin
        response = HTTPClient.new.get_content(initialize_url)
        total = JSON.parse(response)["total"]
        return nil if total.to_i == 0
        url = WS_URL + "&pageNo=1" + "&pageSize="+ total.to_s + "&timestamp=" + URI.escape(Time.now.to_formatted_s(:db)) + "&keyword=" + URI.escape(name)

        response = HTTPClient.new.get_content(url)
        JSON.parse(response)["rows"].each do |g|
          guide = Guide.find_by_qualificationscardno g["QUALIFICATIONSCARDNO"]
          if guide.present?
            guide.update_attributes name: g["NAME"], qualificationscardno: g["QUALIFICATIONSCARDNO"], body: g.to_json
          else
            account.guides.create name: g["NAME"], qualificationscardno: g["QUALIFICATIONSCARDNO"], body: g.to_json
          end
        end
        JSON.parse(response)["rows"]
      rescue
        nil
      end
    end

  end

end