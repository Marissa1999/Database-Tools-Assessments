-- Marissa Gonçalves
-- Amy Yip

-- Database Tools 
-- Assignment 5 - PL/SQL (1)

-- 1) Create a PL/SQL program block that uses a cursor FOR loop to output information for
-- each of the employees in the HR database. Show the last names, first name, department
-- names, emails, and phone numbers. Include column headings. The names should be in
-- alphabetical order (last, first, department). Print a header at the beginning of the list
-- identifying it as the ACME Directory.
-- The only local variable you will need to declare is employees_crsr

SET SERVEROUPUT ON
DECLARE
  CURSOR employees_crsr IS
    SELECT last_name, first_name, department_name, email, phone_number
      FROM employees INNER JOIN departments USING (department_id)
     ORDER BY last_name, first_name, department_name ASC;
BEGIN
  DBMS_OUTPUT.PUT_LINE('ACME Directory');
  DBMS_OUTPUT.PUT_LINE(RPAD('LAST NAME',       12, ' ') 
                    || RPAD('FIRST NAME',      12, ' ') 
                    || RPAD('DEPARTMENT NAME', 20, ' ') 
                    || RPAD('EMAIL',           12, ' ') 
                    || RPAD('PHONE NUMBER',    20, ' '));
  FOR r_employee IN employees_crsr
  LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(r_employee.last_name,       12, ' ') 
                      || RPAD(r_employee.first_name,      12, ' ')
                      || RPAD(r_employee.department_name, 20, ' ')
                      || RPAD(r_employee.email,           12, ' ')
                      || RPAD(r_employee.phone_number,    20, ' '));
  END LOOP;
END;
/

-- 2) Modify your answer to question 1 to produce a directory by department, and output the
-- department name only once, as shown below.
-- You may need a second declared variable named prev_dept.

SET SERVEROUPUT ON
DECLARE
  prev_dept VARCHAR2(30);
  CURSOR employees_crsr IS
    SELECT department_name, last_name, first_name, email, phone_number
      FROM employees INNER JOIN departments USING (department_id)
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