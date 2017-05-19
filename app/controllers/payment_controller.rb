class PaymentController < ApplicationController
  layout false
  def form
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
    @view_data = {
        id: payment.id,
        amount: amount,
        description: description,
        currency: currency_lower,
        address: address,
        qr_prefix: currency[0][:qr]
    }
  end

end
