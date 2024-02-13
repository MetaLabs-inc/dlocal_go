# frozen_string_literal: true

require_relative "responses/payment"
require_relative "responses/refund"
require_relative "responses/recurring_payment"
require_relative "responses/subscription_plan"
require_relative "responses/subscription"
require_relative "responses/subscription_execution"

require_relative "generators/endpoints"

module DlocalGo
  # Client for Dlocal Go API
  class Client
    include DlocalGo::Generators::Endpoints

    def initialize
      raise DlocalGo::Error, "Dlocal Go api key is not set" if api_key.nil?
      raise DlocalGo::Error, "Dlocal Go api secret is not set" if api_secret.nil?
    end

    # For body params requirements, visit: https://docs.dlocalgo.com/integration-api/welcome-to-dlocal-go-api/

    # For get and delete requests, send the path variables as a hash, for example: client.get_payment(payment_id: "123") and it will get replaced automatically inside the uri
    # For post and put/patch requests, the hash param will be included in the body instead

    # PAYMENTS
    generate_endpoint :create_payment, uri: "/v1/payments", verb: :post, dto: DlocalGo::Responses::Payment
    generate_endpoint :get_payment, uri: "/v1/payments/:payment_id", verb: :get, dto: DlocalGo::Responses::Payment
    generate_endpoint :create_refund, uri: "/v1/refunds", verb: :post, dto: DlocalGo::Responses::Refund
    generate_endpoint :get_refund, uri: "/v1/refunds/:refund_id", verb: :get, dto: DlocalGo::Responses::Refund

    # RECURRING PAYMENTS
    generate_endpoint :create_recurring_payment, uri: "/v1/recurring-payments", verb: :post, dto: DlocalGo::Responses::RecurringPayment
    generate_endpoint :get_recurring_payment, uri: "/v1/recurring-payments/:recurring_link_token", verb: :get, dto: DlocalGo::Responses::RecurringPayment
    generate_endpoint :get_all_recurring_payments, uri: "/v1/recurring-payments", verb: :get, dto: DlocalGo::Responses::RecurringPayment, array: true

    # SUBSCRIPTIONS
    generate_endpoint :create_subscription_plan, uri: "/v1/subscription/plan", verb: :post, dto: DlocalGo::Responses::SubscriptionPlan
    generate_endpoint :update_subscription_plan, uri: "/v1/subscription/plan", verb: :patch, dto: DlocalGo::Responses::SubscriptionPlan
    generate_endpoint :get_all_subscription_plans, uri: "/v1/subscription/plan/all", verb: :get, dto: DlocalGo::Responses::SubscriptionPlan, array: true
    generate_endpoint :get_subscription_plan, uri: "/v1/subscription/plan/:plan_id", verb: :get, dto: DlocalGo::Responses::SubscriptionPlan

    generate_endpoint :get_subscriptions_by_plan, uri: "/v1/subscription/plan/:plan_id/subscription/all", verb: :get, dto: DlocalGo::Responses::Subscription, array: true
    generate_endpoint :get_all_executions_by_subscription, uri: "/v1/subscription/plan/:plan_id/subscription/:subscription_id/execution/all", verb: :get, dto: DlocalGo::Responses::SubscriptionExecution, array: true

    generate_endpoint :cancel_plan, uri: "/v1/subscription/plan/:plan_id/deactivate", verb: :patch, dto: DlocalGo::Responses::SubscriptionPlan
    generate_endpoint :cancel_subscription, uri: "/v1/subscription/plan/:plan_id/subscription/:subscription_id/deactivate", verb: :patch, dto: DlocalGo::Responses::Subscription
  end
end
