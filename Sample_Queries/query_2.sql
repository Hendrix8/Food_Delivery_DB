SELECT I.name as 'Item Name', COUNT(I.item_barcode) as 'Item Count', AVG(R.rating) as 'Average Rating'
FROM MENU_ITEM I, OWNED, OWNER, RATING R
WHERE I.rest_vat = OWNED.rest_vat -- joining the MENU_ITEM with the OWNED table
	AND OWNED.owner_ssn = OWNER.ssn -- joining the OWNED with the OWNER table
    AND I.item_barcode = R.item_barcode -- joining the MENU_ITEM with the RATING table
	AND OWNER.fname = 'Stephanie' -- checking to have first name Raymond
    AND OWNER.lname = 'Brown' -- checking to have the last name Golden
GROUP BY I.item_barcode -- grouping by the item
    
    