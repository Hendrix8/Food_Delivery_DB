SELECT O.receipt_num AS 'Order', P.payment_method AS 'Payment Method',
	   P.payment_status AS 'Payment Status', C.coupon_code AS 'Coupon Code'
FROM PAYMENT P, ORDERS O, COUPON C
WHERE O.receipt_num = P.receipt_num -- joining ORDER-PAYMENT
	AND C.coupon_id = O.coupon_id -- joining COUPON-ORDERS
    AND O.receipt_num = 5139665377 -- checking out a specific order