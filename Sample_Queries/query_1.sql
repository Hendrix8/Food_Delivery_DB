SELECT C.fname AS 'First Name', C.lname AS 'Last Name'
FROM CUSTOMER C, ORDERS O, RESTAURANT R, OWNED W, OWNER N
WHERE C.customer_username = O.customer_username -- joining CUSTOMER-ORDERS
	AND O.rest_vat = R.rest_vat -- joining ORDERS-RESTAURANT
    AND R.rest_vat = W.rest_vat -- joining RESTAURANT-OWNED
    AND W.owner_ssn = N.ssn -- joining OWNED-OWNER
    AND N.fname = 'Kelsey' -- checking owner first name
    AND N.lname = 'Spencer' -- checking owner last name 
    AND O.order_date BETWEEN DATE_SUB(DATE('2023-01-29'), INTERVAL 1 WEEK) AND NOW() -- taking all data for the last week
    AND O.coupon_id IS NOT NULL -- ensuring a coupon was used