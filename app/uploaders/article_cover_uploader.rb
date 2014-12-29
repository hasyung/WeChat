# encoding: utf-8

class ArticleCoverUploader < ImageUploader
  
  version :weixin_big_cover do
    process :resize_to_fill => [640, 320]
  end
  
  version :weixin_small_cover do
    process :resize_to_fill => [80, 80]
  end

end
