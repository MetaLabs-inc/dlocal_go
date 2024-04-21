require_relative "responses/payment"
require_relative "responses/refund"
require_relative "responses/recurring_payment"
require_relative "responses/subscription_plan"
require_relative "responses/subscription"
require_relative "responses/subscription_execution"
require_relative "endpoint_generator"

module DlocalGo
  # Client for Dlocal Go API
  class Client
    include DlocalGo::EndpointGenerator

    def initialize
      raise DlocalGo::Error.new("Dlocal Go api key is not set") if api_key.nil?
      raise DlocalGo::Error.new("Dlocal Go api secret is not set") if api_secret.nil?
    end

    # Request body requirements for each endpoint: https://docs.dlocalgo.com/integration-api/welcome-to-dlocal-go-api/

    # ===== USAGE =====
    #

    # For get and delete requests, send the path variables as a hash, for example: client.get_payment(payment_id: "123") and it will get replaced automatically inside the uri
    # Also for get and delete requests, query params are taken from the query_params hash key, for example: client.get_all_subscription_plans(query_params: { page: 2 })
    # This is an example that uses query and path params: client.get_all_executions_by_subscription(subscription_id: "123", plan_id: "456", query_params: { page: 2 })

    # For post and put/patch requests, the hash variables will be included in the body instead

    #
    # ===== USAGE =====

    # PAYMENTS
    generate_endpoint :create_payment, uri: "/v1/payments", verb: :post, dto_class: DlocalGo::Responses::Payment
    generate_endpoint :get_payment, uri: "/v1/payments/:payment_id", verb: :get, dto_class: DlocalGo::Responses::Payment
    generate_endpoint :create_refund, uri: "/v1/refunds", verb: :post, dto_class: DlocalGo::Responses::Refund
    generate_endpoint :get_refund, uri: "/v1/refunds/:refund_id", verb: :get, dto_class: DlocalGo::Responses::Refund

    # RECURRING PAYMENTS
    generate_endpoint :create_recurring_payment, uri: "/v1/recurring-payments", verb: :post, dto_class: DlocalGo::Responses::RecurringPayment
    generate_endpoint :get_recurring_payment, uri: "/v1/recurring-payments/:recurring_link_token", verb: :get, dto_class: DlocalGo::Responses::RecurringPayment
    generate_endpoint :get_all_recurring_payments, uri: "/v1/recurring-payments", verb: :get, dto_class: DlocalGo::Responses::RecurringPayment

    # SUBSCRIPTIONS
    generate_endpoint :create_subscription_plan, uri: "/v1/subscription/plan", verb: :post, dto_class: DlocalGo::Responses::SubscriptionPlan
    generate_endpoint :update_subscription_plan, uri: "/v1/subscription/plan", verb: :patch, dto_class: DlocalGo::Responses::SubscriptionPlan
    generate_endpoint :get_all_subscription_plans, uri: "/v1/subscription/plan/all", verb: :get, dto_class: DlocalGo::Responses::SubscriptionPlan
    generate_endpoint :get_subscription_plan, uri: "/v1/subscription/plan/:plan_id", verb: :get, dto_class: DlocalGo::Responses::SubscriptionPlan

    generate_endpoint :get_subscriptions_by_plan, uri: "/v1/subscription/plan/:plan_id/subscription/all", verb: :get, dto_class: DlocalGo::Responses::Subscription
    generate_endpoint :get_all_executions_by_subscription, uri: "/v1/subscription/plan/:plan_id/subscription/:subscription_id/execution/all", verb: :get, dto_class: DlocalGo::Responses::SubscriptionExecution
    generate_endpoint :get_subscription_execution, uri: "/v1/subscription/:subscription_id/execution/:order_id", verb: :get, dto_class: DlocalGo::Responses::SubscriptionExecution

    generate_endpoint :cancel_plan, uri: "/v1/subscription/plan/:plan_id/deactivate", verb: :patch, dto_class: DlocalGo::Responses::SubscriptionPlan
    generate_endpoint :cancel_subscription, uri: "/v1/subscription/plan/:plan_id/subscription/:subscription_id/deactivate", verb: :patch, dto_class: DlocalGo::Responses::Subscription
  end
end
