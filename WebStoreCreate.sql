CREATE DATABASE Webstore;

USE Webstore;

create TABLE Addres(
	AdrID int IDENTITY (1,1),
	City varchar(255),
	Street varchar(255),
	PostalCode int,
	Country varchar(255),
	PRIMARY KEY (AdrID)
);

CREATE TABLE Person(
	PerID int IDENTITY (1,1) PRIMARY KEY,
	FirstName varchar(255),
	LastName varchar(255),
	PhoneNumber nvarchar(20),
	Email varchar(255),

	AdrID int NOT NULL,
	FOREIGN KEY (AdrID) REFERENCES Addres(AdrID)
);

CREATE TABLE CustomerAccount(
	AccountID INT PRIMARY KEY IDENTITY (1,1),
	UserName varchar(255),
	Passwrd varchar(255)
);

CREATE TABLE Customer(
	CustID int IDENTITY (1,1) PRIMARY KEY,

	PersonID int NOT NULL,
	AccountID int,
	FOREIGN KEY (PersonID) REFERENCES Person(PerID),
	FOREIGN KEY (AccountID) REFERENCES CustomerAccount(AccountID)
);

CREATE TABLE Employee(
	EmpID int IDENTITY (1,1) PRIMARY KEY,
	JobTitle varchar(255),
	Salary DECIMAL,
	HireDate DATE,
	Bonus DECIMAL,

	PersonID int NOT NULL,
	FOREIGN KEY (PersonID) REFERENCES Person(PerID)
);
CREATE TABLE Department (
	DepID int IDENTITY (1,1) PRIMARY KEY ,
	DepName varchar(255),
	DepDesc varchar(255),
	NumberOfEmp int
);

CREATE TABLE EmpDep(
  EmployeeID int FOREIGN KEY REFERENCES Employee(EmpID),
  DepartmentID int FOREIGN KEY REFERENCES Department(DepID),
  PRIMARY KEY(EmployeeID, DepartmentID)
);

Create Table  Seller(
	SellerID int IDENTITY (1,1) PRIMARY KEY,
	BusinessName varchar(255),

	PersonID int NOT NULL,
	FOREIGN KEY (PersonID) REFERENCES Person(PerID),
);


CREATE TABLE Payment (
	payID int IDENTITY (1,1) PRIMARY KEY,
	Paymethod varchar (255),
	PayDate DATETIME,

	SellerID INT NOT NULL,
	FOREIGN KEY (SellerID) REFERENCES Seller(SellerID)
);

Create Table Orders (
	OrdID int IDENTITY (1,1) PRIMARY KEY,
	Ordnum int,
	TotalPrice int,

	CustomerID int NOT NULL ,
	PaymentID int NOT NULL,
	FOREIGN KEY (CustomerID) REFERENCES Customer(CustID),
	FOREIGN KEY (PaymentID) REFERENCES Payment(PayID),
);

Create Table ProdCategory (
	CatID int IDENTITY (1,1) PRIMARY KEY ,
	CategName varchar(255),
	CategCode varchar(255),
	CategDescrp varchar(255),
);

Create Table Product (
	ProdID int IDENTITY (1,1) PRIMARY KEY,
	ProdName varchar(255),
	prodBrand varchar(255),
	ProdDescrp varchar(255),
	ProdPrice DECIMAL(10,2),
	Quantity int,

	ProdCategoryID int,
	FOREIGN KEY (ProdCategoryID) REFERENCES ProdCategory(CatID),
);

Create Table OrdProd(
	ItemQuantity int,
	ProductID int NOT NULL,
	OrderID int NOT NULL,

	FOREIGN KEY (ProductID) REFERENCES Product(ProdID),
	FOREIGN KEY (OrderID) REFERENCES Orders(OrdID),
	PRIMARY KEY(ProductID, ORderID)
);

Create Table ProdSeller (
	ProductID int NOT NULL,
	SellerID int NOT NULL,

	FOREIGN KEY (ProductID) REFERENCES Product(ProdID),
	FOREIGN KEY (SellerID) REFERENCES Seller(SellerID),
	PRIMARY KEY(ProductID, SellerID)
);

CREATE TABLE Rating(
    RatingID INT PRIMARY KEY IDENTITY (1,1),
	RatingValue INT CHECK (RatingValue >= 1 AND RatingValue <= 5),
    ProductID INT,
    CustomerID INT,
	SellerID INT,

    FOREIGN KEY (ProductID) REFERENCES Product(ProdID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustID),
	FOREIGN KEY (CustomerID) REFERENCES Seller(SellerID)
);

CREATE TABLE Wishlist(
	WishlistID INT PRIMARY KEY IDENTITY (1,1),
	ListName varchar(255),
	is_public BIT,
	AccountID INT NOT NULL,
	FOREIGN KEY (AccountID) REFERENCES CustomerAccount(AccountID)
);

CREATE TABLE WishlistProd(
	listID INT PRIMARY KEY IDENTITY (1,1),
	AddedDate DATE,
	Quantity int,
	ItemPriority nvarchar(10),

	WishlistID INT FOREIGN KEY REFERENCES Wishlist(WishlistID),
	ProductID INT FOREIGN KEY REFERENCES Product(prodID)
);

-- ops Forgot to add these attributes
ALTER TABLE Person
	ADD Gender char(1);
ALTER TABLE Customer
	ADD Income Decimal;

	


	--------------
