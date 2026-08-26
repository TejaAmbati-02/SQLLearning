-- Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.
--
-- Run the following command to add and update dob column in employee table
USE
    namastesql;



alter table
    namastesql.dbo.employee
add
    dob date;



update
    namastesql.dbo.employee
set
    dob = dateadd(year,-1*emp_age,getdate());



-- 1- write a query to print emp name , their manager name and diffrence in their age (in days)
-- for employees whose year of birth is before their managers year of birth
SELECT
    employee1.emp_name,
    employee2.emp_name AS amnager_name,
    DATEDIFF(DAY ,employee1.dob, employee2.dob) AS difference_of_dob
FROM
    namastesql.dbo.employee employee1
INNER JOIN
    namastesql.dbo.employee employee2
ON
    employee1.manager_id = employee2.emp_id
WHERE
    DATEPART(YEAR, employee1.dob) < DATEPART(YEAR, employee2.dob);



-- 2- write a query to find subcategories who never had any return orders in the month of november (irrespective of years)

SELECT
    o.sub_category
FROM
    namastesql.dbo.orders o
LEFT JOIN
    namastesql.dbo.returns r
ON
    o.order_id = r.order_id
WHERE
    DATEPART( MONTH , o.order_date) = 11
GROUP BY
    o.sub_category
HAVING
    COUNT(r.order_id) = 0;


-- 3- orders table can have multiple rows for a particular order_id when customers buys more than 1 product in an order.
-- write a query to find order ids where there is only 1 product bought by the customer.


SELECT
    o.order_id
FROM
    namastesql.dbo.orders o
LEFT JOIN
    namastesql.dbo.returns r
ON
    o.order_id = r.order_id
GROUP BY o.order_id
HAVING COUNT(product_id) = 1;


SELECT
    o.order_id
FROM
    namastesql.dbo.orders o
LEFT JOIN
    namastesql.dbo.returns r
ON
    o.order_id = r.order_id
GROUP BY o.order_id
HAVING COUNT(1) = 1;




-- 4- write a query to print manager names along with the comma separated list(order by emp salary) of all employees directly reporting to him.


SELECT
    manager_id AS manager,
    STRING_AGG(employee1.emp_id, ',') AS repotee_id_list,
    STRING_AGG(employee1.emp_name, ',') AS _name_list
FROM
    namastesql.dbo.employee employee1
GROUP BY
    manager_id;

-- 5- write a query to get number of business days between order_date and ship_date (exclude weekends).
-- Assume that all order date and ship date are on weekdays only

SELECT order_id, order_date, ship_date, DATEDIFF(DAY, order_date, ship_date)-2*DATEDIFF(week,order_date, ship_date) AS no_of_business_days
FROM namastesql.dbo.orders;











-- 6- write a query to print 3 columns : category, total_sales and (total sales of returned orders)


SELECT
    o.category,
    SUM(o.sales) AS total_orders,
    SUM(CASE WHEN r.order_id IS NOT NULL THEN o.sales ELSE 0 END) AS returned_orders

FROM
    namastesql.dbo.orders o
LEFT JOIN
    namastesql.dbo.returns r
ON
    o.order_id = r.order_id
GROUP BY
    o.category;



-- 7- write a query to print below 3 columns
-- category, total_sales_2019(sales in year 2019), total_sales_2020(sales in year 2020)


SELECT
    o.category,
    SUM(CASE WHEN DATEPART(YEAR , o.order_date) = 2019 THEN o.sales END) AS total_sales_2019,
    SUM(CASE WHEN DATEPART(YEAR , o.order_date) = 2020 THEN o.sales END) AS total_sales_2020
FROM
    namastesql.dbo.orders o
GROUP BY
    o.category;

-- 8- write a query print top 5 cities in west region by average no of days between order date and ship date.

SELECT TOP 5
    city, AVG(DATEDIFF(day, order_date, ship_date)) AS avg_days_of_shipping
FROM
    namastesql.dbo.orders
WHERE
    region = 'West'
GROUP BY
    city
ORDER BY
    avg_days_of_shipping DESC;




-- 9- write a query to print emp name, manager name and senior manager name (senior manager is manager's manager)

SELECT
    e1.emp_name,
    e2.emp_name AS manager,
    e3.emp_name AS senior_manager
FROM
    namastesql.dbo.employee  AS e1
INNER JOIN
    namastesql.dbo.employee AS e2
ON
    e1.manager_id = e2.emp_id
INNER JOIN
        namastesql.dbo.employee AS e3
ON
    e2.manager_id = e3.emp_id;

