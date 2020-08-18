/*Andrew Qin 
132244195 
DBS311NAA*/ 
Set serveroutput ON; 
/*1.  Write a store procedure that gets an integer number n and calculates and displays its factorial.*/
CREATE OR replace PROCEDURE Findfactorial(ninteger IN INT) 
IS 
  factorialvalue INT := 1; 
  i              INT := 0; 
BEGIN 
    LOOP 
        factorialvalue := ( factorialvalue * ( ninteger - i ) ); 

        i := i + 1; 

        EXIT WHEN i = ninteger; 
    END LOOP; 

    dbms_output.Put_line(factorialvalue); 
EXCEPTION 
  WHEN OTHERS THEN 
             dbms_output.Put_line('error!'); 
END; 

/ 
/*Sample Execution */ 
BEGIN 
    Findfactorial(6); 
END; 

/ 
/*2.  The company wants to calculate the employees’ annual salary: 
The first year of employment, the amount of salary is the base salary which is $10,000. 
Every year after that, the salary increases by 5%. 
Write a stored procedure named calculate_salary which gets an employee ID and for that employee calculates the salary based on the number of years the employee has been working in the company.  (Use a loop construct to calculate the salary).
The procedure calculates and prints the salary. 
Sample output: 
First Name: first_name  
Last Name: last_name 
Salary: $9999,99 
If the employee does not exists, the procedure displays a proper message. 
*/ 
CREATE OR replace PROCEDURE Calculate_salary(employee_id IN NUMBER) 
IS 
  salary    NUMBER := 10000; 
  yearcount NUMBER; 
  firstname VARCHAR(20); 
  lastname  VARCHAR(20); 
  i         INT := 0; 
BEGIN 
    SELECT Trunc(To_char(SYSDATE - employees.hire_date) / 365) 
    INTO   yearcount 
    FROM   employees 
    WHERE  employees.employee_id = Calculate_salary.employee_id; 

    SELECT employees.first_name 
    INTO   firstname 
    FROM   employees 
    WHERE  employees.employee_id = Calculate_salary.employee_id; 

    SELECT employees.last_name 
    INTO   lastname 
    FROM   employees 
    WHERE  employees.employee_id = Calculate_salary.employee_id; 

    LOOP 
        salary := salary * 1.05; 

        i := i + 1; 

        EXIT WHEN i = yearcount; 
    END LOOP; 

    dbms_output.Put_line('First Name: ' 
                         ||firstname); 

    dbms_output.Put_line('Last Name: ' 
                         ||lastname); 

    dbms_output.Put_line('Salary: ' 
                         ||salary); 
EXCEPTION 
  WHEN no_data_found THEN 
             dbms_output.Put_line('No Data Found'); 
END; 

/ 
/*Sample Execution*/ 
BEGIN 
    Calculate_salary(0); 
END; 

/ 
/*3.  Write a stored procedure named warehouses_report to print the warehouse ID, warehouse name, and the city where the warehouse is located in the following format for all warehouses:

Warehouse ID: 
Warehouse name: 
City: 
State: 

If the value of state does not exist (null), display “no state”. 
The value of warehouse ID ranges from 1 to 9. 
You can use a loop to find and display the information of each warehouse inside the loop. 
(Use a loop construct to answer this question. Do not use cursors.)  
*/ 
CREATE OR replace PROCEDURE Warehouse_report 
IS 
  warehouseid   NUMBER := 1; 
  warehousename VARCHAR(20); 
  locationid    NUMBER := 0; 
  city          VARCHAR(20); 
  state1        VARCHAR(20); 
BEGIN 
    FOR i IN 1..9 LOOP 
        SELECT warehouses.warehouse_id 
        INTO   warehouseid 
        FROM   warehouses 
        WHERE  warehouse_id = warehouseid; 

        SELECT warehouses.warehouse_name 
        INTO   warehousename 
        FROM   warehouses 
        WHERE  warehouse_id = warehouseid; 

        SELECT locations.city 
        INTO   city 
        FROM   locations 
               inner join warehouses 
                       ON warehouses.location_id = locations.location_id 
        WHERE  warehouse_id = warehouseid; 

        SELECT locations.state 
        INTO   state1 
        FROM   locations 
               inner join warehouses 
                       ON warehouses.location_id = locations.location_id 
        WHERE  warehouse_id = warehouseid; 

        IF( warehouseid = i ) THEN 
          dbms_output.Put_line('Warehouse ID: ' 
                               ||warehouseid); 

          dbms_output.Put_line('Warehouse name: ' 
                               ||warehousename); 

          dbms_output.Put_line('City: ' 
                               ||city); 

          IF ( state1 IS NULL ) THEN 
            dbms_output.Put_line('No State'); 
          ELSE 
            dbms_output.Put_line('State: ' 
                                 ||state1); 
          END IF; 
        END IF; 

        warehouseid := warehouseid + 1; 

        dbms_output.Put_line(Chr(10)); 
    END LOOP; 
EXCEPTION 
  WHEN OTHERS THEN 
             dbms_output.Put_line('Error'); 
END; 

/ 
/*Sample Execution*/ 
BEGIN 
    Warehouse_report(); 
END; 





