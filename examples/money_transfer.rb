LogTransaction = Struct.new(:transaction_type, :amount, :account_number)

module Funds
  Insufficient = Class.new(StandardError)

  module SourceAccount
    def decrease_balance_by(amount)
      fail Funds::Insufficient, "Balance is below amount.", caller if balance < amount
      self.balance -= amount
    end
  end

  module DestinationAccount
    def increase_balance_by(amount)
      self.balance += amount
    end
  end

  class TransferMoney < DCI::Context(:from, :to)
    from.as SourceAccount
    to.as DestinationAccount

    def withdraw(amount)
      from.decrease_balance_by(amount)
      LogTransaction["Withdraw", amount, from.number]
    end

    def deposit(amount)
      to.increase_balance_by(amount)
      LogTransaction["Deposit", amount, to.number]
    end

    def call(amount:)
      accounts = [@from, @to]
      transaction_logs = [withdraw(amount), deposit(amount)]
      [:success, { logs: transaction_logs }, accounts]
    rescue NotEnoughFunds => error
      [:failure, { message: error.message }, accounts]
    end
  end

  def self.transfer(**where)
    TransferMoney[**where]
  end
end
