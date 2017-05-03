module APIv2
  class Login < Grape::API

    desc 'Signup user'
    params do
      requires :email, type: String,  desc: 'User email'
      requires :password, type: String,  desc: 'User password'
    end
    post '/signup' do
      identity_params = { email: params[:email],
                          password: params[:password],
                          password_confirmation: params[:password] }
      identity = Identity.create(identity_params)
      if identity.save
        identity
      else
        identity.errors.messages
      end
    end

    desc 'singin user'
    params do
      requires :email, type: String, desc: 'User email'
      requires :password, type: String, desc: 'User password'
    end

    post '/singin' do
      identity_params = { email: params[:email],
                          password: params[:password] }

      @member = Member.where(email: params[:email]).first
      clear_failed_logins
      reset_session rescue nil
      session[:member_id] = @member.id
      save_session_key @member.id, cookies['_peatio_session']
      save_signup_history @member.id
      MemberMailer.notify_signin(@member.id).deliver if @member.activated?
    end

  end
end
