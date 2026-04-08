SELECT * FROM us_household_income.us_household_income;

SELECT * FROM us_household_income.us_household_income_statistics;

ALTER TABLE us_household_income_statistics RENAME COLUMN `ID` TO `id`;

SELECT COUNT(id) FROM us_household_income;
SELECT COUNT(id) FROM us_household_income_statistics;

#IDENTIFY AND REMOVE DUPLICATE
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;


DELETE FROM us_household_income
WHERE row_id IN (
			SELECT row_id 
            FROM
			(SELECT row_id,
			id,
			ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS R1
			FROM us_household_income) AS T1
			WHERE R1 > 1
			)
;

#NO DUPPLICATE IN us_household_income_statistics
SELECT id, COUNT(id)
FROM  us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

#STANDARDIZE FORMAT

#STATE

SELECT State_Name, COUNT(State_Name) 
FROM us_household_income
GROUP BY State_Name
;
SELECT DISTINCT State_Name
FROM us_household_income
ORDER BY State_Name
;

UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'
;

#PLACE

SELECT *
FROM  us_household_income
WHERE Place = ''
;

SELECT PLACE
FROM us_household_income
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

#TYPE
SELECT Type, COUNT(Type)
FROM us_household_income.us_household_income
GROUP BY Type
;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

#ALand, AWater

SELECT DISTINCT ALand
FROM us_household_income.us_household_income
WHERE ALand = 0 OR ALand = '' OR ALand IS NULL 
;
SELECT DISTINCT AWater
FROM us_household_income.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL 
;

#HOW MANY ROW I'M MISSING IN TABLE us_household_income(TWO TABLE COMPARE)
SELECT COUNT(uss.id)
FROM us_household_income.us_household_income us
RIGHT JOIN us_household_income.us_household_income_statistics uss
	ON us.id = uss.id
WHERE us.id IS NULL
;


SELECT uss.id
FROM us_household_income.us_household_income us
RIGHT JOIN us_household_income.us_household_income_statistics uss
	ON us.id = uss.id
WHERE us.id IS NULL
;