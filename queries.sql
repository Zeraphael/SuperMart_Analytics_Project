-- ==================================================
-- SECTION A: FUNDAMENTALS
-- ==================================================
-- a
select first_name, 
		last_name, 
        email 
from customers
where city = 'Lagos'
order by last_name, first_name;

-- b
SELECT DISTINCT shipping_city
FROM orders
ORDER BY shipping_city;
-- c
select product_name, 
		category_id, 
        unit_price
 from products
 order by unit_price desc
 limit 10;
 -- d
 select concat(first_name, ' ', last_name) as full_name, 
		role, 
        hire_date, 
        salary 
 from employees
 where hire_date >= '2021-01-01'
 order by hire_date;
 -- e
 select order_id,
		order_date, 
        status, 
        shipping_city
 from orders
 where month(order_date) = 12
 order by order_date desc;
 
 -- ==================================================
 -- SECTION B: AGGREGATE FUNCTIONS
 -- ==================================================
 -- a
 select status,
		count(*) as count, 
        round(count(*) / 500 * 100, 2) as pct_of_total 
 from orders
 group by status
 order by count desc;
 -- b
 select category_name, 
		min(unit_price) as min_price, max(unit_price) as max_price, 
        round(avg(unit_price), 2) as average_price
 from categories 
 join products 
 using(category_id)
 group by category_name
 order by average_price desc;
 -- c
 select round(sum(revenue), 2) as total_revenue, 
		round(min(revenue),2) as minimun_revenue, 
        round(max(revenue),2) as maximum_revenue, 
        round(avg(revenue),2) as average_revenue from (
 select 
	quantity * (unit_price -  discount) as revenue
 from order_items
 ) as revenue_table;
 -- d
 select count(distinct customer_id) as total_customers_with_orders,
		round(avg(order_count), 2) as avg_orders_per_customers
 from (
 select customer_id,
		count(order_id) as order_count
 from orders
 group by customer_id
 ) as ordered_customers_table;
  -- =========================================================
 -- SECTION C: GROUPING
 -- a 
 select year(registration_date) as registration_year,
 count(customer_id) as number_of_customers
 from customers 
 where year(registration_date) > 2017 and year(registration_date) < 2025
 group by year(registration_date)
 order by year(registration_date);
 -- b
 select shipping_city, delivered_orders  
from ( 
 select shipping_city,
		count(order_id) as delivered_orders 
 from orders
 where status = 'Delivered' 
  group by shipping_city
  ) AS shipping_city
where delivered_orders > 10
order by delivered_orders desc;
-- c 
select product_id, 
		product_name, 
        sum(quantity) as total_units_sold
from products
join order_items using(product_id)
group by product_id, product_name
having sum(quantity) > 50;
-- d 
select full_name, 
total_orders 
from (
select concat(e.first_name, ' ', e.last_name) as full_name,
		count(o.employee_id) as total_orders
from employees as e
join orders as o using(employee_id)
group by full_name) as employee_table
where total_orders >= 20 
order by total_orders desc;
-- e 
select extract( year from order_date) as year,
		count(order_id) as total_orders, 
        count(distinct(customer_id)) as ordered_customers
from orders
group by extract( year from order_date)
order by year desc;
-- =========================================================
-- SECTION D: LIKE AND ILIKE
-- a 
select first_name,
		last_name, 
        email
from customers
where email  like '%@gmail.com';
-- b 
SELECT product_name,
       category_id,
       unit_price
FROM products
WHERE product_name LIKE '%set%'
ORDER BY unit_price DESC;
-- c 
SELECT CONCAT(first_name,' ',last_name) AS full_name,
       city,
       registration_date
FROM customers
WHERE last_name LIKE 'ad%';
-- d 
SELECT product_name,
       category_id,
       unit_price
FROM products
WHERE product_name LIKE '%combo%'
   OR product_name LIKE '%kit%'
   OR product_name LIKE '%pack%';
   -- e 
   SELECT first_name,
       last_name,
       city
FROM customers
WHERE city LIKE '%an%'
ORDER BY city,
         last_name;

