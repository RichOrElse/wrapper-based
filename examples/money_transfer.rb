LogTransaction = method(:puts)
Account = Struct.new(:number, :balance)
NotEnoughFunds = Class.new(StandardError)

module SourceAccount
  def decrease_balance_by(amount)
    raise NotEnoughFunds, "Balance is below amount.", caller if balance < amount
    self.balance -= amount
  end
end

module DestinationAccount
  def increase_balance_by(amount)
    self.balance += amount
  end
end

DCI = WrapperBased::DCI.new unless defined? DCI

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
    withdraw(amount)
    deposit(amount)
  end
end
