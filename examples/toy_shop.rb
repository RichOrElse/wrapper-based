require 'wrapper_based'

# Data

Purchase = Struct.new(:toy, :buyer)
Deliver = Struct.new(:toy, :recipient, :purchase, :status)

# Interactions

module Shopper
  def buy(toy)
    Purchase.new toy, self
  end
end

module Recipient
  def receive(purchased)
    Deliver.new purchased.toy, self, purchased, :pending
  end
end

# Contexts

class BuyToy < DCI::Context(shopper: Shopper, recipient: Recipient)
  def initialize(shopper:, recipient: shopper) super end

  def call(item)
    bought = shopper.buy item
    recipient.receive bought
  end
end

class GiftToy < DCI::Context(gifter: Shopper, giftee: Recipient)
  def call(toy)
    gift = gifter.buy toy
    giftee.receive gift
  end
end

finn_purchase_toy = BuyToy[shopper: 'Finn']
finn_purchase_toy.call 'Rusty sword'
finn_purchase_toy.('Armor of Zeldron')
finn_purchase_toy['The Enchiridion']

puts ['Card Wars', 'Ice Ninja Manual', 'Bacon'].map &GiftToy[gifter: 'Jake', giftee: 'Finn']
