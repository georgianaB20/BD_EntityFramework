--Add Iasi and Romania in DB
UPDATE Cities SET Name='Iasi' WHERE Id=26;
UPDATE Cities SET Name='Brasov' WHERE Id=30;
UPDATE Cities SET CountryId=7 WHERE Id=26;
UPDATE Cities SET CountryId=7 WHERE Id=30;
Update Properties SET CityId = 30,PropertyTypeId = 3 WHERE Id = 15;
UPDATE Properties SET Name='InterContinental' Where Id=7;
UPDATE Properties SET CityId = 26 WHERE Id =7;
UPDATE Countries SET Name='Romania' WHERE Id=7;
UPDATE Properties SET CityId = 26 where Id>=25 AND Id <=27
UPDATE Properties SET CityId = 30 where Id>27 AND Id <=30

select * from Properties;
select * from Reservations;
select * from Rooms where PropertyId >= 25;
select c.Id from Cities c join Countries cc on c.CountryId=cc.Id where cc.Name='Romania';

delete from RoomReservations where ReservationId > 29 
--prop = 25 / 2
INSERT INTO Reservations(UserId,CheckInDate,CheckOutDate,PayedStatus,PaymentMethod,Price) VALUES (3,'2021-11-02','2021-11-07',0,'card',127.4);
INSERT INTO RoomReservations(RoomId,ReservationId) VALUES (126,31);
INSERT INTO Reservations(UserId,CheckInDate,CheckOutDate,PayedStatus,PaymentMethod,Price) VALUES (5,'2021-11-07','2021-11-21',1,'card',170.20);
INSERT INTO RoomReservations(RoomId,ReservationId) VALUES (127,32);

--prop = 26 / 1
INSERT INTO Reservations(UserId,CheckInDate,CheckOutDate,PayedStatus,PaymentMethod,Price) VALUES (10,'2021-11-07','2021-11-21',1,'cash',100.00);
INSERT INTO RoomReservations(RoomId,ReservationId) VALUES (134,33);

--prop=27 / 3
INSERT INTO Reservations(UserId,CheckInDate,CheckOutDate,PayedStatus,PaymentMethod,Price) VALUES (6,'2021-11-01','2021-11-11',1,'card',170.20);
INSERT INTO RoomReservations(RoomId,ReservationId) VALUES (144,34);
INSERT INTO Reservations(UserId,CheckInDate,CheckOutDate,PayedStatus,PaymentMethod,Price) VALUES (8,'2021-11-05','2021-11-16',1,'card',85.10);
INSERT INTO RoomReservations(RoomId,ReservationId) VALUES (145,35);
INSERT INTO Reservations(UserId,CheckInDate,CheckOutDate,PayedStatus,PaymentMethod,Price) VALUES (9,'2021-11-30','2021-12-05',1,'card',102.15);
INSERT INTO RoomReservations(RoomId,ReservationId) VALUES (149,36);

--prop=28 / 2
INSERT INTO Reservations(UserId,CheckInDate,CheckOutDate,PayedStatus,PaymentMethod,Price) VALUES (7,'2021-11-02','2021-11-07',0,'card',125.00);
INSERT INTO RoomReservations(RoomId,ReservationId) VALUES (151,37);
INSERT INTO Reservations(UserId,CheckInDate,CheckOutDate,PayedStatus,PaymentMethod,Price) VALUES (1,'2021-11-07','2021-11-21',1,'card',300.00);
INSERT INTO RoomReservations(RoomId,ReservationId) VALUES (151,38);

--prop=29 / 1
INSERT INTO Reservations(UserId,CheckInDate,CheckOutDate,PayedStatus,PaymentMethod,Price) VALUES (1,'2021-11-02','2021-11-07',0,'card',127.4);
INSERT INTO RoomReservations(RoomId,ReservationId) VALUES (152,39);

--prop=30 / 3
INSERT INTO Reservations(UserId,CheckInDate,CheckOutDate,PayedStatus,PaymentMethod,Price) VALUES (6,'2021-11-12','2021-11-17',1,'card',120.00);
INSERT INTO RoomReservations(RoomId,ReservationId) VALUES (160,40);
INSERT INTO Reservations(UserId,CheckInDate,CheckOutDate,PayedStatus,PaymentMethod,Price) VALUES (8,'2021-11-01','2021-11-04',1,'card',90.00);
INSERT INTO RoomReservations(RoomId,ReservationId) VALUES (161,41);
INSERT INTO Reservations(UserId,CheckInDate,CheckOutDate,PayedStatus,PaymentMethod,Price) VALUES (9,'2021-11-21','2021-11-29',1,'card',102.15);
INSERT INTO RoomReservations(RoomId,ReservationId) VALUES (162,42);

