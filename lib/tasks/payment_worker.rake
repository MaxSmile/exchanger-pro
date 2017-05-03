require 'liability-proof'

namespace :payment_worker do

  desc "Payment worker"
  task :check => :environment do
    puts 'check_payments'
    Payment.all.each { |payment|
      address = payment.payment_address.address
      next if address.blank?
      payment_transactions = PaymentTransaction.where(address: address, aasm_state: :confirmed)
      next if payment_transactions.blank?
      sum = 0
      payment_transactions.all.each{ |payment_transaction|
        sum += payment_transaction.amount
      }
      b = BigDecimal.new(payment.amount) - sum
      pp address + ' ' + sum.to_s + ' ' + payment.amount + ' ' + b.to_s
      if b <= 0
        payment.status = Payment::PAYMENT_STATUS_COMPLETE
      else
        payment.status = Payment::PAYMENT_STATUS_CREATED
      end
      payment.save
    }
  end
end
