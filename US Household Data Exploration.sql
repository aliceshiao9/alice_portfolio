#US Household Income Exploratory Data Analysis

SELECT * FROM us_household_income.us_household_income;
SELECT * FROM us_household_income.us_household_income_statistics;


#STATE, ALand, AWater
SELECT State_Name, County, City, ALand, AWater
FROM us_household_income.us_household_income;


SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10
;

#COMBINE TWO TABLE
SELECT * 
FROM us_household_income.us_household_income us
INNER JOIN us_household_income.us_household_income_statistics uss
	ON us.id = uss.id
WHERE Mean <> 0;

SELECT us.State_Name, County, Type, `Primary`, Mean, Median 
FROM us_household_income.us_household_income us
INNER JOIN us_household_income.us_household_income_statistics uss
	ON us.id = uss.id
WHERE Mean <> 0;

#STATE, MEAN, MEDIAN
SELECT us.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1) 
FROM us_household_income.us_household_income us
INNER JOIN us_household_income.us_household_income_statistics uss
	ON us.id = uss.id
WHERE Mean <> 0
GROUP BY us.State_Name
ORDER BY 3 DESC
LIMIT 10
;

#Type, COUNT(TYPE), `Primary`, MEAN, MEDIAN

SELECT Type, COUNT(TYPE), ROUND(AVG(Mean),1), ROUND(AVG(Median),1) 
FROM us_household_income.us_household_income us
INNER JOIN us_household_income.us_household_income_statistics uss
	ON us.id = uss.id
WHERE Mean <> 0
GROUP BY Type
HAVING COUNT(TYPE) > 100
ORDER BY 3 DESC
LIMIT 20
;
#DIG EVEN DEEPER -- SELECT * FROM us_household_income WHERE Type = 'Community';


#CITY, MEAN, Median

SELECT us.State_Name, City, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income.us_household_income us
INNER JOIN us_household_income.us_household_income_statistics uss
	ON us.id = uss.id
WHERE Mean <> 0
GROUP BY us.State_Name, City
ORDER BY 3 DESC
;
