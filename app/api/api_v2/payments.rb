module APIv2
  class Payments < Grape::API
    helpers ::APIv2::NamedParams

    desc 'List of payments'
    params do
      optional :id, type: String, desc: 'payment ID'
    end
    get '/payment' do
      member_id = 4
      payments = Payment.where(member_id: member_id)
      payments = Payment.where(id: params[:id]) if params[:id].present?

      payments.all
    end

    desc 'Find payment by order number'
    params do
      optional :order_number, type: String, desc: 'Order number'
    end
    get '/payment/find' do
      member_id = 1
      payments = Payment.where(member_id: 1)
      payments = Payment.where(order_number: params[:order_number])

      payments.all
    end

    desc 'Form payment'
    params do
      requires :coin_code, type: String,  desc: 'Coin code (BTC, RPT, TRT)'
      requires :amount, type: String,  desc: 'Amount'
      optional :description, type: String, desc: 'Payment description'
    end
    get '/form_payment' do
      currency_lower = params[:coin_code].downcase
      amount = params[:amount]
      address = '1234567'
      "<h2>New payment</h2>
      send #{amount} #{currency_lower}<br>
      to address #{address}"
    end

    desc 'Create payment'
    params do
      #use :auth
      requires :coin_code, type: String,  desc: 'Coin code (BTC, RPT, TRT)'
      requires :amount, type: String,  desc: 'Amount'
      optional :description, type: String, desc: 'Payment description'
      optional :order_number, type: String, desc: 'Order number'
    end

    post '/payment' do
      currency_lower = params[:coin_code].downcase
      amount = params[:amount]
      description = params[:description] || ''
      order_number = params[:order_number] || ''
      member_id = 1
      currency = Currency.where(code: currency_lower, coin: true)
      raise InvalidCoinCodeError, params[:coin_code] if currency.blank?

      payment_address = Member.find(member_id).get_account(currency[0].code).payment_addresses.create(currency: currency[0].code)
      20.times do |i|
        sleep 0.3
        payment_address.reload
        break if payment_address.address.present?
      end

      raise PaymentAddressNotCreated if payment_address.address.blank?

      address = payment_address.address

      payment = Payment.create(
          amount: amount,
          currency_id: currency[0].id,
          description: description,
          member_id: member_id,
          payment_address_id: payment_address.id,
          status: Payment::PAYMENT_STATUS_CREATED,
          order_number: order_number)
      {
          id: payment.id,
          amount: amount,
          description: description,
          currency: currency_lower,
          address: address
      }
    end

  end
end
