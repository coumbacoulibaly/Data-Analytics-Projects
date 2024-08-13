
--------------- E X P L O R I N G   D A T A ---------------

USE [Insurances Analysis ]

Select *
FROM InsuranceData

---- Dataset Shape, number of rows and columns -----
-- Number of rows
SELECT COUNT(*) as row_num
FROM InsuranceData 

-- Number of columns
SELECT count (column_name) as col_num 
FROM information_schema.columns 
WHERE table_name='InsuranceData' 

-- Checking distinct values
SELECT DISTINCT marital_status
FROM InsuranceData

SELECT DISTINCT car_use
FROM InsuranceData

SELECT DISTINCT education
FROM InsuranceData

SELECT DISTINCT car_make
FROM InsuranceData

SELECT DISTINCT car_color
FROM InsuranceData

SELECT DISTINCT coverage_zone
FROM InsuranceData

--------------- C U S T O M E R S ------------------

--- Customer ages ---
SELECT ID, YEAR(CONVERT(date,GETDATE())) - YEAR(birthdate) as Age 
FROM InsuranceData

--- Customer average age ---
SELECT AVG(YEAR(CONVERT(date,GETDATE())) - YEAR(birthdate)) as Age 
FROM InsuranceData

--- Youngest Customer ---
SELECT MIN(YEAR(CONVERT(date,GETDATE())) - YEAR(birthdate)) as youngest_customer 
FROM InsuranceData

--- oldest Customer ---
SELECT MAX(YEAR(CONVERT(date,GETDATE())) - YEAR(birthdate)) as oldest_customer 
FROM InsuranceData

--- Customers' Household Income ---
SELECT ID, household_income 
FROM InsuranceData

--- Average Customers' Household Income ---
SELECT AVG(household_income) 
FROM InsuranceData

--- Highest Customers' Household Income ---
SELECT MAX(household_income) 
FROM InsuranceData

--- Lowest Customers' Household Income ---
SELECT ROUND(MIN(household_income), 1) 
FROM InsuranceData

--- Median Customers' Household Income ---
--To calculate the median of this dataset, we will use the median formula
--by finding the 2 middle values and dividing them by 2. Since our dataset is even, 
--we will proceed like this. But with odd datasets, we just select the middle number.
SELECT (
(SELECT MAX(household_income) 
FROM 
(SELECT top 50 percent household_income 
FROM InsuranceData 
ORDER BY household_income) AS bottomhalf)
+
(SELECT MIN(household_income) 
FROM 
(SELECT top 50 percent household_income 
FROM InsuranceData 
ORDER BY household_income DESC) AS tophalf)
)/2 AS median_household_income

---	Education level percentage ---
SELECT education, COUNT(*) AS nb_people , (COUNT(*) * 100/(SELECT COUNT(*) FROM InsuranceData)) AS 'Percentage'
FROM InsuranceData 
GROUP BY education 

---	Marital Status percentage ---
SELECT marital_status, COUNT(*) AS nb_people , (COUNT(*) * 100/(SELECT COUNT(*) FROM InsuranceData)) AS 'Percentage'
FROM InsuranceData 
GROUP BY marital_status 

---	Coverage Zone percentage ---
SELECT coverage_zone, COUNT(*) AS nb_people , (COUNT(*) * 100/(SELECT COUNT(*) FROM InsuranceData)) AS 'Percentage'
FROM InsuranceData 
GROUP BY coverage_zone 

---	Car Usage percentage ---
SELECT car_use, COUNT(*) AS nb_people , (COUNT(*) * 100/(SELECT COUNT(*) FROM InsuranceData)) AS 'Percentage'
FROM InsuranceData 
GROUP BY car_use 

---	Gender percentage ---
SELECT gender, COUNT(*) AS nb_people , (COUNT(*) * 100/(SELECT COUNT(*) FROM InsuranceData)) AS 'Percentage'
FROM InsuranceData 
GROUP BY gender 

---	Parent percentage ---
SELECT parent, COUNT(*) AS nb_people , ROUND ((COUNT(*) * 100/(SELECT COUNT(*) FROM InsuranceData)), 2) AS 'Percentage'
FROM InsuranceData 
GROUP BY parent

---	Average number of children if parent ---
SELECT AVG(kids_driving)
FROM InsuranceData
WHERE parent= 'Yes'

--------------- C A R S -----------------------

---	Car age ---
SELECT ID, car_year, (YEAR(GETDATE()) - car_year) AS car_age
FROM InsuranceData

---	Average car age ---
SELECT AVG(YEAR(GETDATE()) - car_year) AS car_age
FROM InsuranceData

---	Oldest car ---
SELECT MAX(YEAR(GETDATE()) - car_year) AS car_age
FROM InsuranceData

---	Newest car ---
SELECT MIN(YEAR(GETDATE()) - car_year) AS car_age
FROM InsuranceData

---	Top 3 car manufacturer ---
SELECT TOP 3 percent car_make, COUNT(*) AS nb_car
FROM InsuranceData
GROUP BY car_make
ORDER BY nb_car DESC

---	Top 3 car models ---
SELECT TOP 0.2 percent car_model, COUNT(*) AS nb_car
FROM InsuranceData
GROUP BY car_model
ORDER BY nb_car DESC

---	Top 3 car colors ---
SELECT TOP 15 percent car_color, COUNT(*) AS nb_car
FROM InsuranceData
GROUP BY car_color
ORDER BY nb_car DESC



--------------- C L A I M S -----------------------

---	SUM of amount claimed ---
SELECT SUM(claim_amt)
FROM InsuranceData

---	Average Claim frequency ---
SELECT AVG(claim_freq) AS claim_frequency
FROM InsuranceData 

---	Average Claim frequency by car usage ---
SELECT car_use, AVG(claim_freq) AS claim_frequency
FROM InsuranceData 
GROUP BY car_use 

---	Average Claimed amount by car usage ---
SELECT car_use, AVG(claim_amt) AS claim_amount
FROM InsuranceData 
GROUP BY car_use 

---	Average Claim frequency by covarage zone ---
SELECT coverage_zone, AVG(claim_freq) AS claim_frequency
FROM InsuranceData 
GROUP BY coverage_zone 

---	Average Claimed amount by covarage zone ---
SELECT coverage_zone, AVG(claim_amt) AS claim_amount
FROM InsuranceData 
GROUP BY coverage_zone 

---	Car age rang ---
--I will 2 new columns car_age_rang to classify all car by age.
--this will help to the corelation between the car age and the claim frequency and amount
ALTER TABLE InsuranceData
ADD car_age_rang nvarchar(50);

ALTER TABLE InsuranceData
ADD car_age numeric(18,0);

--Setting ages and age rangs
UPDATE InsuranceData
SET car_age = YEAR(GETDATE()) - car_year
WHERE car_age IS NULL

UPDATE InsuranceData
SET car_age_rang = CASE
					WHEN car_age < 10 THEN 'Under 10 years'
					WHEN car_age BETWEEN 10 AND 20 THEN '10-20 years'
					WHEN car_age BETWEEN 20 AND 30 THEN '20-30 years'
					ELSE 'Over 30 years'
					END
WHERE car_age_rang IS NULL

---	Average claim frequence by car age ---
SELECT car_age_rang, AVG(claim_freq) AS claim_frequency
FROM InsuranceData 
GROUP BY car_age_rang 

---	Average claim amount by car age ---
SELECT car_age_rang, AVG(claim_amt) AS claim_amount
FROM InsuranceData 
GROUP BY car_age_rang 



SELECT *
FROM InsuranceData 
