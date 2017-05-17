class AdminMailer < BaseMailer

  def email_to_admin(user_email, wallet , amount)
    @user_email = user_email
    @wallet = wallet
    @amount = amount
    mail to: Figaro.env.admin.split(',')
  end

end
