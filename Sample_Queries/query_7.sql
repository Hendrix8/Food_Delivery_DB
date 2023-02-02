SELECT O.receipt_num AS 'Order', R.rating AS 'Driver Rating'
FROM ORDERS O, RATING R
WHERE O.customer_username = R.customer_username
	AND R.driver_ssn IS NOT NULL -- ensuring the driver has a rating
	AND O.status = 0 -- ensuring that the orders are in transit