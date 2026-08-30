-- Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.
-- Run below table script to create icc_world_cup table:
USE namastesql;
create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

-- 1- write a query to produce below output from icc_world_cup table.
-- team_name, no_of_matches_played , no_of_wins , no_of_losses


WITH winner_CTE AS (SELECT Team_1 AS Team, CASE WHEN Team_1 = Winner THEN Team_1 ELSE NULL END AS winner_team FROM namastesql.dbo.icc_world_cup
UNION ALL
SELECT Team_2 AS Team,CASE WHEN Team_2 = Winner THEN Team_1 ELSE NULL END AS winner_team FROM namastesql.dbo.icc_world_cup
)
SELECT Team,
       COUNT(Team) AS no_of_matches_played,
       COUNT(winner_team) AS no_of_wins,
       COUNT(Team) - COUNT(winner_team) AS no_of_losses
FROM winner_CTE
GROUP BY Team;




-- 2- write a query to print first name and last name of a customer using orders table(everything after first space can be considered as last name)
-- customer_name, first_name,last_name


SELECT
    customer_id,
    customer_name,
    TRIM(SUBSTRING(customer_name, 1, charindex(' ', customer_name))) AS first_name,
    TRIM(SUBSTRING(customer_name,CHARINDEX(' ', customer_name)+1, len(customer_name) - CHARINDEX(' ', customer_name)+1)) AS second_name
FROM
    namastesql.dbo.orders;


-- Run below script to create drivers table:
--
create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),
                          ('dri_1', '09:30', '10:30', 'b','c'),
                          ('dri_1','11:00','11:30', 'd','e');

insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),
                          ('dri_1', '13:30', '14:30', 'c','h');

insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),
                          ('dri_2', '13:30', '14:30', 'c','h');

SELECT * FROM drivers;
-- 3- write a query to print below output using drivers table. Profit rides are the no of rides where end location of a ride is same as start location of immediate next ride for a driver
-- id, total_rides , profit_rides
-- dri_1,5,1
-- dri_2,2,0




WITH rides_cte AS(SELECT *,
       LEAD(start_loc) OVER(PARTITION BY id ORDER BY start_time) AS next_start_ride
FROM
    drivers)
SELECT
    id,
    COUNT(1) AS total_rides,
    SUM(CASE WHEN end_loc = next_start_ride THEN 1 ELSE 0 END) AS profit_rides
FROM
    rides_cte
GROUP BY
    id;




WITH rides_combined_CTE AS(
SELECT *
     ,LEAD(start_loc, 1) OVER(PARTITION BY id ORDER BY start_time ASC) AS next_start_location
FROM
    drivers)
SELECT id,
       COUNT(1) AS toal_orders,
       SUM(CASE WHEN end_loc = next_start_location THEN 1 ELSE 0 END) AS profit_rides
FROM rides_combined_CTE
GROUP BY id;







WITH cte AS(
select *
, lead(start_loc,1) over(partition by id order by start_time asc) as next_start_location
from drivers)

select id, count(1) as total_rides
,sum(case when end_loc=next_start_location then 1 else 0 end ) as profit_rides
from cte
group by id;




-- 4- write a query to print customer name and no of occurence of character 'n' in the customer name.
-- customer_name , count_of_occurence_of_n

USE namastesql;


SELECT * FROM orders;

SELECT
    customer_name,
    len(customer_name) - len(replace(customer_name, 'n', '')) AS count_of_occurence_of_n
FROM namastesql.dbo.orders;



-- 5-write a query to print below output from orders data. example output
-- hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region
-- category , Technology, ,
-- category, Furniture, ,
-- category, Office Supplies, ,
-- sub_category, Art , ,
-- sub_category, Furnishings, ,
-- --and so on all the category ,subcategory and ship_mode hierarchies



(SELECT
    'category' AS hierarchy,
    category,
    ROUND(SUM(CASE WHEN region = 'West' THEN sales END), 2) AS total_sales_in_west_region,
    ROUND(SUM(CASE WHEN region = 'East' THEN sales END), 2) AS total_sales_in_east_region
FROM
    orders
GROUP BY category)

UNION ALL
(
    SELECT
        'Sub Category',
        sub_category,
        ROUND(SUM(CASE WHEN region = 'West' THEN sales END), 2) AS total_sales_in_west_region,
        ROUND(SUM(CASE WHEN region = 'East' THEN sales END), 2) AS total_sales_in_east_region
    FROM
        orders
    GROUP BY
        sub_category
);









-- 6- the first 2 characters of order_id represents the country of order placed . write a query to print total no of orders placed in each country
-- (an order can have 2 rows in the data when more than 1 item was purchased in the order but it should be considered as 1 order)


SELECT
    left(order_id,2) AS country,
    COUNT(DISTINCT order_id) AS total_orders
FROM
    orders
GROUP BY
    left(order_id, 2);