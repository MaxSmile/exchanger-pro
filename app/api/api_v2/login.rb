module APIv2
  class Login < Grape::API

    desc 'Login user'
    params do
      requires :email, type: String,  desc: 'User email'
      requires :password, type: String,  desc: 'User password'
    end
    post '/singup' do
      identity_params = { email: params[:email],
                          password: params[:password],
                          password_confirmation: params[:password] }
      identity = Identity.create(identity_params)
      if identity.save
        @member = Member.from_auth(auth_hash)
        identity
      else
        identity.errors.messages
      end

    end

  end
end
