# encoding:utf-8

class Weather < ActiveRecord::Base
  attr_accessor :cityid, :w1, :w2, :wt, :weather_id, :city, :t1, 
                :strdate, :wind, :resourcecode, :t2, :fh

  attr_accessible :account_id, :account, :name, :body, :weather_at,
                  :cityid, :w1, :w2, :wt, :weather_id, :city, :t1, 
                  :strdate, :wind, :resourcecode, :t2, :fh, :tag_list,
                  :keyword

  acts_as_taggable

  include Extension::DataTable

   # Relations
  belongs_to :account

  # Validates
  validates :name, :keyword, :account_id, presence: true
  with_options if: :name? do |weather|
    weather.validates :name, length: { in: 2..50 }
  end
  with_options if: :body? do |weather|
    weather.validates :body, length: { in: 0..3000 }
  end

  # Scopes
  scope :keyword_asc, order("created_at ASC")
  scope :weather_at_desc, order("weather_at DESC")

  after_save :set_tag_list_by_weather_name

  def self.find_by_weather_tag(account, weather_name)
    weather, weathers = [], []
    return weather if weather_name.length < 2

    if weather_name =~ /^#\d+$/
      weath = Weather.find_by_keyword weather_name[1, weather_name.length - 1]
      return weath.present? ? [weath.get_weather_value] : weather
    end

    account.weathers.weather_at_desc.tagged_with(weather_name).group_by{|w| w.keyword}.each{|g| weathers << g[1].first}

    if weathers.count == 1
      weather << weathers.first.get_weather_value
    else
      weathers.each do |w|
        weather << "【" + Setting.weather_keyword.key + w.keyword + "】 " + w.name
      end
    end
    weather
  end

  def get_json
    weather = JSON.parse self.body
    self.cityid = weather["CITYID"]
    self.w1 = weather["W1"]
    self.w2 = weather["W2"]
    self.wt = weather["WT"]
    self.weather_id = weather["ID"]
    self.city = weather["CITY"]
    self.t1 = weather["T1"]
    self.strdate = weather["STRDATE"]
    self.wind = weather["WIND"]
    self.resourcecode = weather["RESOURCECODE"]
    self.t2 = weather["T2"]
    self.fh = weather["FH"]
  end

  def get_weather_value
    "[" + Setting.weather_keyword.key + self.keyword + "] " + self.name + "\n" +
    I18n.t("activerecord.attributes.weather.tt") + " " + JSON.parse(self.body)["T1"] + "~" +
    JSON.parse(self.body)["T2"] + "度" + " " + JSON.parse(self.body)["WT"] + "\n" +
    I18n.t("activerecord.attributes.weather.wind") + " " + JSON.parse(self.body)["WIND"] + "\n"
  end

  private
  def set_tag_list_by_weather_name
    weathers = Weather.where(name: self.name)
    weathers.each do |w|
      if self.tag_list_changed?
        w.tag_list = self.tag_list
        w.save if w.id != self.id
      end
    end
  end

end