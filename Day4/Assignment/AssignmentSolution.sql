-- Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.
-- 1- write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909

UPDATE namastesql.dbo.orders SET city = null WHERE order_id in ( 'CA-2020-161389' , 'US-2021-156909');

-- 2- write a query to find orders where city is null (2 rows)

SELECT * FROM namastesql.dbo.orders WHERE city IS NULL;

-- 3- write a query to get total profit, first order date and latest order date for each category
SELECT
    category,
    SUM(profit) AS total_profit,
    min(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM namastesql.dbo.orders
GROUP BY category;



-- 4- write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category

SELECT
    sub_category
FROM
    namastesql.dbo.orders
GROUP BY
    sub_category
HAVING
    AVG(profit) > MAX(profit)/2;




-- 5- create the exams table with below script;
create table namastesql.dbo.exams (student_id int, subject varchar(20), marks int);

insert into namastesql.dbo.exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79);

SELECT * FROM namastesql.dbo.exams;


-- write a query to find students who have got same marks in Physics and Chemistry.

SELECT
    student_id, marks
FROM
    namastesql.dbo.exams
GROUP BY student_id, marks
HAVING count(1) = 2;



-- 6- write a query to find total number of products in each category.

SELECT
    category,
    COUNT(DISTINCT product_id)
FROM
    namastesql.dbo.orders
GROUP BY
    category;




-- 7- write a query to find top 5 sub categories in west region by total quantity sold

SELECT
    TOP 5 sub_category, sum(quantity) AS total_quantity
FROM
    namastesql.dbo.orders
WHERE
    region = 'West'
GROUP BY
    sub_category
ORDER BY
    total_quantity DESC;



-- 8- write a query to find total sales for each region and ship mode combination for orders in year 2020

SELECT * FROM namastesql.dbo.orders;

SELECT region, ship_mode, SUM(sales) AS total_sales
FROM namastesql.dbo.orders
WHERE order_date BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY region, ship_mode;
