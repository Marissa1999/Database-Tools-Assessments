-- Marissa Gonçalves
-- Amy Yip

--Database Tools 
--Assignment 4 - Retrieving Data

--Provide the SQL queries needed to answer the questions below using the 
--information in the Human Resources and Order Entry databases.  
--Remember to use explicit joins and to format your code as discussed in class.

--1. Modify the query below to correct the age of customers who appear to be 
--   have been born this millennium.  Use the text “31 December 1999” in your 
--   answer.

UPDATE customers
   SET date_of_birth = ADD_MONTHS(date_of_birth, - 12*100)
 WHERE date_of_birth > TO_DATE('31 December 1999', 'dd Month yyyy');

--2. List in reverse numerical order the IDs of all products whose name or 
--   description includes the string “LCD”.

SELECT product_id
  FROM product_information
 WHERE product_name LIKE '%LCD%' 
    OR product_description LIKE '%LCD%'
 ORDER BY product_id DESC;

--3. Determine the average salaries rate of all employees by department.

SELECT department_name, TRUNC(AVG(salary)) AS salary_rate
  FROM employees INNER JOIN departments USING (department_id)
 GROUP BY department_name;

--4. What is the name and job title of all employees who do not have a manager?

SELECT first_name, last_name, job_title
  FROM employees INNER JOIN jobs USING (job_id)
 WHERE employees.manager_id IS NULL;

--5. a. What is the average age of clients who have an account manager by 
--      territory?

SELECT nls_territory,
       TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(TRUNC(AVG(TO_NUMBER(TO_CHAR(date_of_birth, 'J')))), 'J'))/12) AS average_age
  FROM customers
 WHERE account_mgr_id IS NOT NULL
 GROUP BY nls_territory;

--   b. What is the average age of clients who do not have an account manager 
--      by territory?

SELECT nls_territory,
       TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(TRUNC(AVG(TO_NUMBER(TO_CHAR(date_of_birth, 'J')))), 'J'))/12) AS average_age
  FROM customers
 WHERE account_mgr_id IS NULL
 GROUP BY nls_territory;


--6. What are the IDs and names (in alphabetical order) of all employees that 
--   work in Europe?
--   a. Do this using explicit joins and without subqueries.

SELECT employee_id, first_name, last_name
  FROM employees INNER JOIN departments USING (department_id)
                 INNER JOIN locations   USING (location_id)
                 INNER JOIN countries   USING (country_id)
                 INNER JOIN regions     USING (region_id)
 WHERE regions.region_name = 'Europe'
 ORDER BY first_name, last_name;

--   b. Do this with subqueries and without joins.

SELECT employee_id, first_name, last_name
  FROM employees
 WHERE department_id IN (SELECT department_id
                           FROM departments
                          WHERE location_id IN (SELECT location_id
                                                  FROM locations
                                                 WHERE country_id IN (SELECT country_id
                                                                        FROM countries
                                                                       WHERE region_id IN (SELECT region_id
                                                                                             FROM regions
                                                                                            WHERE region_name = 'Europe'))))
  ORDER BY first_name, last_name;
																																																													
--7. For each product with a warrantee that was purchased, list the customer 
--   id, their names (as separate columns), their age in years, the product id, 
--   the product name, the purchase date, and the warranty expiration date.  
--   Give calculated columns short but meaningful names.  Do not rename columns
--   that are simply retrieved from the database.
--   a. Write a query to do this.

SELECT customer_id, cust_first_name, cust_last_name, 
       TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(TRUNC(TO_NUMBER(TO_CHAR(date_of_birth, 'J'))), 'J'))/12) AS age, 
	   product_id, product_name, order_date, order_date + warranty_period AS warranty_expiration_date
  FROM customers INNER JOIN orders              USING (customer_id)
                 INNER JOIN order_items         USING (order_id)
                 INNER JOIN product_information USING (product_id);

--   b. Create a view in OE called warranties based on this query.

CREATE VIEW warranties_v AS 
     SELECT customer_id, cust_first_name, cust_last_name, 
            TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(TRUNC(TO_NUMBER(TO_CHAR(date_of_birth, 'J'))), 'J'))/12) AS age, 
	        product_id, product_name, order_date, order_date + warranty_period AS warranty_expiration_date
       FROM customers INNER JOIN orders              USING (customer_id)
                      INNER JOIN order_items         USING (order_id)
                      INNER JOIN product_information USING (product_id);

--   c. Write a query based on the view that lists the names of all customers 
--      who had a warranty expire in 2009.

REPLACE VIEW warranties_v AS 
      SELECT customer_id, cust_first_name, cust_last_name, 
             TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(TRUNC(TO_NUMBER(TO_CHAR(date_of_birth, 'J'))), 'J'))/12) AS age,  
	         product_id, product_name, order_date, order_date + warranty_period AS warranty_expiration_date
        FROM customers INNER JOIN orders              USING (customer_id)
                       INNER JOIN order_items         USING (order_id)
                       INNER JOIN product_information USING (product_id)
       WHERE warranty_period + order_date BETWEEN TO_DATE('01-01-2009', 'MM-DD-YYYY') 
                                          AND TO_DATE('12-31-2009', 'MM-DD-YYYY');

--8. Consider warehouse inventories based on the min price of the items stored 
--   there.
--   a. List the name of each warehuse along with the total value of its 
--      inventory.

SELECT warehouse_name, 
       SUM(min_price * quantity_on_hand) AS total_inventories
  FROM warehouses INNER JOIN inventories         USING(warehouse_id)
                  INNER JOIN product_information USING (product_id)
 GROUP BY warehouse_name;

--   b. Do the same, but only show those with more than $1,000 in inventory.

SELECT warehouse_name,
       SUM(min_price * quantity_on_hand) AS total_inventories
  FROM warehouses INNER JOIN inventories         USING (warehouse_id)
                  INNER JOIN product_information USING (product_id)
 GROUP BY warehouse_name
HAVING SUM(min_price * quantity_on_hand) > 1000;


