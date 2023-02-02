SELECT C.fname AS 'First Name', C.lname AS 'Last Name', 
	   COUNT(O.receipt_num) AS 'Total Number of Orders', AVG(R.rating) AS 'Average Rating Received'
FROM CUSTOMER C, ORDERS O, OWNED W, OWNER N, RATING R
WHERE C.customer_username = O.customer_username -- joining CUSTOMER-ORDERS
	AND C.customer_username = R.customer_username -- joining CUSTOMER-RATING
	AND W.owner_ssn = N.ssn -- joining OWNED-OWNER
    AND O.rest_vat = W.rest_vat -- joining ORDERS-OWNED
    AND R.rest_vat IS NOT NULL -- ensuring that there is a rating from customer to restaurant
    AND N.fname = 'Francis' -- checking for owner's first name
    AND N.lname = 'Valdez' -- checking for owner's last name
GROUP BY C.customer_username -- grouping by customers