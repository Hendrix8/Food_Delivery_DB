SELECT C.fname AS 'First Name', C.lname AS 'Last Name'
FROM CUSTOMER C, ORDERS O
WHERE C.customer_username = O.customer_username -- joining CUSTOMER-ORDERS
	AND O.coupon_id IS NOT NULL -- ensuring that the customer used a coupon 
    AND O.order_date >= DATE_SUB(DATE('2023-01-29'), INTERVAL 1 WEEK) -- checking only for the past week
