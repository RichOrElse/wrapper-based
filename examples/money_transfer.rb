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

  module Logging
    def log(transfer_type, amount, account, at: Time.now)
      self << [transfer_type, account.number, amount, at]
    end
  end

  class TransferMoney < DCI::Context(:amount, from: SourceAccount, to: DestinationAccount, events: Logging)
    def initialize(amount: 0, events: [], **accounts) super end

    def withdraw(amount)
      from.decrease_balance_by(amount)
      events.log "Withdrew", amount, @from
    end

    def deposit(amount)
      to.increase_balance_by(amount)
      events.log "Deposited", amount, @to
    end

    def transfer(amount)
      withdraw(amount)
      deposit(amount)
    end

    def call(amount: @amount)
      transfer(amount)
      return :success, accounts, log: @events
    rescue Funds::Insufficient => error
      return :failure, accounts, message: error.message
    end

    def accounts
      [@from, @to]
    end
  end
end
