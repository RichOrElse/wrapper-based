# Data

Purchase = Struct.new(:toy, :buyer)
Deliver = Struct.new(:toy, :recipient, :purchase, :status)

# Behaviors

module Buyer
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

class PurchaseToy < DCI::Context(:purchaser)
  purchaser.as Buyer
  purchaser.as Recipient

  def call(toy)
    purchased = purchaser.buy toy
    purchaser.receive purchased
  end
end


class GiftToy < DCI::Context(:gifter, :giftee)
  gifter.as Buyer
  giftee.as Recipient

  def call(toy)
    gift = gifter.buy toy
    giftee.receive gift
  end
end

# Interactions

finn_purchase_toy = PurchaseToy[purchaser: 'Finn']
finn_purchase_toy.call 'Rusty sword'
finn_purchase_toy.('Armor of Zeldron')
finn_purchase_toy['The Enchiridion']

['Card Wars', 'Ice Ninja Manual', 'Bacon'].each &GiftToy[gifter: 'Jake', giftee: 'Finn']
