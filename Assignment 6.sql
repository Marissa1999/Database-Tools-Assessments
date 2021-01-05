-- Marissa Gonçalves
-- Amy Yip

-- Database Tools 
-- Assignment 6 - PL/SQL (2)

-- 1) Modify question (2) in Assignment 5 so that it is a procedure called print_directory
--that takes the department id as its only parameter.

SET SERVEROUPUT ON
CREATE OR REPLACE PROCEDURE print_directory 
  (
     dept_id IN NUMBER
  )
IS
  prev_dept VARCHAR2(30);
  CURSOR employees_crsr IS
    SELECT department_name, last_name, first_name, email, phone_number
      FROM employees INNER JOIN departments USING (department_id)
     WHERE dept_id = department_id
     ORDER BY department_name, last_name, first_name;
BEGIN
  DBMS_OUTPUT.PUT_LINE('ACME Directory');
  DBMS_OUTPUT.PUT_LINE(RPAD('DEPARTMENT NAME', 20, ' ') 
                    || RPAD('LAST NAME',       12, ' ') 
                    || RPAD('FIRST NAME',      12, ' ') 
                    || RPAD('EMAIL',           12, ' ') 
                    || RPAD('PHONE NUMBER',    20, ' '));
  FOR r_employee IN employees_crsr
  LOOP
    IF(prev_dept = r_employee.department_name) THEN
      r_employee.department_name := ' ';
    ELSE
      prev_dept := r_employee.department_name;
    END IF;
    DBMS_OUTPUT.PUT_LINE(RPAD(r_employee.department_name, 20, ' ')
                      || RPAD(r_employee.last_name,       12, ' ') 
                      || RPAD(r_employee.first_name,      12, ' ')
                      || RPAD(r_employee.email,           12, ' ')
                      || RPAD(r_employee.phone_number,    20, ' '));
  END LOOP;
END;
/

EXECUTE print_directory(90);

-- 2) a) Write a function called avg_salary function that takes a department id as its only
--parameter and returns the average salary of all employees who work in that department.

CREATE OR REPLACE FUNCTION avg_salary
(
  dept_id IN NUMBER
)
RETURN NUMBER IS
  salary_result NUMBER := 0;
BEGIN
  SELECT AVG(salary)
    INTO salary_result
    FROM employees
   WHERE dept_id = department_id;
  RETURN salary_result;
END;
/

-- b) Use this function in an SQL query that prints each department’s name and average salary.

SELECT department_name, avg_salary(department_id)
  FROM departments
 ORDER BY department_name;

-- 3) Write the code for a sequence and a trigger that will provide the primary key value when a 
-- record is inserted into the promotions table. Show that this works with an example insert statement.

CREATE SEQUENCE promotion_seq
   INCREMENT BY 1
   START WITH 3;

CREATE OR REPLACE TRIGGER bi_promotions
   BEFORE INSERT ON promotions
   FOR EACH ROW
BEGIN
    :NEW.promo_id := promotion_seq.NEXTVAL;
END;
/

INSERT INTO promotions(promo_name) VALUES('Promotion');
