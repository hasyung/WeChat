# encoding: utf-8

if Rails.env.test? or Rails.env.development?
  # Admin User
  unless AdminUser.exists?(email: 'admin@1trip.com')
    a = AdminUser.create realname: '杨瀚', email: 'admin@1trip.com', password: '123123', password_confirmation: '123123'
    a.roles = 'admin'
    a.save
  end

  # Account
  account1 = Account.find_by_name('新方舟') || Account.create(name: '新方舟', alias: 'NewArk1314', description: '我是新方舟')

  # Directory
  # d1 = Directory.find_by_name('青城山') || account1.directories.create(name: '青城山')
  # d2 = Directory.find_by_name('武侯祠') || account1.directories.create(name: '武侯祠')

  # # Article
  # unless Article.exists?(title: '这是乔顺的小学作文')
  #   Article.create title: '这是乔顺的小学作文', description: '大家一起来学中文', \
  #   cover: File.open(File.expand_path('resources/images/bugs.jpg', Rails.root)), \
  #   article_profile_attributes: { body: '说些什么好呢？算了，不说了。' }, \
  #   account_id: account1.id
  # end

  # unless Article.exists?(title: '这是我的中学作文')
  #   Article.create title: '这是我的中学作文', description: '百事可乐真好喝', \
  #   cover: File.open(File.expand_path('resources/images/ruby.png', Rails.root)), \
  #   article_profile_attributes: { body: '百事可乐真好喝。' }, \
  #   account_id: account1.id
  # end

  # # Audio
  # unless Audio.exists?(title: '同一首歌')
  #   Audio.create title: '同一首歌', description: '我们一起唱同一首歌', \
  #   audio_profile_attributes: { file: File.open(File.expand_path('resources/musics/MovesLikeJagger.mp3', Rails.root)) }, \
  #   cover: File.open(File.expand_path('resources/images/bugs.jpg', Rails.root)), \
  #   account_id: account1.id
  # end

  # unless Audio.exists?(title: '萝莉唱歌好难听')
  #   Audio.create title: '萝莉唱歌好难听', description: '萝莉居然会唱歌', \
  #   audio_profile_attributes: { file: File.open(File.expand_path('resources/musics/MovesLikeJagger.mp3', Rails.root)) }, \
  #   cover: File.open(File.expand_path('resources/images/ruby.png', Rails.root)), \
  #   account_id: account1.id
  # end

  # Kit
  unless Kit.exists?(title: '大家来看好视频')
    Kit.create title: '大家来看好视频', description: '好视频要大家一起看', price: 100.00, \
    kit_profile_attributes: { file: File.open(File.expand_path('resources/videos/wuhouci.mp4', Rails.root)) }, \
    cover: File.open(File.expand_path('resources/images/bugs.jpg', Rails.root)), \
    account_id: account1.id
  end
end

if Rails.env.production?
end