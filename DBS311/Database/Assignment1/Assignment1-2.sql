/*Assignment Link: https://learn-us-east-1-prod-fleet01-xythos.s3.amazonaws.com/5c082fb7a0cdb/15036023?response-cache-control=private%2C%20max-age%3D21600&response-content-disposition=inline%3B%20filename%2A%3DUTF-8%27%27DBS311_NAA_Assignment1_S20%25282%2529.pdf&response-content-type=application%2Fpdf&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20200818T000000Z&X-Amz-SignedHeaders=host&X-Amz-Expires=21600&X-Amz-Credential=AKIAZH6WM4PL5SJBSTP6%2F20200818%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=e9542956dd6b64f00619d67f229a23995df7f8237b44470b0f92c8a351749f0a*/



/*
Assignment 1
DBS 311NAA
GROUP 1
Darsh Jitendra Modessa: 157829185
Andrew Qin: 132244195
Gulnur Baimukhambetova: 100577196

*/

/*1. Display the employee number, full employee name, job title, and  
hire date of all employees hired in September with the most recently hired employees  
displayed first.*/ 
SELECT Employee_id                                            "Employee Number", 
       ( Last_name 
         ||', ' 
         || First_name )                                      "Full Name", 
       Job_title, 
       To_char(Employees.Hire_date, '[Month ddth "of" YYYY]') AS HIRE_DATE 
FROM   Employees 
WHERE  Hire_date < To_date('2016-10-01', 'YYYY-MM-DD') 
       AND Hire_date > To_date('2016-09-01', 'YYYY-MM-DD') 
ORDER  BY Hire_date DESC; 

/*2. The company wants to see the total sale amount per sales person (salesman) for all orders.  
Assume that online orders do not have any sales representative. For online orders (orders with no salesman ID), consider the salesman ID as 0. 
Display the salesman ID and the total sale amount for each employee. 
Sort the result according to employee number.*/ 
SELECT Nvl(Salesman_id, 0)"Employee Number", 
       To_char(SUM(Order_items.Unit_price * 
       Order_items.Quantity), '$999,999,999.99') "Total Sale"
FROM   Orders 
       INNER JOIN Order_items 
               ON Order_items.Order_id = Orders.Order_id 
GROUP  BY Orders.Salesman_id 
ORDER  BY Nvl(Orders.Salesman_id, 0); 

/*3. Display customer Id, customer name and total number of orders for customers that the value of their customer ID is in values from 35 to 45. 
Include the customers with no orders in your report if their customer ID falls in the range 35 and 45.
Sort the result by the value of total orders.*/ 
SELECT Customers.Customer_id"Customer Id", 
       Customers.Name"Name", 
       Count(Orders.Customer_id)"TOTAL ORDER" 
FROM   Customers 
       FULL OUTER JOIN Orders 
                    ON Orders.Customer_id = Customers.Customer_id 
GROUP  BY Customers.Customer_id, 
          Customers.Name 
HAVING Customers.Customer_id >= 35 
       AND Customers.Customer_id <= 45 
ORDER  BY Count(Orders.Customer_id); 

/*4. Display customer ID, customer name, and the order ID and the order date of all orders for customer whose ID is 44.
a. Show also the total quantity and the total amount of each customer’s order. 
b. Sort the result from the highest to lowest total order amount.*/ 
SELECT 
Customers.Customer_id"Customer Id", 
Customers.Name"Name", 
Orders.Order_id"Order Id", 
Orders.Order_date"Order Date", 
SUM(Order_items.Quantity)                                         "Total Items", 
To_char(SUM(Order_items.Quantity * Unit_price), '$999,999,999.99')"Total Amount" 
FROM   Customers 
       INNER JOIN Orders 
               ON Customers.Customer_id = Orders.Customer_id 
       INNER JOIN Order_items 
               ON Order_items.Order_id = Orders.Order_id 
GROUP  BY Customers.Customer_id, 
          Customers.Name, 
          Orders.Order_id, 
          Orders.Order_date 
HAVING Customers.Customer_id = 44 
ORDER  BY SUM(Order_items.Quantity * Unit_price)DESC; 

/*5. Display customer Id, name, total number of orders, the total number of items ordered, and the total order amount for customers who have more than 30 orders.
Sort the result based on the total number of orders.*/ 
SELECT 
Customers.Customer_id"Customer Id", 
Customers.Name"Name", 
Count(Order_items.Quantity)                                       "Total Number of Orders", 
SUM(Order_items.Quantity)                                         "Total Items", 
To_char(SUM(Order_items.Quantity * Unit_price), '$999,999,999.99')"Total Amount" 
FROM   Customers 
       INNER JOIN Orders 
               ON Customers.Customer_id = Orders.Customer_id 
       INNER JOIN Order_items 
               ON Order_items.Order_id = Orders.Order_id 
GROUP  BY Customers.Customer_id, 
          Customers.Name 
HAVING Count(Order_items.Quantity) > 30 
ORDER  BY Count(Order_items.Quantity); 

/* 
6. Display Warehouse Id, warehouse name, product category Id, product category name, and the lowest product standard cost for this combination.
• In your result, include the rows that the lowest standard cost is less then $200. 
• Also, include the rows that the lowest cost is more than $500. 
• Sort the output according to Warehouse Id, warehouse name and then product 
category Id, and product category name.*/ 
SELECT Warehouses.Warehouse_id"Warehouse ID", 
       Warehouses.Warehouse_name"Warehouse Name", 
       Product_categories.Category_id"Category ID", 
       Product_categories.Category_name"Category Name", 
       To_char(Min(Products.Standard_cost), '$999,999.99')"Lowest Cost" 