select * from Reservations r join RoomReservations rr on r.Id=rr.ReservationId where rr.RoomId=151;

--ex1 Add ZipCode in Properties and update the existing entries with a random value(string).
ALTER TABLE Properties ADD ZipCode CHAR(10) NULL;
UPDATE Properties SET ZipCode=STR(Id*10000+Id*10000+Id*1000+Id*100+Id*10+Id)

--ex2 Get all the properties in Iasi(Name, Description, Address, TotalRooms).
SELECT 
	p.Name,
	p.Description,
	p.Address,
	p.TotalRooms
FROM 
	Properties p
	INNER JOIN Cities c ON p.CityId = c.Id
WHERE 
	c.Name='Iasi';

--ex3 Get the names, emails and phone numbers of the clients that made a reservation and paid for it.
SELECT
	u.FirstName +' '+ u.LastName AS Name,
	u.Email,
	u.Phone
FROM
	Users u 
	INNER JOIN Reservations r ON r.UserId=u.Id
WHERE
	r.PayedStatus = 1;

--ex4 Select first and last names for the users with admin role that administrates guest houses in Brasov and order them alphabetically by their first name and last name.
SELECT
	u.FirstName,
	u.LastName,
	u.Id
FROM
	Users u 
	INNER JOIN Roles r ON u.RoleId=r.Id
	INNER JOIN Properties p ON p.AdministratorId = u.Id
	INNER JOIN PropertyTypes t ON p.PropertyTypeId = t.Id
	INNER JOIN Cities c ON p.CityId = c.Id
WHERE
	r.Name = 'PropertyAdmin' AND --daca userul e proprietar, conditia asta e necesara? 
	c.Name = 'Brasov' AND
	t.Type = 'Guest House'
ORDER BY
	u.FirstName,
	u.LastName;

--ex5 Get all the room types and prices for rooms at InterContinental hotel in Romania.
SELECT DISTINCT
	rc.Name,
	rc.Price
FROM 
	Properties p
	INNER JOIN Cities c ON c.Id = p.CityId
	INNER JOIN Countries co ON co.Id = c.CountryId
 	INNER JOIN Rooms r ON p.Id = r.PropertyId
	INNER JOIN RoomCategories rc ON rc.Id = r.RoomCategoryId
WHERE
	p.Name='InterContinental' AND
	co.Name = 'Romania';



--ex6 Get top 5 properties in Romania by reservation count in the month of November 2021.
SELECT TOP 5
	p.Name,p.Id,
	COUNT(re.Id)
FROM
	Reservations re
	LEFT JOIN RoomReservations rr ON re.Id = rr.ReservationId 
	LEFT JOIN Rooms ro ON rr.RoomId = ro.Id 
	LEFT JOIN Properties p ON ro.PropertyId=p.Id 
	INNER JOIN Cities c ON c.Id=p.CityId 
	INNER JOIN Countries co ON co.Id = c.CountryId
WHERE
	co.Name='Romania' AND
	re.CheckInDate BETWEEN '2021-11-01' AND '2021-12-01'
GROUP BY 
	p.Id,p.Name
ORDER BY 3 DESC;

--ex 7 Get all hotels with pools with at least one room available for today.
SELECT DISTINCT
	p.Name
FROM
	Reservations r 
	INNER JOIN RoomReservations rr ON r.Id =rr.ReservationId 
	RIGHT JOIN rooms ro ON rr.RoomId=ro.Id 
	INNER JOIN Properties p  ON ro.PropertyId=p.Id 
	RIGHT JOIN PropertyTypes pt ON p.PropertyTypeId=pt.Id 
	LEFT JOIN PropertyFacilities pf ON p.Id = pf.PropertyId
	LEFT JOIN GeneralFeatures gf ON pf.FacilityId=gf.Id
WHERE 
	(pt.Type='Hotel' AND
		gf.Name Like '%Pool') AND
	(r.Id is NULL OR 
		r.CheckOutDate<=GETDATE() OR
		CheckInDate>GETDATE() OR
		CancelDate<=GETDATE()
	);


