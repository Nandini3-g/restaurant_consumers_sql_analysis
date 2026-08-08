create database projectdb;
use projectdb;

-- CSV's we have.....,
-- ***consumers.csv ==> information about individual consumers.
-- ***consumer_preferences.csv ==> single consumer might have many preferred cuisines(food items), so they might appear multiple times in this file, each time with a different cuisine.
-- ***resturants.csv ==> lists various restaurants and their details.
-- ***restaurant_cuisines.csv ==>  A single restaurant might offer multiple cuisines, so it could appear multiple times here.
-- ***ratings.csv ==>  important file! It records the ratings that consumers have given to specific restaurants.
-- ***data_dictionary.csv ==>  about existing tables and their columns.. deescription


-- creating table 
create table restaurants(Restaurant_ID int primary key,
 Name varchar(50) unique not null,City varchar(30) not null,State varchar(50) not null,
 Country varchar(45) not null, Zip_Code int ,Latitude float(7,5) not null,
Longitude  float(9,5) not null,Alcohol_Service varchar(30) not null,
Smoking_Allowed varchar(20) not null, Price  varchar(20) not null, Franchise varchar(10) not null,
Area varchar(20) not null,Parking varchar(20) not null
); 

desc restaurants;

select * from RESTAURANT_CUISINES;

CREATE TABLE CONSUMERS(
CONSUMER_ID VARCHAR(10) check (consumer_id like "U%") primary key ,CITY VARCHAR(60) ,STATE VARCHAR(60),
COUNTRY VARCHAR(60),LATITUDE DECIMAL(10,7),LONGITUDE DECIMAL(10,7),
SMOKER VARCHAR(10),DRINK_LEVEL VARCHAR(50),
TRANSPORTATION_METHOD VARCHAR(50),MARTIAL_STATUS VARCHAR(20),
CHILDREN VARCHAR(20),AGE int,OCCUPATION VARCHAR(50),
BUDGET VARCHAR(10));

desc consumers;
SELECT * FROM CONSUMERS;

CREATE TABLE CONSUMER_PREFERENCES(
CONSUMER_ID VARCHAR(10) not null,
PREFFERED_CUISINE VARCHAR(255) not null,
FOREIGN KEY(CONSUMER_ID) REFERENCES CONSUMERS(CONSUMER_ID)
);

SELECT * FROM CONSUMER_PREFERENCES;

CREATE TABLE RESTAURANT_CUISINES(
RESTAURANT_ID INT,
CUISINE VARCHAR(70),
FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANTS(RESTAURANT_ID)
);

SELECT * FROM RESTAURANT_CUISINES;

CREATE TABLE RATINGS(
CONSUMER_ID VARCHAR(10),
RESTAURANT_ID INT,
OVERALL_RATING INT not null,
FOOD_RATING INT,
SERVICE_RATING INT,
FOREIGN KEY (CONSUMER_ID) REFERENCES CONSUMERS(CONSUMER_ID),
FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANTS(RESTAURANT_ID)
);

select * from ratings;

-- ____________________________________________________________________________________

-- 1.List all details of consumers who live in the city of 'Cuernavaca'.

select * from consumers where city= 'Cuernavaca';

-- 2. Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students' AND are 'Smokers'.

select Consumer_ID, Age,Occupation from consumers where occupation ="Student" and smoker="yes";
-- 3.List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & Beer' 
-- and have a 'Medium' price level.
select * from restaurants;
select  Name, City, Alcohol_Service, Price from restaurants where alcohol_service="Wine & Beer" and price ="Medium";

-- 4.Find the names and cities of all restaurants that are part of a 'Franchise'.
select  name , city from restaurants where Franchise="Yes";

-- 5.Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings where the Overall_Rating was 'Highly Satisfactory'
--  (which corresponds to a value of 2, according to the data dictionary).

select consumer_id, restaurant_id, overall_rating from ratings where overall_rating = 2;

-- joins , subqueries____________________________________________________________________________

-- 1.List the names and cities of all restaurants that have an Overall_Rating of 2 (Highly Satisfactory) from at least one consumer.

select  distinct res.name,res.city,ra.overall_rating from restaurants as res inner join ratings as ra 
on res.restaurant_id = ra.restaurant_id where ra.overall_rating=2; 

