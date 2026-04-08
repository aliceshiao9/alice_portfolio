#WORLD LIFE EXPECTANCY PROJECT -- DATA CLEANING
SELECT *
FROM world_life_expectancy.world_life_expectancy
;

#IDENTIFY AND REMOVE DUPLICATE -- CONCAT(COUNTRY, YEAR), WHICH SHOULD BE UNIQUE

#SELECT Country, Year, ROW_NUMBER() OVER(PARTITION BY Country, Year) FROM world_life_expectancy;

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

#SELECT Row_ID, CONCAT(Country, Year) FROM world_life_expectancy WHERE CONCAT(Country, Year) IN ('Ireland2022', 'Senegal2009', 'Zimbabwe2019');

SELECT Row_ID FROM
(SELECT Row_ID, 
CONCAT(Country, Year), 
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS ROW_NUM
FROM world_life_expectancy) AS ROW_NUM_TABLE
WHERE ROW_NUM > 1
;

DELETE FROM world_life_expectancy
WHERE Row_ID IN (SELECT Row_ID FROM
(SELECT Row_ID, 
CONCAT(Country, Year), 
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS ROW_NUM
FROM world_life_expectancy) AS ROW_NUM_TABLE
WHERE ROW_NUM > 1)
;


#DEAL WITH MISSING DATA -- STATUS, LIFE_EXPECTANCY
SELECT *
FROM world_life_expectancy.world_life_expectancy
WHERE Status = ''
;
SELECT DISTINCT Status
FROM world_life_expectancy
WHERE Status <> ''
;

#IDENTIFY COUNTRY IS DEVELOPING OR DEVELOPED AND UPDATE STATUS
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;
#WAY1 -- ERROR
UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
				FROM world_life_expectancy
				WHERE Status = 'Developing')
;

#WAY2 -- MORE COMPLICATED(JOIN TWO TABLE AND UPDATE)
#UPDATE DEVELOPING COUNTRY
SELECT w1.Country, w1.Status, w2.Country, w2.Status
FROM world_life_expectancy w1
JOIN world_life_expectancy w2
	ON w1.Country = w2.Country
;

UPDATE world_life_expectancy w1
JOIN world_life_expectancy w2
	ON w1.Country = w2.Country
SET w1.Status = 'Developing'
WHERE w1.Status = ''
AND w2.Status <> ''
AND w2.Status = 'Developing'
;
#ONE ROW LEFT
SELECT *
FROM world_life_expectancy
WHERE Country = 'United States of America'
;

#UPDATE DEVELOPED COUNTRY

UPDATE world_life_expectancy w1
JOIN world_life_expectancy w2
	ON w1.Country = w2.Country
SET w1.Status = 'Developed'
WHERE w1.Status = ''
AND w2.Status <> ''
AND w2.Status = 'Developed'
;

SELECT Status
FROM world_life_expectancy
WHERE Status = ''
;

SELECT Status
FROM world_life_expectancy
WHERE Status IS NULL
;


#LIFE EXPECTANCY -- POPULATE THE BLANK WITH THE AVERAGE OF THE PREVIOUS AND LATTER NUMBER -- USE JOIN(WONDER IF I COULD USE LAG/LEAD)
#JOIN THE TABLE AND CACULATE THE RIGHT NUMBER IN SAME ROW
SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy`+ t3.`Life expectancy`)/2, 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year +1
WHERE t1.`Life expectancy` = ''
;

#UPDATE THE BLANK VALUE -- UPDATE___JOIN___ON___JOIN___ON___SET___

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year +1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy`+ t3.`Life expectancy`)/2, 1)
WHERE t1.`Life expectancy` = ''
;