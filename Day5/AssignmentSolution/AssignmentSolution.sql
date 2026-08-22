-- Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.

-- 1- write a query to get region wise count of return orders

SELECT region, COUNT(DISTINCT r.order_id) AS count_of_return_orders
FROM namastesql.dbo.orders o
LEFT JOIN namastesql.dbo.returns r
ON o.order_id = r.order_id
WHERE r.order_id IS NOT NULL
GROUP BY o.region;

-- 2- write a query to get category wise sales of orders that were not returned

SELECT o.category, SUM(o.sales) AS total_sales
FROM namastesql.dbo.orders o
LEFT JOIN namastesql.dbo.returns r
ON o.order_id = r.order_id
WHERE r.order_id IS NULL
GROUP BY o.category;



-- 3- write a query to print dep name and average salary of employees in that dep .


create table namastesql.dbo.employee(
    emp_id int,
    emp_name varchar(20),
    dept_id int,
    salary int,
    manager_id int,
    emp_age int
);


insert into namastesql.dbo.employee values(1,'Ankit',100,10000,4,39);
insert into namastesql.dbo.employee values(2,'Mohit',100,15000,5,48);
insert into namastesql.dbo.employee values(3,'Vikas',100,10000,4,37);
insert into namastesql.dbo.employee values(4,'Rohit',100,5000,2,16);
insert into namastesql.dbo.employee values(5,'Mudit',200,12000,6,55);
insert into namastesql.dbo.employee values(6,'Agam',200,12000,2,14);
insert into namastesql.dbo.employee values(7,'Sanjay',200,9000,2,13);
insert into namastesql.dbo.employee values(8,'Ashish',200,5000,2,12);
insert into namastesql.dbo.employee values(9,'Mukesh',300,6000,6,51);
insert into namastesql.dbo.employee values(10,'Rakesh',500,7000,6,50);
select * from namastesql.dbo.employee;

create table namastesql.dbo.dept(
    dep_id int,
    dep_name varchar(20)
);
insert into namastesql.dbo.dept values(100,'Analytics');
insert into namastesql.dbo.dept values(200,'IT');
insert into namastesql.dbo.dept values(300,'HR');
insert into namastesql.dbo.dept values(400,'Text Analytics');
select * from namastesql.dbo.dept;




SELECT * FROM namastesql.dbo.employee;

SELECT * FROM namastesql.dbo.dept;


SELECT
    *
FROM
    namastesql.dbo.employee e
LEFT JOIN
    namastesql.dbo.dept d
ON e.dept_id = d.dep_id;


-- 4- write a query to print dep names where none of the employees have same salary.


SELECT
    d.dep_name
FROM
    namastesql.dbo.employee e
INNER JOIN
    namastesql.dbo.dept d
ON
    e.dept_id = d.dep_id
GROUP BY
    d.dep_name
HAVING COUNT(d.dep_id) = COUNT(DISTINCT d.dep_id)






-- 5- write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)

SELECT
    sub_category
FROM
    namastesql.dbo.orders AS o
LEFT JOIN
    namastesql.dbo.returns AS r
ON
    o.order_id = r.order_id
WHERE
    r.order_id IS NOT NULL
GROUP BY
    o.sub_category
HAVING
    COUNT(DISTINCT r.return_reason) = 3;



-- 6- write a query to find cities where not even a single order was returned.

SELECT
    o.city
FROM
    namastesql.dbo.orders o
LEFT JOIN
    namastesql.dbo.returns r
ON
    o.order_id = r.order_id
GROUP BY
    o.city
HAVING
    COUNT(r.order_id) = 0;


-- 7- write a query to find top 3 subcategories by sales of returned orders in east region



SELECT TOP 3
    o.sub_category, SUM(o.sales) AS sum_of_sales
FROM
    namastesql.dbo.orders o
INNER JOIN
    namastesql.dbo.returns r
ON
    o.order_id = r.order_id
WHERE region = 'East'
GROUP BY o.sub_category
ORDER BY sum_of_sales DESC;


-- 8- write a query to print dep name for which there is no employee


SELECT
    d.dep_name
FROM
    namastesql.dbo.employee e
RIGHT JOIN
    namastesql.dbo.dept d
ON
    e.dept_id = d.dep_id
WHERE
    e.emp_id IS NULL;


SELECT d.dep_name
FROM
    namastesql.dbo.dept d
LEFT JOIN
    namastesql.dbo.employee e
ON
    d.dep_id = e.dept_id
GROUP BY d.dep_name
HAVING COUNT(e.emp_id) = 0;

-- 9- write a query to print employees name for dep id is not avaiable in dept table



SELECT
    e.emp_name
FROM
    namastesql.dbo.employee e
LEFT JOIN
    namastesql.dbo.dept d
ON
    e.dept_id = d.dep_id
WHERE d.dep_id IS NULL;



select e.*
FROM
    namastesql.dbo.employee e
LEFT JOIN
    namastesql.dbo.dept d  on e.dept_id=d.dep_id
where d.dep_id is null;
