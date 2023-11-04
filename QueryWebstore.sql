----INNER JOIN: returns all rows from both tables where the join condition is true.
SELECT *
FROM Orders
INNER JOIN Customer ON Orders.CustomerID = Customer.CustID;
---joining tables Customer and Orders to get the customer's name and their order details:
SELECT Person.FirstName, Person.LastName, Orders.TotalPrice, Orders.Ordnum
FROM Customer
JOIN Person ON Customer.PersonID = Person.PerID
JOIN Orders ON Customer.CustID = Orders.CustomerID;
-------Joining tables Product and ProdSeller to get all products sold by a specific seller:
SELECT Product.ProdName, Product.ProdPrice
FROM ProdSeller
JOIN Product ON ProdSeller.ProductID = Product.ProdID
WHERE ProdSeller.SellerID = 1;
-----------Joining tables Employee and Department to get the number of employees in each department:
SELECT Department.DepName, COUNT(EmpDep.EmployeeID) AS NumEmployees
FROM EmpDep
JOIN Employee ON EmpDep.EmployeeID = Employee.EmpID
JOIN Department ON EmpDep.DepartmentID = Department.DepID
GROUP BY Department.DepName;

----- Joining tables Customer and Wishlist to get the name of customers who have a public wishlist:
SELECT Person.FirstName, Person.LastName
FROM Customer
JOIN Person ON Customer.PersonID = Person.PerID
JOIN CustomerAccount ON Customer.CustID = CustomerAccount.AccountID
JOIN Wishlist ON CustomerAccount.AccountID = Wishlist.AccountID
WHERE Wishlist.is_public = 1;



---How many customers have purchased products from more than one seller?
SELECT COUNT(DISTINCT o.CustomerID) AS NumCustomers
FROM Orders o
JOIN OrdProd op ON o.OrdID = op.OrderID
JOIN ProdSeller ps ON op.ProductID = ps.ProductID
GROUP BY o.CustomerID
HAVING COUNT(DISTINCT ps.SellerID) > 1;


---Which product categories have the highest average ratings?
SELECT c.CategName, AVG(r.RatingValue) AS AvgRating
FROM ProdCategory c
JOIN Product p ON c.CatID = p.ProdCategoryID
JOIN Rating r ON p.ProdID = r.ProductID
GROUP BY c.CategName
ORDER BY AvgRating DESC


---For each seller, what is the total revenue earned from orders in which their products were sold?
SELECT Seller.SellerID, Seller.BusinessName, SUM(Product.ProdPrice * OrdProd.ItemQuantity) AS TotalRevenue
FROM Seller
JOIN Person ON Seller.PersonID = Person.PerID
JOIN ProdSeller ON Seller.SellerID = ProdSeller.SellerID
JOIN Product ON ProdSeller.ProductID = Product.ProdID
JOIN OrdProd ON Product.ProdID = OrdProd.ProductID
JOIN Orders ON OrdProd.OrderID = Orders.OrdID
GROUP BY Seller.SellerID, Seller.BusinessName;






----How many orders have been placed for products in a specific category?
SELECT COUNT(DISTINCT OrdProd.OrderID) AS NumOrders
FROM Orders
JOIN OrdProd ON Orders.OrdID = OrdProd.OrderID
JOIN Product ON OrdProd.ProductID = Product.ProdID
JOIN ProdCategory ON Product.ProdCategoryID = ProdCategory.CatID
WHERE ProdCategory.CategName = 'clothing';



---Which sellers have the highest average ratings for their products?
SELECT s.SellerID, s.BusinessName, AVG(r.RatingValue) as AvgRating
FROM Seller s
INNER JOIN ProdSeller ps ON s.SellerID = ps.SellerID
INNER JOIN Product p ON ps.ProductID = p.ProdID
INNER JOIN Rating r ON p.ProdID = r.ProductID
GROUP BY s.SellerID, s.BusinessName
ORDER BY AvgRating DESC;


----------
--trigger that updates the total number of employees in a department whenever 
--a new employee is added or an existing employee is deleted:
 CREATE TRIGGER update_num_employees
ON EmpDep
AFTER INSERT, DELETE
AS
BEGIN
    UPDATE Department
    SET NumberOfEmp = (SELECT COUNT(*) FROM EmpDep WHERE DepartmentID = Department.DepID)
    WHERE EXISTS (SELECT * FROM inserted WHERE inserted.DepartmentID = Department.DepID)
        OR EXISTS (SELECT * FROM deleted WHERE deleted.DepartmentID = Department.DepID);
END;
--- to test my trigger 
---Insert new values into the EmpDep table:
INSERT INTO EmpDep (EmployeeID, DepartmentID) VALUES (1, 1);
--- check if number of employee been updated in Department 
SELECT * FROM Department;
----delete som value from employeedepartment :: empdep
DELETE FROM EmpDep WHERE EmployeeID = 1;
--- check if if numberofEmp beeing updated 
SELECT * FROM Department;



