-- Disable foreign key checks to drop tables freely
SET FOREIGN_KEY_CHECKS = 0;

-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS Customer;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Table: Customer
CREATE TABLE Customer (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(40) NOT NULL,
    LastName VARCHAR(40) NOT NULL,
    City VARCHAR(40),
    Country VARCHAR(40),
    Phone VARCHAR(20)
) ENGINE=InnoDB;

-- Index: IndexCustomerName
CREATE INDEX IndexCustomerName ON Customer (LastName, FirstName);

-- Table: `Order`
CREATE TABLE `Order` (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    OrderNumber VARCHAR(10),
    CustomerId INT NOT NULL,
    TotalAmount DECIMAL(12,2) DEFAULT 0
) ENGINE=InnoDB;

-- Indexes for `Order`
CREATE INDEX IndexOrderCustomerId ON `Order` (CustomerId);
CREATE INDEX IndexOrderOrderDate ON `Order` (OrderDate);

-- Table: OrderItem
CREATE TABLE OrderItem (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    UnitPrice DECIMAL(12,2) NOT NULL DEFAULT 0,
    Quantity INT NOT NULL DEFAULT 1
) ENGINE=InnoDB;

-- Indexes for OrderItem
CREATE INDEX IndexOrderItemOrderId ON OrderItem (OrderId);
CREATE INDEX IndexOrderItemProductId ON OrderItem (ProductId);

-- Table: Product
CREATE TABLE Product (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    SupplierId INT NOT NULL,
    UnitPrice DECIMAL(12,2) DEFAULT 0,
    Package VARCHAR(30),
    IsDiscontinued BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB;

-- Indexes for Product
CREATE INDEX IndexProductSupplierId ON Product (SupplierId);
CREATE INDEX IndexProductName ON Product (ProductName);

-- Table: Supplier
CREATE TABLE Supplier (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    CompanyName VARCHAR(40) NOT NULL,
    ContactName VARCHAR(50),
    ContactTitle VARCHAR(40),
    City VARCHAR(40),
    Country VARCHAR(40),
    Phone VARCHAR(30),
    Fax VARCHAR(30)
) ENGINE=InnoDB;

-- Indexes for Supplier
CREATE INDEX IndexSupplierName ON Supplier (CompanyName);
CREATE INDEX IndexSupplierCountry ON Supplier (Country);

-- Foreign Keys
ALTER TABLE `Order`
    ADD CONSTRAINT FK_ORDER_REFERENCE_CUSTOMER
    FOREIGN KEY (CustomerId) REFERENCES Customer(Id);

ALTER TABLE OrderItem
    ADD CONSTRAINT FK_ORDERITE_REFERENCE_ORDER
    FOREIGN KEY (OrderId) REFERENCES `Order`(Id);

ALTER TABLE OrderItem
    ADD CONSTRAINT FK_ORDERITE_REFERENCE_PRODUCT
    FOREIGN KEY (ProductId) REFERENCES Product(Id);

ALTER TABLE Product
    ADD CONSTRAINT FK_PRODUCT_REFERENCE_SUPPLIER
    FOREIGN KEY (SupplierId) REFERENCES Supplier(Id);