class ApplicationMailer < ActionMailer::Base
  default from: %("Shopex" "shopex@mail.com")
  layout 'mailer'
end
