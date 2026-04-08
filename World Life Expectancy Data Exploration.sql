#WORLD LIFE EXPECTANCY PROJECT (EXPLORATORY DATA ANALYSIS)

SELECT * 
FROM world_life_expectancy
;

SELECT `Life expectancy` 
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;
SELECT `Life expectancy` 
FROM world_life_expectancy
WHERE `Life expectancy` IS NULL
;
SELECT `Life expectancy` 
FROM world_life_expectancy
WHERE `Life expectancy` = 0
;

SELECT Country,  
MIN(`Life expectancy`), 
MAX(`Life expectancy`), 
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Country DESC
;

SELECT Year, ROUND(AVG(`Life expectancy`), 2)
FROM world_life_expectancy
WHERE `Life expectancy` <> ''
AND `Life expectancy` <> 0
GROUP BY Year
;

SELECT COUNTRY, ROUND(AVG(`Life expectancy`), 1) AS Life_Exp, ROUND(AVG(GDP), 1) AS GDP
FROM world_lif e_expectancy
GROUP BY COUNTRY
HAVING Life_Exp > 0 
AND GDP > 0
ORDER BY GDP ASC
;

#FIND THE CORRELATION BETWEEN GDP AND LIFE EXPECTANCY -- APPLICABLE TO BASICALLY OTHER FACTOR  SUCH AS BMI
SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS HIGH_GDP_COUNT,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) AS High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS LOW_GDP_COUNT,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) AS LOW_GDP_Life_Expectancy
FROM world_life_expectancy;

#FIND THE CORRELATION BETWEEN STATUS AND LIFE EXPECTANCY

SELECT STATUS, ROUND(AVG(`Life expectancy`),1) #COUNT(`Life expectancy`)
FROM world_life_expectancy
GROUP BY STATUS
;

SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

#FIND THE CORRELATION BETWEEN BMI AND LIFE EXPECTANCY

SELECT COUNTRY, ROUND(AVG(BMI),1), ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY COUNTRY
;

#ROLLING TOTAL -- USING WINDOW FUNCTION(SUM()OVER(PARTITION BY___ORDER BY YEAR))
#SELECT `Adult Mortality`, SUM(`Adult Mortality`) OVER() FROM world_life_expectancy;
#SELECT SUM(`Adult Mortality`) FROM world_life_expectancy;

#TRY ROLLING TOTAL BY MYSELF
SELECT Year, SUM(`Adult Mortality`) AS Adult_Mortality, SUM(SUM(`Adult Mortality`)) OVER () AS TOTAL, SUM(SUM(`Adult Mortality`)) OVER (ORDER BY Year) AS ROLLING_TOTAL
FROM world_life_expectancy
GROUP BY Year;


SELECT Country, Year, `Life expectancy`, `Adult Mortality`, SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy;