-- 2 Find the Consumer_ID and Age of consumers who have rated restaurants located in 'San Luis Potosi'.

select c.consumer_id, c.age from consumers as c inner join ratings as r on c.consumer_id = r.consumer_id
inner join restaurants as res  on  res.restaurant_id = r.restaurant_id 
where res.city = 'San Luis Potosi';

-- 3.List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'.
select r.name from restaurants as r inner join restaurant_cuisines as rc 
on r.restaurant_id=rc.restaurant_id inner join ratings as ra on r.restaurant_id= ra.restaurant_id 
where ra.consumer_id ='U1001' and rc.cuisine ='Mexican';

-- 4.Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.
select * from consumers as c inner join consumer_preferences  as cp on c.consumer_id= cp.consumer_id 
where c.budget ='Medium' and preffered_cuisine = 'American';

-- 5. List restaurants (Name, City) that have received a Food_Rating lower than the average Food_Rating across all rated restaurants.

SELECT 
    r.Name, r.City
FROM
    restaurants AS r
        INNER JOIN
    ratings AS ra ON r.restaurant_id = ra.restaurant_id
WHERE
    ra.food_rating < (SELECT 
            AVG(ra.food_rating) AS avg_rating
        FROM
            ratings AS ra);

-- 6. Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant 
-- but have NOT rated any restaurant that serves 'Italian' cuisine.

select distinct c.consumer_id, c.age,c.Occupation from consumers as c  inner join  ratings as ra
 on  c.consumer_id=ra.consumer_id where c.consumer_id not in
 (select ra.consumer_id from ratings as ra inner join restaurant_cuisines as rc 
 on ra.restaurant_id= rc.restaurant_id where  cuisine='Italian');

-- 7. List restaurants (Name) that have received ratings from consumers older than 30.

select distinct r.name from restaurants as r inner join ratings  as ra on r.restaurant_id = ra.restaurant_id 
inner join consumers as c on ra.consumer_id= c.consumer_id where c.age>30;

-- 8. Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' and
-- who have given an Overall_Rating of 0 to at least one restaurant (any restaurant).

SELECT DISTINCT c.consumer_id, c.occupation
FROM consumers c
INNER JOIN consumer_preferences cp
    ON c.consumer_id = cp.consumer_id
INNER JOIN ratings ra
    ON c.consumer_id = ra.consumer_id
WHERE cp.preffered_cuisine = 'Mexican'
  AND ra.overall_rating = 0;

-- 9. List the names and cities of restaurants that serve 'Pizzeria' cuisine and are located in a city
--  where at least one 'Student' consumer lives.

select r.name , r.city from restaurants as r inner join restaurant_cuisines as rc 
on r.restaurant_id = rc.restaurant_id where rc.cuisine = 'Pizzeria'
and r.city in (select c.city from consumers as c where occupation='student');

-- 10 . Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant 
-- that has 'No' parking.

SELECT c.consumer_id, c.age
FROM consumers c
WHERE c.drink_level = 'Social Drinker'
  AND c.consumer_id IN (
      SELECT ra.consumer_id
      FROM ratings ra
      INNER JOIN restaurants r
          ON ra.restaurant_id = r.restaurant_id
      WHERE r.parking = 'None');

-- Questions Emphasizing WHERE Clause and Order of Execution_____________________________________________

-- 1. List Consumer_IDs and the count of restaurants they've rated, but only for consumers who are 'Students'. 
-- Show only students who have rated more than 2 restaurants.

select c.CONSUMER_ID, count(r.RESTAURANT_ID) as count_id
from ratings r join consumers c
on r.CONSUMER_ID = c.CONSUMER_ID
where c.occupation = "Student"
group by c.CONSUMER_ID
having count_id > 2;

-- 2.We want to categorize consumers by an 'Engagement_Score' which is their Age divided by 10 (integer division).
-- List the Consumer_ID, Age, and this calculated Engagement_Score, but only for consumers whose 
-- Engagement_Score would be exactly 2 and who use 'Public' transportation.

select c2.Consumer_ID,c1.age/10 as engagement_score from
consumers as c1 inner join consumers as c2 on c1.consumer_id =c2.consumer_id
where c1.age/10=2 and c2.transportation_method='public';