-- =========================================================
-- SECTION E: JOINS
-- a 
select order_id, 
		concat(c.first_name, ' ', c.last_name) as customer_name, 
		concat(e.first_name, ' ', e.last_name) as employee_name,
		order_date, 
        status, 
        shipping_city
from orders as o
inner join customers as c using(customer_id)
inner join employees as e
using(employee_id)
order by order_date desc limit 50;  
-- b 
select customer_id, 
		concat(first_name, ' ', last_name) as full_name, 
		city, 
		count(order_id) as order_count 
from customers
left join orders
using(customer_id)
group by customer_id
Order by order_count desc, last_name;
-- c 
select order_id, 
		order_date, 
        concat(first_name, ' ', last_name) as customer_full_name, 
        product_name, 
        quantity, 
        oi.unit_price, 
        discount,
        quantity * (oi.unit_price - discount) as line_revenue
from order_items as oi
join orders
using(order_id)
join customers
using(customer_id)
join products
using(product_id);
-- group by product_name;
-- d 
select  concat(first_name, ' ', last_name) as full_name, 
		role, 	
        region_name,
        count(order_id) as total_orders
from employees
join regions using(region_id)
left join orders using(employee_id)
group by first_name, last_name, role, region_name;
-- e 
select category_name, 
		product_name, 
        count(distinct(order_id)) as times_ordered, 
        sum(quantity) as total_qty_sold
from categories
left join products using(category_id)
left join  order_items using(product_id)
group by category_name, product_name
order by total_qty_sold;
-- =========================================================
-- SECTION F: Cases
-- a 
select product_name, 
category_name, unit_price,
case 
	when unit_price < 10000 then 'Budget'
	when unit_price between 10000 and 99999 then 'Mid-Range' 
	when unit_price >= 100000 then 'Premium'
end as price_tier
from products
join categories 
using(category_id)
order by unit_price desc;
-- b 
select concat(first_name, ' ', last_name) as full_name, role, salary,
case
when salary >= 100000 then 'Executive' 
when salary between 80000 and 99999 then 'Senior' 
when salary < 80000 then 'Entry Level' 
end as pay_band
from employees
order by salary desc;
-- c 
select o.order_id,
		o.order_date, 
        o.status, 
        round(oi.quantity * (oi.unit_price - oi.discount), 2) as total_order_value 
from orders as o
join order_items as oi 
on o.order_id = oi.order_id
group by o.order_id, o.order_date, o.status, total_order_value;
-- d 
SELECT
    c.category_name,

    COUNT(
        CASE
            WHEN p.unit_price < 10000
            THEN 1
        END
    ) AS budget_count,

    COUNT(
        CASE
            WHEN p.unit_price BETWEEN 10000 AND 99999
            THEN 1
        END
    ) AS mid_range_count,

    COUNT(
        CASE
            WHEN p.unit_price >= 100000
            THEN 1
        END
    ) AS premium_count

FROM categories c
LEFT JOIN products p
ON c.category_id = p.category_id

GROUP BY c.category_name
ORDER BY c.category_name;
-- =========================================================
-- SECTION G: SUBQUERIES
-- a
select  product_name, category_id, unit_price
from products 
where unit_price > (
select avg(unit_price) 
from products)
order by unit_price;
-- b 
select concat(first_name, ' ', last_name) as full_name, city
from customers
where customer_id in(
select customer_id
from orders);
-- c 
select product_id, product_name, 
category_id,  unit_price
from products
where product_id not in(
select product_id
from order_items);
-- d 
SELECT
    customer_name,
    city,
    ROUND(total_revenue,2) AS total_lifetime_revenue
FROM
(
    SELECT
        c.customer_id,
        CONCAT(c.first_name,' ',c.last_name) AS customer_name,
        c.city,

        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount / 100.0)
        ) AS total_revenue

    FROM customers c
    JOIN orders o
         ON c.customer_id = o.customer_id
    JOIN order_items oi
         ON o.order_id = oi.order_id

    GROUP BY
        c.customer_id,
        customer_name,
        c.city
) revenue_table

