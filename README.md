SuperMart_Analytics_Project

Tables were created and records were inserted using dataset_creation.sql.

        Database Schema 
Table                             Key Columns 
regions                 region_id, region_name 
categories              category_id, category_name 
employees               employee_id, first_name, last_name, role, region_id, hire_date, salary 
customers               customer_id, first_name, last_name, email, city, country, registration_date 
products                product_id, product_name, category_id, unit_price, stock_quantity 
orders                 order_id, customer_id, employee_id, order_date, status, shipping_city 
order_items             order_item_id, order_id, product_id, quantity, unit_price, discount 
Key queries
section A: employees living in lagos, shipping cities with orders, 10 highest price products, employees hired after january 2021, December orders
Section B: orders by status, Minimum maxiumum and average price per category, total, minimum, maximum and average revenue
Section C: cities recieved more than 10 orders, products sold more than 50 items, total oreders placed per year
section D: customers with email containing '@gmail.com', products containing 'set',
Section E: 50 most recent orders, all customers along their orders, all employees along with their orders handled
Section F: product name per price tier, employee name per pay_band, order per total value
Section G: products that have been never ordered, products with unit price above the average unit price, top 5 customers by total life time revenue
Section H:Total revenue per customer across all orders, single best selling product per category, monthly performance in 2023
Section I: Employees Sales performance report
Section J: Customer lifetime value report

Repositery Structure:
Questions to be answered
Table creation and inserting records SQL file
Queries 

Tool used 
SQL

