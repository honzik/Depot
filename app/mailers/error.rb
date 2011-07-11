class Error < ActionMailer::Base
  default :from => "rails@noreply.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error.invalid_order.subject
  #
  def invalid_order(invalid)    
    @misplaced = invalid
    mail :to => "honzik@localhost", :subject => 'Invalid order requested'
  end
end