ORDER BY total_revenue DESC
LIMIT 5;
-- e 
SELECT
    customer_name,
    city,
    ROUND(total_revenue,2) AS total_revenue
FROM
(
    SELECT
        c.customer_id,
        CONCAT(c.first_name,' ',c.last_name) AS customer_name,
        c.city,

        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount / 100.0)
        ) AS total_revenue

    FROM customers c
    JOIN orders o
         ON c.customer_id = o.customer_id
    JOIN order_items oi
         ON o.order_id = oi.order_id

    GROUP BY
        c.customer_id,
        customer_name,
        c.city
) customer_revenue

WHERE total_revenue >
(
    SELECT AVG(total_revenue)
    FROM
    (
        SELECT
            SUM(
                oi.quantity *
                oi.unit_price *
                (1 - oi.discount / 100.0)
            ) AS total_revenue
        FROM orders o
        JOIN order_items oi
             ON o.order_id = oi.order_id
        GROUP BY o.customer_id
    ) avg_table
)

ORDER BY total_revenue DESC;
-- =========================================================
-- SECTION H: CTEs
-- a
WITH customer_revenue AS (
    SELECT c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           ROUND(
               SUM(oi.quantity * (oi.unit_price - oi.discount)),
               2
           ) AS total_revenue
    FROM customers c
    JOIN orders o
         ON c.customer_id = o.customer_id
    JOIN order_items oi
         ON o.order_id = oi.order_id
    GROUP BY c.customer_id,
             c.first_name,
             c.last_name
)

SELECT *
FROM customer_revenue
ORDER BY total_revenue DESC
LIMIT 10;
 -- b 
 WITH product_sales AS
(
    SELECT
        c.category_name,
        p.product_name,
        SUM(oi.quantity) AS total_qty_sold
    FROM categories c
    JOIN products p
         ON c.category_id = p.category_id
    JOIN order_items oi
         ON p.product_id = oi.product_id
    GROUP BY
        c.category_name,
        p.product_name
)

SELECT *
FROM product_sales ps
WHERE total_qty_sold =
(
    SELECT MAX(total_qty_sold)
    FROM product_sales ps2
    WHERE ps.category_name = ps2.category_name
);
-- c 
WITH monthly_revenue AS
(
    SELECT
        EXTRACT(MONTH FROM o.order_date) AS month_no,

        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount / 100.0)
        ) AS total_revenue

    FROM orders o
    JOIN order_items oi
         ON o.order_id = oi.order_id

    WHERE EXTRACT(YEAR FROM o.order_date) = 2023

    GROUP BY month_no
),

avg_revenue AS
(
    SELECT AVG(total_revenue) AS avg_monthly_revenue
    FROM monthly_revenue
)

SELECT
    month_no,
    ROUND(total_revenue,2) AS total_revenue,

    CASE
        WHEN total_revenue >
             avg_monthly_revenue
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS vs_average

FROM monthly_revenue
CROSS JOIN avg_revenue
ORDER BY month_no;
-- d 
WITH customer_orders AS
(
    SELECT
        c.customer_id,
        COUNT(o.order_id) AS total_orders

    FROM customers c
    LEFT JOIN orders o
           ON c.customer_id = o.customer_id

    GROUP BY c.customer_id
)

SELECT

    CASE
        WHEN total_orders >= 8
             THEN 'High Frequency'
        WHEN total_orders BETWEEN 4 AND 7
             THEN 'Regular'
        WHEN total_orders BETWEEN 1 AND 3
             THEN 'Occasional'
        ELSE 'Inactive'
    END AS segment,

    COUNT(*) AS customer_count

FROM customer_orders

GROUP BY segment

ORDER BY customer_count DESC;
-- e 
WITH yearly_revenue AS
(
    SELECT
        EXTRACT(YEAR FROM order_date) AS order_year,

        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount / 100.0)
        ) AS total_revenue

    FROM orders o
    JOIN order_items oi
         ON o.order_id = oi.order_id

    WHERE status = 'Delivered'

    GROUP BY order_year
)

SELECT
    order_year,
    ROUND(total_revenue,2) AS total_revenue
FROM yearly_revenue
ORDER BY order_year;
  