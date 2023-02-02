SELECT Re.name as 'Restaurant Name', COUNT(O.receipt_num) AS 'Total Orders',
	  AVG(R.rating) AS 'Restaurant Average Rating'
FROM ORDERS O, RATING R, Restaurant Re
WHERE O.customer_username = R.customer_username -- joining ORDERS-RATING
	AND Re.rest_vat = R.rest_vat -- joining RESTAURANT-RATING
	AND R.rest_vat IS NOT NULL -- ensuring there is a rating for the restaurant 
GROUP BY Re.rest_vat -- groupoing by restaurant