--ex 8 Get the total number of available rooms from all properties in Romania price range between 70 and 100 euro for this month.
SELECT 
	p.Id,
	COUNT(r.Id) AS 'Available rooms'
FROM
	Reservations r1 
	INNER JOIN RoomReservations rr1 ON r1.Id=rr1.ReservationId
	INNER JOIN Reservations r2 ON r1.CheckOutDate <= r2.CheckInDate
	INNER JOIN RoomReservations rr2 ON r2.Id=rr2.ReservationId
		AND rr1.RoomId = rr2.RoomId 
		AND r1.CancelDate IS NULL 
		AND r2.CancelDate IS NULL
	RIGHT JOIN Rooms r ON r.Id = rr1.RoomId
	INNER JOIN RoomCategories rc ON rc.Id = r.RoomCategoryId
	INNER JOIN Properties p ON r.PropertyId=p.Id
	INNER JOIN Cities ci ON p.CityId=ci.Id
	INNER JOIN Countries co ON ci.CountryId=co.Id
WHERE 
	((r2.CheckInDate BETWEEN DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0) AND DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) , 0)
		AND r1.CheckOutDate BETWEEN DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0) AND DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
		OR rr1.Id IS NULL)
	AND rc.Price >=70 AND rc.Price<=100
	AND co.Name = 'Romania'
GROUP BY p.Id,rr1.Id
HAVING
	rr1.Id IS NULL
	OR (CASE
		WHEN MIN(r1.CheckInDate) < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
		THEN 0 
		ELSE DATEDIFF(DAY,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0),MIN(r1.CheckInDate))
		END
	+SUM(DATEDIFF(DAY,r1.CheckOutDate,r2.CheckInDate))
	+CASE
		WHEN MAX(r2.CheckOutDate) < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
		THEN DATEDIFF(DAY,MAX(r2.CheckOutDate),DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
		ELSE 0
		END
	)>0 
;

--9. Get the highest rated property that has spa and rooms available for the next weekend.
SELECT 
	TOP 1
	p.Id
FROM
	Properties p 
	INNER JOIN Rooms r ON r.PropertyId=p.Id
	LEFT JOIN RoomReservations rr ON rr.RoomId=r.Id
	INNER JOIN Reservations re ON re.Id = rr.ReservationId AND re.CancelDate IS NULL
	INNER JOIN PropertyFacilities pfac ON p.Id=pfac.PropertyId
	INNER JOIN GeneralFeatures gfeat ON pfac.FacilityId = gfeat.Id
WHERE
	gfeat.Name='Spa'
	AND(
		rr.Id IS NULL
		OR(
		re.CheckInDate > CASE
		WHEN DATEPART(WEEKDAY,GETDATE())<=5
		THEN GETDATE() + 7 - DATEPART(WEEKDAY,GETDATE())+1
		ELSE GETDATE() + 7 + DATEPART(WEEKDAY,GETDATE())%5%2+1
		END
		OR re.CheckOutDate < CASE
		WHEN DATEPART(WEEKDAY,GETDATE())<=5
		THEN GETDATE()+6-DATEPART(WEEKDAY,GETDATE())+1
		ELSE GETDATE() + 7 + DATEPART(WEEKDAY,GETDATE())%5%2+1
		END
		)
	)
ORDER BY p.Rating;
	

--10. Get the month of the year that has the most reservations for a certain hotel.
SELECT 
	TOP 1
	COUNT(re.CheckInDate) AS 'Number of reservations',
	FORMAT(re.CheckInDate,'MM') AS 'Month'
FROM
	Properties p
	INNER JOIN Rooms r ON p.Id=r.PropertyId
	INNER JOIN RoomReservations rr ON rr.RoomId=r.Id
	INNER JOIN Reservations re ON rr.ReservationId=re.Id
WHERE 
	p.Id=28
GROUP BY FORMAT(re.CheckInDate,'MM')
ORDER BY 1 DESC;

--11. Find properties that have 2 double rooms available for the next week in Antwerp that cost between 100 and 150 euro.
SELECT 
	p.Id,
	p.Name
FROM
	Properties p
	INNER JOIN Cities c on p.CityId=c.Id
	INNER JOIN Rooms r on r.PropertyId=p.Id
	INNER JOIN RoomCategories rc ON rc.Id=r.RoomCategoryId
	LEFT JOIN RoomReservations rr ON r.Id = rr.RoomId
	INNER JOIN Reservations re ON rr.ReservationId=re.Id
