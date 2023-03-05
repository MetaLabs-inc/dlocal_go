# DlocalGo

Ruby client for the [dLocal Go](https://dlocalgo.com/) API.

## Installation

Add dlocal_go in your Gemfile

    $ gem 'dlocal_go'
    $ bundle install

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install dlocal_go

## Preview

https://user-images.githubusercontent.com/57004457/222937723-c95ca31c-2871-4f0f-a61e-fd4c9738e75f.mp4


## Usage

1. Configure DlocalGo in a initializer

```ruby
  DlocalGo.setup do |config|
    config.api_key = 'your_api_key'
    config.api_secret = 'your_api_secret'
    config.environment = 'sandbox' # or 'production'
    config.supported_countries = %w[AR BR CL CO MX PE UY] # Optional, default:  %w[UY AR CL BO BR CO CR EC GT ID MX MY PE PY]
  end
```


2. Use the client to create a payment, get a payment, or create a refund.

- Create Payment

```ruby
  params = {
    country_code: "UY",
    currency: "USD", # Optional, if not supplied, it uses the default currency for the country
    amount: 100,
    success_url: "https://success.url", # Where the user will be redirected after the payment is approved
    back_url: "https://back.url", # Where the user is redirected if they go back from the checkout page
    notification_url: "https://notification.url" # Optional, where the notification will be sent when payment state changes, (It will send a POST request with a payment_id param in the body, which can be used to retrieve the payment)
  }
  response = DlocalGo::Client.create_payment(params)
  # If request is not successful, it will raise a DlocalGo::Error, otherwise the response will be a DlocalGo::Response::Payment object

  # You might want to save the payment from the response before redirecting, so you can update the state later via a webhook (notification_url)
  redirect_to response.redirect_url, allow_other_host: true
```

- Get Payment

```ruby
  response = DlocalGo::Client.get_payment("payment_id")
  # If request is not successful, it will raise a DlocalGo::Error, otherwise the response will be a DlocalGo::Response::Payment object
```

- Create Refund

```ruby
  params = {
    payment_id: "payment_id_sample",
    amount: 100,
    reason: "reason_sample"
  }
  response = DlocalGo::Client.create_refund(params)
  # If request is not successful, it will raise a DlocalGo::Error, otherwise the response will be a DlocalGo::Response::Refund object
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MetaLabs-inc/dlocal_go.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