-- 3. For each restaurant, calculate its average Overall_Rating. Then, list the restaurant Name, City,
-- and its calculated average Overall_Rating, but only for restaurants located 
-- in 'Cuernavaca' AND whose calculated average Overall_Rating is greater than 1.0.


SELECT 
    res.name, res.city, AVG(ra.overall_rating) AS avg_rating
FROM
    restaurants AS res
        LEFT JOIN
    ratings AS ra ON res.restaurant_id = ra.restaurant_id
WHERE
    res.city = 'Cuernavaca'
GROUP BY res.name , res.city
HAVING AVG(ra.overall_rating) > 1.0;

-- 4. Find consumers (Consumer_ID, Age) who are 'Married' and whose Food_Rating for any restaurant is equal to their 
-- Service_Rating for that same restaurant, but only consider ratings where the Overall_Rating was 2.

select  distinct c.consumer_id ,c.age from consumers as c  inner join ratings as ra on c.consumer_id = ra.consumer_id
 where c.MARTIAL_STATUS='married'and  ra.food_rating =ra.service_rating and  ra.overall_rating=2; 
 
 -- 5. List Consumer_ID, Age, and the Name of any restaurant they rated, but only for consumers who are 'Employed' 
 -- and have given a Food_Rating of 0 to at least one restaurant located in 'Ciudad Victoria'.

select distinct c.consumer_id , c.age , r.name from consumers as c 
inner join ratings as ra on c.consumer_id = ra.consumer_id 
inner join restaurants as r on r.restaurant_id = ra.restaurant_id 
where c.occupation= 'employed' and  ra.food_rating =0 and r.city = 'Ciudad Victoria';

-- _______________________________________________________________________________________________________________
-- Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures

-- 1.Using a CTE, find all consumers who live in 'San Luis Potosi'. Then, list their Consumer_ID, Age, and 
-- the Name of any Mexican restaurant they have rated with an Overall_Rating of 2.


WITH san_luis_consumers AS (
    SELECT
        consumer_id,
        age
    FROM consumers
    WHERE city = 'San Luis Potosi'
)
SELECT DISTINCT c.consumer_id, c.age,r.name
FROM san_luis_consumers AS c
INNER JOIN ratings AS ra
    ON c.consumer_id = ra.consumer_id
INNER JOIN restaurants AS r
    ON ra.restaurant_id = r.restaurant_id
INNER JOIN restaurant_cuisines AS rc
    ON r.restaurant_id = rc.restaurant_id
WHERE rc.cuisine = 'Mexican' AND ra.overall_rating = 2;


-- 2. For each Occupation, find the average age of consumers. Only consider consumers who have made at least one rating. 
-- (Use a derived table to get consumers who have rated).

UPDATE consumers
SET occupation = 'Unknown'
WHERE occupation ='';

SELECT 
    c.occupation, round(AVG(c.age)) AS avg_consumer_age
FROM
    (SELECT DISTINCT
        consumer_id
    FROM
        ratings) AS ac
        INNER JOIN
    consumers AS c ON ac.consumer_id = c.consumer_id
GROUP BY c.occupation;



SELECT
    COALESCE(c.occupation, 'Unknown') AS occupation,
    AVG(c.age) AS avg_consumer_age
FROM (
    SELECT DISTINCT consumer_id
    FROM ratings
) ac
JOIN consumers c
    ON ac.consumer_id = c.consumer_id
GROUP BY COALESCE(c.occupation, 'Unknown');



select *  from consumers where occupation is not null;


desc consumers;

select * from consumers where occupation = '';



-- 3 Using a CTE to get all ratings for restaurants in 'Cuernavaca', rank these ratings within each restaurant based on Overall_Rating (highest first). 
-- Display Restaurant_ID, Consumer_ID, Overall_Rating, and the RatingRank.

WITH cuernavaca_ratings AS (
    SELECT ra.restaurant_id,
           ra.consumer_id,
           ra.overall_rating
    FROM restaurants r
    JOIN ratings ra
      ON r.restaurant_id = ra.restaurant_id
    WHERE r.city = 'Cuernavaca'
)

SELECT restaurant_id,
       consumer_id,
       overall_rating,
       RANK() OVER (
           PARTITION BY restaurant_id
           ORDER BY overall_rating DESC
       ) AS RatingRank
