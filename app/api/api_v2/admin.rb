module APIv2
  class Admin < Grape::API

    desc 'Send Email to Admin'
    params do
      requires :user_email, type: String,  desc: 'User email'
      requires :wallet, type: String,  desc: 'Wallet number'
      requires :amount, type: String,  desc: 'Amount'

    end
    post 'admin/send_email' do
      user_email = params[:user_email]
      wallet = params[:wallet]
      amount = params[:amount]
      AdminMailer.email_to_admin(user_email, wallet , amount).deliver
      {success:"Email to #{Figaro.env.admin.split(',')} send."}
    end



  end
end
