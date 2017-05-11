module APIv2
  class Members < Grape::API
    helpers ::APIv2::NamedParams

    desc 'Get your profile and accounts info.', scopes: %w(profile)
    params do
      use :auth
    end
    get "/members/me" do
      authenticate!
      present current_user, with: APIv2::Entities::Member
    end

    desc 'Create Member'
    params do
      requires :email, type: String,  desc: 'User email'
      requires :name, type: String,  desc: 'User name'

    end
    post 'members/new' do
      random_password = SecureRandom.hex(8)
      identity_params = { email: params[:email],
                          password: random_password,
                          password_confirmation: random_password }
      identity = Identity.create(identity_params)
      if identity.valid?
        member =  Member.create(email: params[:email], activated: 1 , nickname: params[:name] )
        if member.save
          identity.save
          member.api_tokens.create!(label:'First API Token')
          token = member.api_tokens.first
          {password:random_password, secret_key:token.secret_key , access_key:token.access_key }
        else
          member.errors.messages
        end
      else
        identity.errors.messages
      end
    end

  end
end