FROM cuernavaca_ratings;


-- 4.For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating, and also display the average Overall_Rating given by that specific consumer across all their ratings.

SELECT
    consumer_id,
    restaurant_id,
    overall_rating,
    AVG(overall_rating) OVER (
        PARTITION BY consumer_id
    ) AS avg_consumer_rating
FROM ratings;

-- 5. Using a CTE, identify students who have a 'Low' budget. Then, for each of these students,
--  list their top 3 most preferred cuisines based on the order they appear in the Consumer_Preferences table 
-- (assuming no explicit preference order, use Consumer_ID, Preferred_Cuisine to define order for ROW_NUMBER).

WITH low_budget_students AS (
    SELECT consumer_id
    FROM consumers
    WHERE occupation = 'Student'
      AND budget = 'Low'
)

SELECT consumer_id,
       preffered_cuisine
FROM (
    SELECT cp.consumer_id,
           cp.PREFFERED_CUISINE,
           ROW_NUMBER() OVER (
               PARTITION BY cp.consumer_id
               ORDER BY cp.PREFFERED_CUISINE
           ) AS rn
    FROM consumer_preferences cp
    JOIN low_budget_students lbs
      ON cp.consumer_id = lbs.consumer_id
) ranked
WHERE rn <= 3;

-- 6. Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the Restaurant_ID, Overall_Rating, 
-- and the Overall_Rating of the next restaurant they rated (if any), ordered by Restaurant_ID 
 -- (as a proxy for time if rating time isn't available). Use a derived table to filter for the consumer's ratings first.
 
 SELECT
    dt.restaurant_id,
    dt.overall_rating,
    LEAD(dt.overall_rating) OVER (
        ORDER BY dt.restaurant_id
    ) AS next_overall_rating
FROM (
    SELECT restaurant_id, overall_rating
    FROM ratings
    WHERE consumer_id = 'U1008'
) AS dt;


-- 7. Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, Name,
--  and City of all Mexican restaurants that have an average Overall_Rating greater than 1.5.
 CREATE VIEW HighlyRatedMexicanRestaurant AS
SELECT
    r.restaurant_id,
    r.name,
    r.city
FROM restaurants r
JOIN restaurant_cuisines rc
  ON r.restaurant_id = rc.restaurant_id
JOIN ratings ra
  ON r.restaurant_id = ra.restaurant_id
WHERE rc.cuisine = 'Mexican'
GROUP BY r.restaurant_id, r.name, r.city
HAVING AVG(ra.overall_rating) > 1.5;



SELECT * FROM HighlyRatedMexicanRestaurant;

-- 8. First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. Then, using a CTE to find consumers who prefer 'Mexican' cuisine,
--  list those consumers (Consumer_ID) who have not rated any restaurant listed in the HighlyRatedMexicanRestaurants view.

WITH mexican_pref_consumers AS (
    SELECT DISTINCT consumer_id
    FROM consumer_preferences
    WHERE preffered_cuisine = 'Mexican'
)

SELECT m.consumer_id
FROM mexican_pref_consumers m
WHERE NOT EXISTS (
    SELECT 1
    FROM ratings ra
    JOIN HighlyRatedMexicanRestaurants v
      ON ra.restaurant_id = v.restaurant_id
    WHERE ra.consumer_id = m.consumer_id
);

-- 9. Create a stored procedure GetRestaurantRatingsAboveThreshold that accepts a Restaurant_ID and a minimum Overall_Rating as input. 
-- It should return the Consumer_ID, Overall_Rating, Food_Rating, and Service_Rating for that restaurant where the Overall_Rating meets or exceeds the threshold.


DELIMITER $$

CREATE PROCEDURE GetRestaurantRatingsAboveThreshold (
    IN p_restaurant_id VARCHAR(10),
    IN p_min_rating INT
)
BEGIN
    SELECT
        consumer_id,
        overall_rating,
        food_rating,
        service_rating
    FROM ratings
    WHERE restaurant_id = p_restaurant_id
      AND overall_rating >= p_min_rating;
END $$


DELIMITER ;

CALL GetRestaurantRatingsAboveThreshold(132825, 2);

select * from ratings;


-- 10. Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type. If there are ties in rating, include all tied restaurants. 
-- Display Cuisine, Restaurant_Name, City, and Overall_Rating.

SELECT
    cuisine,
    name AS restaurant_name,
    city,
    overall_rating
FROM (
    SELECT rc.cuisine,r.name,r.city,ra.overall_rating,
        RANK() OVER (PARTITION BY rc.cuisine ORDER BY ra.overall_rating DESC) AS rnk
    FROM restaurants r
    JOIN restaurant_cuisines rc
        ON r.restaurant_id = rc.restaurant_id
    JOIN ratings ra
        ON r.restaurant_id = ra.restaurant_id
) ranked
WHERE rnk <= 2;

-- 11. First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their average Overall_Rating. Then, using this view and a CTE, 
-- find the top 5 consumers by their average overall rating. For these top 5 consumers, list their Consumer_ID, their 
-- average rating, and the number of 'Mexican'  restaurants they have rated.


CREATE VIEW ConsumerAverageRatings AS
SELECT
    consumer_id,
    AVG(overall_rating) AS avg_rating
FROM ratings
GROUP BY consumer_id;
WITH top5 AS (
    SELECT
        consumer_id,
        avg_rating
    FROM ConsumerAverageRatings
    ORDER BY avg_rating DESC
    LIMIT 5
)

SELECT
    t.consumer_id,
    t.avg_rating,
    COUNT(*) AS mexican_restaurants_rated
FROM top5 t
JOIN ratings ra
  ON t.consumer_id = ra.consumer_id
JOIN restaurant_cuisines rc
  ON ra.restaurant_id = rc.restaurant_id
WHERE rc.cuisine = 'Mexican'
GROUP BY t.consumer_id, t.avg_rating;


-- 12. Create a stored procedure named GetConsumerSegmentAndRestaurantPerformance that accepts a Consumer_ID as input.
-- The procedure should:
-- Determine the consumer's "Spending Segment" based on their Budget:
-- 'Low' -> 'Budget Conscious'
-- 'Medium' -> 'Moderate Spender'
-- 'High' -> 'Premium Spender'
-- NULL or other -> 'Unknown Budget'

-- For all restaurants rated by this consumer:
-- List the Restaurant_Name.
-- The Overall_Rating given by this consumer.
-- The average Overall_Rating this restaurant has received from all consumers (not just the input consumer).
-- A "Performance_Flag" indicating if the input consumer's rating for that restaurant is 'Above Average', 'At Average', or 'Below Average' compared to the restaurant's overall average rating.
-- Rank these restaurants for the input consumer based on the Overall_Rating they gave (highest rating = rank 1).



DELIMITER $$
CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance (IN p_consumer_id VARCHAR(10))
BEGIN
    SELECT
        r.name AS restaurant_name,ra.overall_rating,
        -- consumer segment
        CASE
            WHEN c.budget = 'Low' THEN 'Budget Conscious'
            WHEN c.budget = 'Medium' THEN 'Moderate Spender'
            WHEN c.budget = 'High' THEN 'Premium Spender'
            ELSE 'Unknown Budget'
        END AS spending_segment,avg_r.avg_restaurant_rating,
        -- performance flag
        CASE
            WHEN ra.overall_rating > avg_r.avg_restaurant_rating THEN 'Above Average'
            WHEN ra.overall_rating = avg_r.avg_restaurant_rating THEN 'At Average'
            ELSE 'Below Average'
        END AS performance_flag,
        -- ranking per consumer
        RANK() OVER (ORDER BY ra.overall_rating DESC) AS rating_rank
    FROM consumers c
    JOIN ratings ra
        ON c.consumer_id = ra.consumer_id
    JOIN restaurants r
        ON ra.restaurant_id = r.restaurant_id
    -- average rating per restaurant (all consumers)
    JOIN (
        SELECT restaurant_id,
               AVG(overall_rating) AS avg_restaurant_rating
        FROM ratings
        GROUP BY restaurant_id) avg_r
        ON ra.restaurant_id = avg_r.restaurant_id
    WHERE c.consumer_id = p_consumer_id;
END $$
DELIMITER ;
CALL GetConsumerSegmentAndRestaurantPerformance('U1008');
