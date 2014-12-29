ActionMailer::Base.smtp_settings = {
  address: Setting.mailer.address,
  port: Setting.mailer.port,
  authentication: Setting.mailer.authentication,
  domain: Setting.mailer.domain,
  user_name: Setting.mailer.user_name,
  password: Setting.mailer.password
}