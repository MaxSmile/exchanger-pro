class Payment < ActiveRecord::Base
  PAYMENT_STATUS_CREATED   = 'created'.freeze
  PAYMENT_STATUS_PARTICAL  = 'partical'.freeze
  PAYMENT_STATUS_ACCEPTED  = 'accepted'.freeze
  PAYMENT_STATUS_COMPLETE  = 'complete'.freeze
  PAYMENT_STATUS_FAIL      = 'fail'.freeze

  belongs_to :payment_address
end
