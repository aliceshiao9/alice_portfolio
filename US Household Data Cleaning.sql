#EXPLORE DATASETS TO UNDERSTAND STRUCTURE AND DATA QUALITY
SELECT * FROM us_household_income.us_household_income;
SELECT * FROM us_household_income.us_household_income_statistics;

#STANDARDIZE COLUMN NAMES FOR CONSISTENCY
ALTER TABLE us_household_income_statistics RENAME COLUMN `ID` TO `id`;

#COUNT RECORDS IN EACH TABLE
SELECT COUNT(id) FROM us_household_income;
SELECT COUNT(id) FROM us_household_income_statistics;

#IDENTIFY DUPLICATES
SELECT id, COUNT(id)
FROM  us_household_income.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

#REMOVE DUPLICATE ROWS WHILE KEEPING ONE RECORD PER ID
DELETE FROM us_household_income.us_household_income
WHERE row_id IN (
			SELECT row_id 
            FROM
			(SELECT row_id,
			id,
			ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS R1
			FROM  us_household_income.us_household_income) AS T1
			WHERE R1 > 1
			)
;

#VERIFY THAT us_household_income_statistics HAS NO DUPLICATES
SELECT id, COUNT(id)
FROM  us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

#STANDARDIZE FORMAT

-- STANDARDIZE STATE NAMES

-- Check state name variations
SELECT State_Name, COUNT(State_Name) 
FROM us_household_income
GROUP BY State_Name
;
SELECT DISTINCT State_Name
FROM us_household_income
ORDER BY State_Name
;
-- Correct typos
UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'
;


-- STANDARDIZE PLACE NAMES

-- Identify missing place names
SELECT *
FROM  us_household_income
WHERE Place = ''
;

-- Inspect context for missing data
SELECT PLACE
FROM us_household_income
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;


-- Fill missing place names
UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

-- STANDARDIZE TYPE COLUMN

SELECT Type, COUNT(Type)
FROM us_household_income.us_household_income
GROUP BY Type
;

-- Correct inconsistent values
UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;


-- IDENTIFY MISSING OR INVALID ALAND & AWATER VALUES
SELECT DISTINCT ALand
FROM us_household_income.us_household_income
WHERE ALand = 0 OR ALand = '' OR ALand IS NULL 
;
SELECT DISTINCT AWater
FROM us_household_income.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL 
;

-- IDENTIFY ROWS MISSING BETWEEN TWO TABLES
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