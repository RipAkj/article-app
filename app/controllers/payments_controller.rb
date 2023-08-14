require 'razorpay'
class PaymentsController < ApplicationController
  before_action :require_authentication
  protect_from_forgery with: :null_session
  def create
    begin
      Razorpay.setup('rzp_test_mhR64CrGFAi1a9', 'ICawF12Hpxf6mbZIxKjr49AZ')
      amount = params[:amount]
      order = Razorpay::Order.create(amount: amount, currency: 'INR')

      subscription = Subscription.new(amount:(amount/100))
      subscription.expiry = Date.today + 1.month
      subscription.user = @current_user
      case subscription.amount
      when 0
        subscription.membership=0
      when 3
        subscription.membership=1
      when 5
        subscription.membership=2
      when 10
        subscription.membership=3
      end
      subscription.order_id=order.id
      subscription.save
      render json: { order_id: order.id,subscription: subscription,
        order_amount: order.amount ,
        key: "rzp_test_mhR64CrGFAi1a9"
      }
    rescue Razorpay::Error => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def verify_payment
    Razorpay.setup('rzp_test_mhR64CrGFAi1a9', 'ICawF12Hpxf6mbZIxKjr49AZ')
    signature_id = params[:signature_id]
    payment_id=params[:payment_id]
    payment = Razorpay::Payment.fetch(payment_id)
    payment_response ={
      :razorpay_order_id => payment.order_id,
      :razorpay_payment_id => payment.id,
      :razorpay_signature => signature_id
    }
    payment_check=Razorpay::Utility.verify_payment_signature(payment_response)
    subscription=Subscription.find_by(order_id:payment.order_id)
    if payment_check
      subscription.verified=true
      subscription.save
      render json: {msg: "verification: successfull"}, status: :ok
    else
      render json: {msg: "verification: unsuccessfull"}, status: :unprocessable_entity
    end
  end



  private

  def require_authentication
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded_token = JWT.decode(token, 'your_secret_key', true, algorithm: 'HS256')
      render json: {error: "invalid token"} if !decoded_token[0]['user_id']
      @current_user = User.find(decoded_token[0]['user_id'])
    rescue JWT::DecodeError
      render json: { error: header }, status: :unauthorized
    end
  end


  #  def verify_payment
#     Razorpay.setup('rzp_test_mhR64CrGFAi1a9', 'ICawF12Hpxf6mbZIxKjr49AZ')
#     payment_id=params[:id]
#     payment = Razorpay::Payment.fetch(payment_id)
#     subscription=Subscription.find_by(order_id:payment.order_id)
#     if payment.status=='captured'
#       #subscription.verified=true
#       render json: {msg: "verification: successfull"}, status: :ok
#     else
#       render json: {msg: "verification: unsuccessfull"}, status: :unprocessable_entity
#     end
#   end
end
