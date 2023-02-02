SELECT O.receipt_num AS 'Order', O.delivery_address AS 'Delivery Address',
	   R1.rating AS 'Restaurant Rating', R2.rating AS 'Driver Rating'
FROM ORDERS O, RATING R1, RATING R2
WHERE O.customer_username = R1.customer_username -- joining ORDERS-RATING
	AND O.customer_username = R2.customer_username -- joining ORDERS-RATING 
    AND R1.rest_vat IS NOT NULL -- ensuring to get only restaurant rating 
    AND R2.driver_ssn IS NOT NULL -- ensuring to get only driver rating 
    AND O.receipt_num = 5139665377 -- checking for a specific order
    