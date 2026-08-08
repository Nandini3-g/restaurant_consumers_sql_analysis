# restaurant_consumers_sql_analysis
Project Overview

This project analyzes restaurant consumer data using SQL to explore consumer demographics, preferences, restaurant characteristics, cuisines, and customer ratings.

The project covers a range of SQL techniques, from basic filtering and aggregation to advanced concepts such as CTEs, derived tables, window functions, views, and stored procedures.

Project Objectives
- Analyze consumer demographics and behavior
- Explore consumer cuisine preferences
- Analyze restaurant characteristics and cuisines
- Examine consumer ratings and restaurant performance
- Identify patterns between consumer preferences and restaurant ratings
- Practice advanced SQL techniques for data analysis
🗂️ Database Structure

The project uses the following tables:

Consumers — Consumer demographic and personal information
Consumer_Preferences — Preferred cuisines for each consumer
Restaurants — Restaurant information and characteristics
Restaurant_Cuisines — Cuisines offered by each restaurant
Ratings — Consumer ratings for restaurants
SQL Concepts Used:
Basic SQL
SELECT
WHERE
ORDER BY
DISTINCT
Filtering
Aggregate functions
Intermediate SQL
GROUP BY
HAVING
INNER JOIN
LEFT JOIN
Subqueries
Multiple-table joins
Conditional logic using CASE
Advanced SQL
Common Table Expressions (CTEs)
Derived tables
Window functions
RANK()
ROW_NUMBER()
LEAD()
Aggregate window functions
Views
Stored procedures
COALESCE
NOT EXISTS
 Analysis Performed

The project includes queries for:

Finding consumers based on city, occupation, smoking habits, age, and budget
Analyzing restaurants based on location, price, alcohol service, and franchise status
Identifying highly rated restaurants
Finding consumers who rated restaurants in specific cities
Analyzing Mexican, Italian, American, and Pizzeria preferences
Comparing food ratings with average restaurant ratings
Finding consumers based on their restaurant-rating behavior
Analyzing student consumers and restaurant engagement
Calculating average consumer ages by occupation
Ranking restaurant ratings within cities
Calculating average ratings for individual consumers
Finding top preferred cuisines for low-budget students
Comparing a consumer's rating with a restaurant's average rating
Ranking top-rated restaurants by cuisine
Identifying top consumers based on average ratings
👁️ Advanced SQL Features
CTEs

Used CTEs to simplify multi-step analysis, including consumer filtering and restaurant-rating analysis.

Window Functions

Used:

RANK()
ROW_NUMBER()
LEAD()
AVG() OVER()

for ranking restaurants, finding top preferences, comparing ratings, and analyzing consumer rating behavior.

Views

Created views such as:

HighlyRatedMexicanRestaurant
ConsumerAverageRatings1

to simplify reusable analysis.

Stored Procedures

Created stored procedures to:

Retrieve restaurant ratings above a specified threshold
Analyze consumer spending segments and restaurant performance

Example Business Questions

Some of the questions explored in this project include:

Which restaurants have highly satisfactory ratings?
Which consumers prefer Mexican cuisine?
Which restaurants have ratings below the overall average?
Which consumers have rated restaurants but never rated an Italian restaurant?
Which restaurants are popular among consumers over 30?
Which students have rated more than two restaurants?
What is the average consumer age by occupation?
Which restaurants have the highest ratings within each cuisine?
Which consumers have the highest average ratings?
How does an individual consumer's rating compare with a restaurant's overall performance?
