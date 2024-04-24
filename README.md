# DlocalGo

Ruby client for the [dLocal Go](https://dlocalgo.com/) API.

## Installation

Add dlocal_go in your Gemfile

    $ gem 'dlocal_go'
    $ bundle install

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install dlocal_go

## Usage

1. Configure DlocalGo inside an initializer

```ruby
  DlocalGo.setup do |config|
    config.api_key = 'your_api_key'
    config.api_secret = 'your_api_secret'
    config.environment = 'sandbox' # or 'production'
    config.supported_countries = %w[AR BR CL CO MX PE UY] # Optional, default:  %w[UY AR CL BO BR CO CR EC GT ID MX MY PE PY]
  end
```

2. Use the client to interact with the API

- If you need to send body parameters just pass a hash:

```ruby
  client = DlocalGo::Client.new
  response = client.create_payment({country: "UY", currency: "UYU", amount: 500, notification_url: "https://notification.url"})
  # or
  # response = client.create_payment(country: "UY", currency: "UYU", amount: 500, notification_url: "https://notification.url")
```

- If you need to use path variables for specific endpoints you can also pass them as arguments

```ruby
  client = DlocalGo::Client.new

  # This will replace the payment_id path variable in the uri: /v1/payments/:payment_id
  response = client.get_payment(payment_id: "payment_id")
```

- If you need to send query parameters just pass as a hash under a query_params key

```ruby
  client = DlocalGo::Client.new
  response = client.get_all_subscription_plans(query_params: {page: 2})
  
  # You can also use it with endpoints that require path variables. Eg:
  response = client.get_subscriptions_by_plan(plan_id: 1234, query_params: {page: 2})
```

3. Handle the response

- We return DlocalGo::Responses objects (eg: DlocalGo::Responses::Payment) which have the same schema as the documentation responses.
- All attributes inside responses use the snake_case syntax

- NOTE: If the request fails we raise a DlocalGo::Error with an error code and message, so you might want to rescue it. (We'll make it optional in the future, for now we always raise an error when the request fails)

```ruby
  def create
    # Example:
    response = client.create_payment({country: "UY", currency: "UYU", amount: 500, notification_url: "https://notification.url"})
    redirect_to response.redirect_url, allow_other_host: true

  rescue DlocalGo::Error => e
    # Do sth else
  end
```

## Supported Endpoints

We support all endpoints from the [DlocalGo API](https://docs.dlocalgo.com/integration-api)

### Payments
- [x] Create Payment: `client.create_payment(params)`
- [x] Get Payment: `client.get_payment(payment_id: "the_id")`
- [x] Create Refund: `client.create_refund(params)`
- [x] Get Refund: `client.get_refund(refund_id: "the_id")`

## Recurring Payments
- [x] Create Recurring Payment: `client.create_recurring_payment(params)`
- [x] Get Recurring Payment: `client.get_recurring_payment(recurring_link_token: "the_token")`
- [x] Get All Recurring Payments: `client.get_all_recurring_payments`

## Subscriptions
- [x] Create Subscription Plan: `client.create_subscription_plan(params)`
- [x] Update Subscription Plan: `client.update_subscription_plan(plan_id: "the_id", params)`
- [x] Get All Subscription Plans: `client.get_all_subscription_plans`
- [x] Get Subscription Plan: `client.get_subscription_plan(plan_id: "the_id")`
- [x] Get Subscriptions by Plan: `client.get_subscriptions_by_plan(plan_id: "the_id")`
- [x] Get All Executions by Subscription: `client.get_all_executions_by_subscription(plan_id: "the_id", subscription_id: "the_id")`
- [x] Get Subscription Execution: `client.get_subscription_execution(subscription_id: "the_id", order_id: "the_id")`
- [x] Cancel Plan: `client.cancel_plan(plan_id: "the_id")`
- [x] Cancel Subscription: `client.cancel_subscription(plan_id: "the_id", subscription_id: "the_id")`


# Endpoints request and response schema details

- See the [DlocalGo API](https://docs.dlocalgo.com/integration-api) docs for more details on the request and response schema for each endpoint

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MetaLabs-inc/dlocal_go.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Authors

Made with ❤️ by MetaLabs' Team

<img width="240" alt="Screenshot 2023-03-04 at 23 10 21" src="https://user-images.githubusercontent.com/57004457/222937877-f6d26748-ff85-4907-905b-d9a4b1469daf.png">
