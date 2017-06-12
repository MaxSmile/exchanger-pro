module Private
  module Deposits
    class Lamda < ::Private::Deposits::BaseController
      include ::Deposits::CtrlBankable
    end
  end
end
