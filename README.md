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
