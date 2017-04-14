module APIv2
  class Payments < Grape::API

    desc 'Create payment'
    params do
      requires :coin_code, type: String,  desc: 'Coin code (BTC, RPT, TRT)'
      requires :amount, type: String,  desc: 'Amount'

    end
    post '/payment' do
      currency = Currency.where(code: params[:coin_code].downcase, coin: true)
      raise InvalidCoinCodeError, params[:coin_code] if currency.blank?
      puts 123
      'it okay'
    end

  end
end
