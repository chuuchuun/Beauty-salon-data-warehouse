DROP TABLE IF EXISTS dbo.ProductsDetails;

CREATE TABLE dbo.ProductsDetails (
    ID CHAR(10) PRIMARY KEY,
    Product_name VARCHAR(20) NOT NULL,
    Producer VARCHAR(30) NOT NULL,
    Price MONEY,
    Product_type VARCHAR(30) NOT NULL
);

BULK INSERT dbo.ProductsDetails
FROM 'C:\Users\alla\Desktop\hd\task5\database\data\products_details.csv'  
WITH (
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2          
);

USE BookingManagementDW; 
GO

IF OBJECT_ID('vETLProduct', 'V') IS NOT NULL DROP VIEW vETLProduct;
GO

CREATE VIEW vETLProduct AS
SELECT 
    S.ProductName,
    Product_type = ES.Product_type,
    Producer = ES.Producer
FROM [Booking management system].dbo.ProductTable S
LEFT JOIN dbo.ProductsDetails ES
ON S.ProductName = ES.Product_name;
GO

MERGE INTO ProductDT AS Target
USING vETLProduct AS Source
ON Target.Product_name = Source.ProductName 
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Product_name, Product_type, Producer)
    VALUES (Source.ProductName, Source.Product_type, Source.Producer);
GO
