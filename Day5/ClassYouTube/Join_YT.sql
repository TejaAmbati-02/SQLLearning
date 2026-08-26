USE namastesql;

CREATE TABLE t1(id1 INT);

CREATE TABLE t2(id2 INT);


INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (2);
INSERT INTO t1 VALUES (2);
INSERT INTO t1 VALUES (4);
INSERT INTO t1 VALUES (null);

INSERT INTO t2 VALUES (1);
INSERT INTO t2 VALUES (1);
INSERT INTO t2 VALUES (1);
INSERT INTO t2 VALUES (3);
INSERT INTO t2 VALUES (2);
INSERT INTO t2 VALUES (null);


SELECT * FROM t1;
SELECT * FROM t2;


-- inner join
SELECT
    *
FROM
    t1
INNER JOIN
    t2
ON
    t1.id1 = t2.id2;


-- left outer join
SELECT
    *
FROM
    t1
LEFT JOIN
    t2
ON
    t1.id1 = t2.id2;


-- right outer join
SELECT
    *
FROM
    t1
RIGHT OUTER JOIN
    t2
ON
    t1.id1 = t2.id2;



-- full outer join
SELECT
    *
FROM
    t1
FULL OUTER JOIN
    t2
ON
    t1.id1 = t2.id2;



create table products (
    id int,
    name varchar(10)
);
insert into
    products
VALUES
    (1, 'A'),
    (2, 'B'),
    (3, 'C'),
    (4, 'D'),
    (5, 'E');



create table colors (
    color_id int,
    color varchar(50)
);


insert into
    colors
values
    (1,'Blue'),
    (2,'Green'),
    (3,'Orange');

create table sizes(
    size_id int,
    size varchar(10)
);

insert into
    sizes
values
    (1,'M'),
    (2,'L'),
    (3,'XL');

create table transactions(
    order_id int,
    product_name varchar(20),
    color varchar(10),
    size varchar(10),
    amount int
);

insert into
    transactions
values
    (1,'A','Blue','L',300),
    (2,'B','Blue','XL',150),
    (3,'B','Green','L',250),
    (4,'C','Blue','L',250),
    (5,'E','Green','L',270),
    (6,'D','Orange','L',200),
    (7,'D','Green','M',250);


SELECT * FROM colors;

SELECT * FROM sizes;

SELECT * FROM transactions;

-- UsecCase 1: prepare master data
SELECT * FROM products, colors;

SELECT * FROM products, transactions;

SELECT * FROM products, colors,sizes, transactions;


SELECT product_name, color, size, SUM(amount) AS total_amount
FROM transactions
GROUP BY product_name, color, size;

WITH master_data AS (
SELECT
    p.name AS product_name, c.color, s.size
FROM products p, colors c,sizes s),
sales AS (
    SELECT product_name,
           color,
           size,
           SUM(amount) AS total_amount
    FROM transactions
    GROUP BY product_name, color, size
)
SELECT m.product_name, m.color, m.size, ISNULL(s.total_amount, 0) AS total_amount
FROM master_data m LEFT JOIN sales s
ON m.product_name = s.product_name
AND m.size = s.size
AND m.color = s.color
ORDER BY total_amount DESC;

-- UsecCase 2: prepare large number of rows for performance testing

SELECT
    ROW_NUMBER() over (ORDER BY o.order_id) AS order_id,
    t.product_name,
    t.color,
    CASE WHEN ROW_NUMBER() over (ORDER BY o.order_id)%3 = 0 THEN 'L' ELSE 'XL' END AS size,
    t.amount
FROM
    transactions t, orders o, transactions t1;



SELECT * INTO transactions_test FROM transactions WHERE 1=2;

SELECT * FROM transactions_test;

INSERT INTO transactions_test
SELECT
    ROW_NUMBER() over (ORDER BY o.order_id) AS order_id,
    t.product_name,
    t.color,
    CASE WHEN ROW_NUMBER() over (ORDER BY o.order_id)%3 = 0 THEN 'L' ELSE 'XL' END AS size,
    t.amount
FROM
    transactions t, orders o, transactions t1;

SELECT * FROM transactions_test;


-- 1. FROM
--     ↓
-- 2. JOIN
--     ↓
-- 3. ON
--     ↓
-- 4. WHERE
--     ↓
-- 5. GROUP BY
--     ↓
-- 6. HAVING
--     ↓
-- 7. SELECT
--     ↓
-- 8. DISTINCT
--     ↓
-- 9. ORDER BY
--     ↓
-- 10. LIMIT / OFFSET
