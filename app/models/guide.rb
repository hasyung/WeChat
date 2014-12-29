# encoding:utf-8

class Guide < ActiveRecord::Base
  attr_accessor :company, :typename, :language, :gender, :areacode, :rn, :idno, 
                :regionname, :memo, :guideidcard, :guide_id, :identification, :guidelevel,
                :guideimage

  attr_accessible :account_id, :account, :name, :qualificationscardno, :body,
                  :company, :typename, :language, :gender, :areacode, :rn, :idno, :guideimage,
                  :regionname, :memo, :guideidcard, :guide_id, :identification, :guidelevel

  # Relations
  belongs_to :account

  include Extension::DataTable

  # Validates
  validates :name, :qualificationscardno, :account_id, presence: true
  with_options if: :name? do |guide|
    guide.validates :name, length: { in: 2..200 }
  end
  with_options if: :qualificationscardno? do |guide|
    guide.validates :qualificationscardno, length: { in: 0..200 }
    guide.validates :qualificationscardno, uniqueness: true
  end
  with_options if: :body? do |weather|
    weather.validates :body, length: { in: 0..3000 }
  end

  # Scopes
  scope :created_desc, order("created_at DESC")

  def self.find_by_content(account, content)
    guide, guides = [], []
    return guide if content.length < 2

    if content =~ /^[\u4e00-\u9fa5]+$/
      guides = Api::Guid.find_by_guide_name(account, content)
    else
      guides = Api::Guid.find_by_guide_cardno(account, content)
    end

    return guide if guides.blank?

    if guides.count == 1
      gg = Guide.find_by_qualificationscardno guides.first["QUALIFICATIONSCARDNO"]
      guide << gg.get_guide_value
    else
      guides.each do |g|
        guide << "【" + g["QUALIFICATIONSCARDNO"] + "】 " + g["NAME"]
      end
    end
    guide
  end

  def get_json
    guide = JSON.parse self.body
    self.company = guide["COMPANY"]
    self.typename = guide["TYPENAME"]
    self.language = guide["LANGUAGE"]
    self.gender = guide["GENDER"]
    self.areacode = guide["AREACODE"]
    self.rn = guide["RN"]
    self.idno = guide["IDNO"]
    self.regionname = guide["REGIONNAME"]
    self.memo = guide["MEMO"]
    self.guideidcard = guide["GUIDEIDCARD"]
    self.guide_id = guide["ID"]
    self.identification = guide["IDENTIFICATION"]
    self.guidelevel = guide["GUIDELEVEL"]
    self.guideimage = guide["GUIDEIMAGE"]
  end

  def get_guide_value
    I18n.t("activerecord.attributes.guide.qualificationscardno") + " " + self.qualificationscardno + "\n" +
    I18n.t("activerecord.attributes.guide.name") + " " + self.name + "\n" +
    I18n.t("activerecord.attributes.guide.gender") + " " + I18n.t("activerecord.enums.guide.#{JSON.parse(self.body)["GENDER"]}") + "\n" +
    I18n.t("activerecord.attributes.guide.identification") + " " + JSON.parse(self.body)["IDENTIFICATION"] + "\n" +
    I18n.t("activerecord.attributes.guide.typename") + " " + JSON.parse(self.body)["TYPENAME"] + "\n" +
    I18n.t("activerecord.attributes.guide.regionname") + " " + JSON.parse(self.body)["REGIONNAME"] + "\n" +
    I18n.t("activerecord.attributes.guide.language") + " " + JSON.parse(self.body)["LANGUAGE"] + "\n" + " " +
    "<a href=\"http://#{Setting.domain}/weixin/guides/#{self.id.to_s}\">点击查看" + I18n.t("activerecord.attributes.guide.guideimage") + "</a>" + "\n"
  end

end