WHERE
	c.Name = 'Antwerp'
	AND rc.Price>=100 AND rc.Price <=150
	AND rc.Name = 'Double Room'
	AND re.CheckInDate NOT BETWEEN GETDATE() + 7 - DATEPART(WEEKDAY,GETDATE()) AND GETDATE() + 14 - DATEPART(WEEKDAY,GETDATE())
	AND re.CheckOutDate NOT BETWEEN GETDATE() + 7 - DATEPART(WEEKDAY,GETDATE()) AND GETDATE() + 14 - DATEPART(WEEKDAY,GETDATE()) 
GROUP BY p.Id,r.RoomCategoryId,p.Name
HAVING COUNT(r.RoomCategoryId)>=2
	

--12. Get the number of distinct guests that have made bookings for 05/2021 in each hotel in Iasi.
SELECT
	p.Id, 
	COUNT(DISTINCT re.UserId) AS 'Number of users'
FROM
	Countries co 
	INNER JOIN Cities c ON co.Id=c.CountryId
	INNER JOIN Properties p ON c.Id=p.CityId
	INNER JOIN Rooms r on r.PropertyId = p.Id
	INNER JOIN RoomReservations rr ON rr.RoomId = r.Id
	INNER JOIN Reservations re ON re.Id = rr.ReservationId
		AND re.CancelDate IS NULL
	INNER JOIN PropertyTypes pt ON pt.Id = p.PropertyTypeId
WHERE
	c.Name = 'Iasi'
	AND re.CheckInDate BETWEEN '2021-05-01' AND '2021-06-01'
	AND pt.Type = 'Hotel'
GROUP BY p.Id;



--13. Select name, description and address for the locations that will have availability next year (2022) between May and September.
SELECT
	p.Name,
	p.Description,
	p.Address
FROM
	Reservations r1 
	INNER JOIN RoomReservations rr1 ON r1.Id=rr1.ReservationId
	INNER JOIN Reservations r2 ON r1.CheckOutDate <= r2.CheckInDate
	INNER JOIN RoomReservations rr2 ON r2.Id=rr2.ReservationId
		AND rr1.RoomId = rr2.RoomId 
		AND r1.CancelDate IS NULL 
		AND r2.CancelDate IS NULL
	RIGHT JOIN Rooms r on r.Id = rr1.RoomId
	INNER JOIN RoomCategories rc ON rc.Id = r.RoomCategoryId
	INNER JOIN Properties p ON r.PropertyId=p.Id
WHERE
	rr1.Id IS NULL
	OR (r2.CheckInDate BETWEEN '2021-10-01' AND '2021-12-01'
	AND r1.CheckOutDate BETWEEN '2021-10-01' AND '2021-12-01')
GROUP BY
	p.Id,rr1.Id,p.Name,p.Description,p.Address
HAVING
	rr1.Id IS NULL
	OR
	(CASE
		WHEN MIN(r1.CheckInDate) < '2022-05-01'
		THEN 0 
		ELSE DATEDIFF(DAY,'2022-05-01',MIN(r1.CheckInDate))
		END
	+SUM(DATEDIFF(DAY,r1.CheckOutDate,r2.CheckInDate))
	+CASE
		WHEN MAX(r2.CheckOutDate) < '2022-10-01'
		THEN DATEDIFF(DAY,MAX(r2.CheckOutDate),'2022-10-01')
		ELSE 0
		END
	)>0
;

--14. Display top 10 hotels(name, city and rating) in Romania that had the highest earnings last year.
--15. Get all the properties in Santorini, Greece that have at least 3 stars and rooms with view of the ocean available for any day in August 2022.
--16. Display top 5 and last 5 properties that have the greatest difference(positive and negative) between their rating and their average reviews rating.
--17. Given a certain month of the year and a property, calculate the occupancy rate for each day of that month and express it in percentages and color(<50% = green, >=50% and <90% yellow, >=90% red).
--18. Get the lost income from unoccupied rooms at the Unirea Hotel for today.
--19. Get the most commonly booked room type for each hotel in London.
--20. Get all the properties in Dubrovnik, Croatia that have at least 4 stars in customer reviews and are available for at least 7 consecutive days in the months of June.
