require "razorpay"
require 'json'
require 'erb'
require 'execjs'
require 'sinatra'


# key_id = Rails.application.credentials.dig(:razorpay, :key_id)
# secret_key = Rails.application.credentials.dig(:razorpay, :secret_key)
# Razorpay.setup(key_id, secret_key)
Razorpay.setup('rzp_test_mhR64CrGFAi1a9', 'ICawF12Hpxf6mbZIxKjr49AZ')
options = Razorpay::Order.create amount: 500, currency: 'INR', receipt: 'TEST'
b=JSON.pretty_generate(options)

@order_id = JSON.parse(b)["id"]
# @order_id = options.to_json["id"]

get '/' do
    redirect ("/order")
end
get '/order' do
    redirect ("/payments")
end
get '/payments' do
    erb :payments
end
post '/payment' do
    # paymentId = params[:razorpay_payment_id]
    data = {
        :razorpay_payment_id => params[:razorpay_payment_id],
        :razorpay_order_id => params[:razorpay_order_id],
        :razorpay_signature => params[:razorpay_signature]
    }
    return data.to_json
    # para_attr = {
    #     "amount"=> 500,
    #     "currency" => "INR"
    # }
    # @p = Razorpay::Payment.capture(paymentId, para_attr)
    # erb :payment
end
get('/payment') do
    "This will be our home page.  is always the root route in a Sinatra application."
  end
