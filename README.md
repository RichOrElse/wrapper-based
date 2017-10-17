# WrapperBased

[![Gem Version](https://badge.fury.io/rb/wrapper_based.svg)](https://badge.fury.io/rb/wrapper_based)
[![Build Status](https://travis-ci.org/RichOrElse/wrapper-based.svg?branch=master)](https://travis-ci.org/RichOrElse/wrapper-based)

Wrapper Based DCI framework for OOP done right.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wrapper_based'
```

And then execute:

    $ bundle

## DCI::Roles

Includes role components to classes.

### Usage

```ruby
class ApplicationController
  include DCI::Roles(:current_user, logged: SignsUser)

  before_action -> { with! logged: session }
  helper_method :logged, :current_user
  
  private

  def authenticate_user!
    if logged.out?
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_url
    else
      with_current_user! logged.user
    end
  end
end

class LoginController < ApplicationController
  include DCI::Roles(signing: SignsUser, user_params: UserParams, login: HasEncryptedPassword)

  before_action -> { with! signing: session, user_params: params.require(:user) }
  before_action -> { with! login: signing.by(user_params.login) }

  def new; end

  def create
    if login.authenticate(user_params.password)
      signing.in! login
      redirect_to login, notice: 'Welcome, you are now logged in.'
    else
      flash[:danger] = 'Invalid credentials.'
      render :new, status: :unauthorized
    end
  end
end

class LogoutController < ApplicationController
  include DCI::Roles(signing: SignsUser)

  before_action -> { with! signing: session }

  def destroy
    signing.out!
    redirect_to root_url
  end
end

class SignsUser < Struct.new(:signed)
  def in!(user)
    signed[:user_id] = user.id
  end

  def out!
    signed.delete(:user_id)
    @user = nil
  end

  def out?
    signed[:user_id].nil? || in?
  end

  def in?
    !user.nil?
  end

  def user
    @user ||= by(id: signed[:user_id])
  end

  def by(**identification)
    User.find_by identification
  end

  def with(**credentials)
    User.new credentials
  end

  def up!(user)
    user.save && user if User.validate_registering(user)
  end
end

module UserParams
  def registration
    permit(:username, :email)
  end

  def login
    permit(:username, :email)
  end

  def security
    permit(:password, :password_confirmation, :code)
  end

  def password
    self[:password]
  end
end
```

## DCI::Context

### Usage

```ruby
class GiftToy < DCI::Context(:toy, gifter: Buyer, giftee: Recipient)
  def call(toy = @toy)
    gift = gifter.buy 
    giftee.receive gift 
  end
end
```

#### Context#to_proc

Returns call method as a Proc.

```ruby
['Card Wars', 'Ice Ninja Manual', 'Bacon'].map &GiftToy[gifter: 'Jake', giftee: 'Finn']
```

#### Context::call

A shortcut for instantiating the context by passing the collaborators and then executing the context call method.

```ruby
Funds::TransferMoney.(from: @account1, to: @account2, amount: 50)
```

Which is equivalent to:

```ruby
Funds::TransferMoney.new(from: @account1, to: @account2, amount: 50).call
```

## Context Examples
[Money Transfer](examples/money_transfer.rb) | 
[Djikstra](examples/djikstra.rb) | 
[Toy Shop](examples/toy_shop.rb) | 
[Acapella](examples/acapella.rb) | 
[Background Job](examples/background_job.rb) | 
[Facade](examples/users_facade.rb) | 
[HTTP API Client](examples/http_api_client.rb) | 
[all examples](examples)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RichOrElse/wrapper-based.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
