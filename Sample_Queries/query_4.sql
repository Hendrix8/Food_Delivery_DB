SELECT D.fname as 'First Name', D.lname as 'Last Name', AVG(R.rating) as "Driver's Average Rating"
FROM DRIVER D, RATING R
WHERE D.ssn = R.driver_ssn -- joining DRIVER-RATING
	AND D.status = 1 -- checking if the driver is available
GROUP BY D.ssn -- grouping by driver