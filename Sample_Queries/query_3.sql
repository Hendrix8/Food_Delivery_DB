SELECT I.name as 'Item Name', AVG(R.rating) as 'Average Rating'
FROM MENU_ITEM I, RATING R 
WHERE I.item_barcode = R.item_barcode -- joining ITEM-RATING
	AND I.name LIKE '%chicken%' -- checking if the item has chicken in it's name
GROUP BY I.item_barcode -- grouping by the item 
	HAVING AVG(R.rating) >= 4.0 -- checking if the item has an avg rating >= 0.4
