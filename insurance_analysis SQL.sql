SELECT * FROM insurance WHERE AGE LIMIT 10; -- Preview the dataset to understand its structure and the type of data it contains

-- checking for duplicates
SELECT age, sex, bmi, children, smoker, region, charges, COUNT(*) AS cnt
FROM insurance
GROUP BY age, sex, bmi, children, smoker, region, charges
HAVING cnt > 1;

-- DELETING THE DUPLICATE
ALTER TABLE insurance DROP COLUMN id;
DROP TABLE IF EXISTS insurance_temp;
CREATE TABLE insurance_temp AS SELECT DISTINCT * FROM insurance;
TRUNCATE TABLE insurance;
INSERT INTO insurance SELECT * FROM insurance_temp;
DROP TABLE insurance_temp;
ALTER TABLE insurance ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- Compare average insurance charges between smokers and non-smokers to see the impact of smoking on cost
SELECT smoker, avg(charges) AS smokers_charges
FROM insurance
GROUP BY smoker
order BY Smokers_charges DESC;

-- Average charges by region
SELECT region, avg(charges) AS Region_charges
FROM insurance
GROUP BY region
ORDER BY Region_charges DESC;

-- combinining smoker status and region together to see if the smoking effect holds across all regions
SELECT smoker,region,avg(charges) AS Region_smoker_charges
FROM insurance
GROUP BY region,smoker
HAVING smoker = 'yes'
ORDER BY Region_smoker_charges DESC;

SELECT  MAX(bmi) AS Highest_bmi, MIN(bmi) AS Lowest_bmi
FROM insurance;

-- Average charges by BMI category
SELECT   CASE 
WHEN bmi < 18.5 THEN 'Underweight'
WHEN bmi >= 18.5 AND bmi < 25 THEN 'Normal'
WHEN bmi >= 25 AND bmi < 30 THEN 'Overweight'
ELSE 'Obese'
  END AS bmi_category,
  AVG(charges) AS avg_charges,
  COUNT(*) AS num_people
FROM insurance
GROUP BY bmi_category
ORDER BY avg_charges DESC;

-- BMI category effect, split by smoker status
SELECT 
  smoker,
  CASE 
WHEN bmi < 18.5 THEN 'Underweight'
WHEN bmi < 25 THEN 'Normal'
WHEN bmi < 30 THEN 'Overweight'
ELSE 'Obese'
  END AS bmi_category,
  AVG(charges) AS avg_charges,
  COUNT(*) AS num_people
FROM insurance
GROUP BY smoker, bmi_category
ORDER BY smoker, avg_charges DESC;

-- Age brackets, split by smoker status
SELECT 
  smoker,
  CASE 
    WHEN age < 30 THEN '18-29'
    WHEN age < 45 THEN '30-44'
    WHEN age < 60 THEN '45-59'
    ELSE '60+'
  END AS age_bracket,
  AVG(charges) AS avg_charges,
  COUNT(*) AS num_people
FROM insurance
GROUP BY smoker, age_bracket
ORDER BY smoker, age_bracket;

-- checking the relationship of having children with charges
SELECT children, avg(charges) AS depedent_charges
FROM insurance
GROUP BY Children
ORDER BY depedent_charges DESC;

SELECT Age,Smoker,bmi, avg(charges) AS Age_chaeges
FROM insurance
group by age,smoker,bmi
ORDER BY Age_chaeges DESC;

SELECT sex, avg(charges) AS gender_charges
FROM insurance
GROUP BY sex
ORDER BY gender_charges  DESC;


-- Summary of findings:
---- Key finding: Smoking combined with high BMI drives charges up dramatically (obese smokers pay ~4.7x more than obese non-smokers); 
-- age and region have smaller, independent effects.


