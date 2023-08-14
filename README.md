For payment please follow these steps
1. http://127.0.0.1:3000/payments     (POST)
    Body:
    {
        "amount":300
    }
    then hit Send.Order_id will show on output in postman.
2.  Copy Order_id on line 5. like orderId="<here paste oder id>".This file is at
    (https://github.com/RipAkj/article-app/blob/main/Front_end_for_razorpay/views/payments.erb)
3.  Open the file (https://github.com/RipAkj/article-app/blob/main/Front_end_for_razorpay/razorpay.rb) and open terminal      
    and type <ruby razorpay.rb> without the arrow brackets.
4.  A link will show, open that link and proceed to pay, after payment a page will show with 3 ouput
5.  In postman open http://127.0.0.1:3000/verify_payment (POST) in Body write
    {
        "payment_id":"<copy razorpay_payment from point 4>",
        "signature_id":"<copy razorpay_signature from point 4>"
    }
    Hit send, if see verification successfull then payment done
