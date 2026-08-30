-- 1 - 38 - Product Reviews
-- Question
-- Suppose you are a data analyst working for a retail company, and your team is interested in analysing customer feedback to identify trends and patterns in product reviews.
--
-- Your task is to write an SQL query to find all product reviews containing the word "excellent" or "amazing" in the review text. However, you want to exclude reviews that contain the word "not" immediately before "excellent" or "amazing". Please note that the words can be in upper or lower case or combination of both.
--
-- Your query should return the review_id,product_id, and review_text for each review meeting the criteria, display the output in ascending order of review_id.
--
--
--
-- Table: product_reviews
-- +-------------+--------------+
-- | COLUMN_NAME | DATA_TYPE    |
-- +-------------+--------------+
-- | review_id   | int          |
-- | product_id  | int          |
-- | review_text | varchar(40)  |
-- +-------------+--------------+


SELECT review_id, product_id, review_text
FROM product_reviews
WHERE review_text REGEXP '(?i)\\b(excellent|amazing)\\b'
  AND review_text NOT REGEXP '(?i)\\bnot[[:space:]]+(excellent|amazing)\\b'
ORDER BY review_id ASC;



-- 2- 61 - Category Sales (Part 1)
-- Question
-- Write an SQL query to retrieve the total sales amount for each product category in the month of February 2022, only including sales made on weekdays (Monday to Friday). Display the output in ascending order of total sales.
--
--
--
--
-- Tables: sales
-- +-------------+-------------+
-- | COLUMN_NAME | DATA_TYPE   |
-- +-------------+-------------+
-- | id          | int         |
-- | product_id  | int         |
-- | category    | varchar(12) |
-- | amount      | int         |
-- | order_date  | date        |
-- +-------------+-------------+



-- MySQL
SELECT
    category,
    SUM(amount) AS total_sales
FROM sales
WHERE order_date BETWEEN '2022-02-01' AND '2022-02-28'
  AND WEEKDAY(order_date) BETWEEN 0 AND 4
GROUP BY category
ORDER BY total_sales ASC;


-- SQL Server

SELECT
    category,
    SUM(
        CASE
            WHEN order_date BETWEEN '2022-02-01' AND '2022-02-28'
             AND DATEPART(WEEKDAY, order_date) BETWEEN 2 AND 6
            THEN amount
            ELSE 0
        END
    ) AS total_sales
FROM sales
GROUP BY category
ORDER BY total_sales ASC;




-- 3 - 62 - Category Sales (Part 2)
-- Question
-- Write an SQL query to retrieve the total sales amount in each category. Include all categories, if no products were sold in a category display as 0. Display the output in ascending order of total_sales.
--
-- Tables: sales
-- +-------------+-----------+
-- | COLUMN_NAME | DATA_TYPE |
-- +-------------+-----------+
-- | amount      | int       |
-- | category_id | int       |
-- | sale_date   | date      |
-- | sale_id     | int       |
-- +-------------+-----------+
-- 
-- Tables: Categories
-- +---------------+-------------+
-- | COLUMN_NAME   | DATA_TYPE   |
-- +---------------+-------------+
-- | category_id   | int         |
-- | category_name | varchar(12) |
-- +---------------+-------------+


select category_name,
       COALESCE(SUM(amount), 0) AS total_sales -- category_name, SUM(amount) AS total_sales
from
    categories c
LEFT JOIN
        sales s
ON
    c.category_id = s.category_id
GROUP BY
    category_name
ORDER BY
    total_sales ASC;





-- 4- 71 - Department Average Salary
--
-- You are provided with two tables: Employees and Departments. The Employees table contains information about employees, including their IDs, names, salaries, and department IDs. The Departments table contains information about departments, including their IDs and names. Your task is to write a SQL query to find the average salary of employees in each department, but only include departments that have more than 2 employees . Display department name and average salary round to 2 decimal places. Sort the result by average salary in descending order.

-- Tables: Employees
-- +---------------+-------------+
-- | COLUMN_NAME   | DATA_TYPE   |
-- +---------------+-------------+
-- | employee_id   | int         |
-- | employee_name | varchar(20) |
-- | salary        | int         |
-- | department_id | int         |
-- +---------------+-------------+

-- Tables: Departments
-- +-----------------+-------------+
-- | COLUMN_NAME     | DATA_TYPE   |
-- +-----------------+-------------+
-- | department_id   | int         |
-- | department_name | varchar(10) |
-- +-----------------+-------------+



-- select * from employees;
-- select * from departments;


select d.department_name, ROUND(AVG(e.salary), 2) AS average_salary
from employees e LEFT JOIN departments d
ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(1) >= 2
ORDER BY average_salary DESC;


-- 5 - 72 - Product Sales
--
-- You are provided with two tables: Products and Sales. The Products table contains information about various products, including their IDs, names, and prices. The Sales table contains data about sales transactions, including the product IDs, quantities sold, and dates of sale. Your task is to write a SQL query to find the total sales amount for each product. Display product name and total sales . Sort the result by product name.
--
--
--
-- Table: products
-- +--------------+-------------+
-- | COLUMN_NAME  | DATA_TYPE   |
-- +--------------+-------------+
-- | product_id   | int         |
-- | product_name | varchar(10) |
-- | price        | int         |
-- +--------------+-------------+


-- Table: sales
-- +-------------+-----------+
-- | COLUMN_NAME | DATA_TYPE |
-- +-------------+-----------+
-- | sale_id     | int       |
-- | product_id  | int       |
-- | quantity    | int       |
-- | sale_date   | date      |
-- +-------------+-----------+

-- select * from products;
-- select * from sales;


select p.product_name, SUM(p.price *s.quantity) AS total_sales_amount
from products p LEFT JOIN sales s
ON p.product_id = s.product_id
GROUP BY p.product_name
ORDER BY p.product_name;





-- 73 - Category Product Count
--
-- You are provided with a table that lists various product categories, each containing a comma-separated list of products. Your task is to write a SQL query to count the number of products in each category. Sort the result by product count & category in ASC order
--
--
--
-- Tables: categories
-- +-------------+-------------+
-- | COLUMN_NAME | DATA_TYPE   |
-- +-------------+-------------+
-- | category    | varchar(50) |
-- | products    | varchar(75) |
-- +-------------+-------------+


select category,
length(products) - length(replace(products,',',''))+1 as product_count
from categories
group by category,product_count
order by product_count,category;



-- 7 - 103 - Employee Mentor
-- Question
-- Your Submissions
-- Solution
-- Discussion
-- User Submissions
-- Category - Analytics
-- Easy - 10 Points
-- You are given a table Employees that contains information about employees in a company. Each employee might have been mentored by another employee. Your task is to find the names of all employees who were not mentored by the employee with id = 3.
--
-- Table: employees
-- +-------------+-------------+
-- | COLUMN_NAME | DATA_TYPE   |
-- +-------------+-------------+
-- | id          | int         |
-- | name        | varchar(10) |
-- | mentor_id   | int         |
-- +-------------+-------------+


select name
from employees
WHERE mentor_id <> 3 OR mentor_id IS NULL;