FROM   Warehouses 
       INNER JOIN Inventories 
               ON Inventories.Warehouse_id = Warehouses.Warehouse_id 
       INNER JOIN Products 
               ON Products.Product_id = Inventories.Product_id 
       INNER JOIN Product_categories 
               ON Product_categories.Category_id = Products.Category_id 
GROUP  BY Warehouses.Warehouse_id, 
          Warehouses.Warehouse_name, 
          Product_categories.Category_id, 
          Product_categories.Category_name 
HAVING Min(Products.Standard_cost) > 500 
        OR Min(Products.Standard_cost) < 200 
ORDER  BY Warehouses.Warehouse_id, 
          Warehouses.Warehouse_name, 
          Product_categories.Category_id, 
          Product_categories.Category_name; 

/*7. Display the total number of orders per month. Sort the result from January to December.*/ 
SELECT To_char(Orders.Order_date, 'Month')       "Month", 
       Count(To_char(Orders.Order_date, 'Month'))"Number of Orders" 
FROM   Orders 
GROUP  BY Extract(MONTH FROM Order_date), 
          ( To_char(Orders.Order_date, 'Month') ) 
ORDER  BY Extract(MONTH FROM Order_date); 

/*8. Display product Id, product name for products that their list price is more than any highest product standard cost per warehouse outside Americas regions.
(You need to find the highest standard cost for each warehouse that is located outside the Americas regions. Then you need to return all products that their list price is higher than any highest standard cost of those warehouses.)
Sort the result according to list price from highest value to the lowest.*/ 
SELECT Products.Product_id"Product Id", 
       Products.Product_name"Product Name", 
       To_char(Products.List_price, '$999,999.99')"Price" 
FROM   Products 
       FULL OUTER JOIN Inventories 
                    ON Products.Product_id = Inventories.Product_id 
       FULL OUTER JOIN Warehouses 
                    ON Inventories.Warehouse_id = Warehouses.Warehouse_id 
       FULL OUTER JOIN Locations 
                    ON Locations.Location_id = Warehouses.Location_id 
       FULL OUTER JOIN Countries 
                    ON Countries.Country_id = Locations.Country_id 
       FULL OUTER JOIN Regions 
                    ON Countries.Region_id = Regions.Region_id 
GROUP  BY Products.Product_id, 
          Products.Product_name, 
          Products.List_price 
HAVING List_price > ANY (SELECT Max(Products.Standard_cost) 
                         FROM   Products 
                                FULL OUTER JOIN Inventories 
                                             ON Products.Product_id = 
                                                Inventories.Product_id 
                                FULL OUTER JOIN Warehouses 
                                             ON Inventories.Warehouse_id = 
                                                Warehouses.Warehouse_id 
                                FULL OUTER JOIN Locations 
                                             ON Locations.Location_id = 
                                                Warehouses.Location_id 
                                FULL OUTER JOIN Countries 
                                             ON Countries.Country_id = 
                                                Locations.Country_id 
                                FULL OUTER JOIN Regions 
                                             ON Countries.Region_id = 
                                                Regions.Region_id 
                         GROUP  BY Inventories.Warehouse_id, 
                                   Regions.Region_id, 
                                   Regions.Region_name 
                         HAVING Regions.Region_name <> 'Americas') 
ORDER  BY Products.Product_id, 
          Products.Product_name, 
          Products.List_price; 

/*9. Write a SQL statement to display the most expensive and the cheapest product (list price). Display product ID, product name, and the list price.*/
SELECT Product_id"Product Id", 
       Product_name"Product Name", 
       To_char(List_price, '$999,999.99')"Price" 
FROM   Products 
WHERE  List_price = (SELECT Max(List_price) 
                     FROM   Products) 
UNION 
SELECT Product_id, 
       Product_name, 
       To_char(List_price, '$999,999.99') 
FROM   Products 
WHERE  List_price = (SELECT Min(List_price) 
                     FROM   Products); 

/*10. Write a SQL query to display the number of customers with total order amount over 
the average amount of all orders, the number of customers with total order amount 
under the average amount of all orders, number of customers with no orders, and 
the total number of customers. 
See the format of the following result.*/ 
SELECT to_char('Number of customers with total purchase amount over average: ')||Count(Count(Customers.Customer_id))"Customer Report" 
FROM   Customers 
       INNER JOIN Orders 
               ON Orders.Customer_id = Customers.Customer_id 
       INNER JOIN Order_items 
               ON Orders.Order_id = Order_items.Order_id 
GROUP  BY ( Customers.Customer_id ) 
HAVING SUM(Quantity * Unit_price) > (SELECT Avg(Quantity * Unit_price) 
                                     FROM   Order_items) 
UNION ALL
SELECT to_char('Number of customers with total purchase amount below average: ')||Count(Count(Customers.Customer_id)) 
FROM   Customers 
       INNER JOIN Orders 
               ON Orders.Customer_id = Customers.Customer_id 
       INNER JOIN Order_items 
               ON Orders.Order_id = Order_items.Order_id 
GROUP  BY Customers.Customer_id 
HAVING SUM(Quantity * Unit_price) < (SELECT Avg(Quantity * Unit_price) 
                                     FROM   Order_items) 
UNION ALL
SELECT to_char('Number of customers with no orders: ')||Count(Customers.Customer_id) 
FROM   Customers 
       FULL OUTER JOIN Orders 
                    ON Orders.Customer_id = Customers.Customer_id 
WHERE  Orders.Order_id IS NULL 
UNION ALL
SELECT to_char('Total number of customers: ')||Count(Customers.Customer_id) 
FROM   Customers; 

   





