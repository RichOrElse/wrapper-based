require 'test_helper'
require_relative '../examples/money_transfer'

class FundsTransferTest < MiniTest::Test
  Account = Struct.new(:number, :balance)

  def setup
    @account1= Account['A1', 50]
    @account2 = Account['B2', 100]
  end

  def test_deposit
    Funds.transfer(to: @account1).deposit(10)
    assert_equal 60, @account1.balance
  end

  def test_withdraw
    Funds.transfer(from: @account1).withdraw(10)
    assert_equal 40, @account1.balance
  end

  def test_withdraw_above_balance
    error = assert_raises(Funds::Insufficient) { Funds.transfer(from: @account1).withdraw(60) }
    assert_equal "Balance is below amount.", error.message
  end

  def test_call
    Funds.transfer(from: @account1, to: @account2).(amount: 50)
    assert_equal 0, @account1.balance
    assert_equal 150, @account2.balance
  end
end
