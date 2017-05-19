#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do
  $running = false
end

while($running) do

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

  PaymentTransaction::Normal.with_aasm_state(:unconfirm, :confirming).each do |tx|
    begin
      tx.with_lock do
        tx.check!
      end
    rescue
      puts "Error on PaymentTransaction::Normal: #{$!}"
      puts $!.backtrace.join("\n")
      next
    end
  end

  sleep 5
end
