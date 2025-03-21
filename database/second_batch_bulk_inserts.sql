use [Booking management system]


DROP TABLE IF EXISTS dbo.TempClient;
DROP TABLE IF EXISTS dbo.TempProcedure
DROP TABLE IF EXISTS dbo.TempProduct;
DROP TABLE IF EXISTS dbo.TempProcedure_Product;
DROP TABLE IF EXISTS dbo.TempStaff;
DROP TABLE IF EXISTS dbo.TempAppointment;

CREATE TABLE dbo.TempClient (
    ID CHAR(11) CHECK (LEN(ID) = 11 AND ISNUMERIC(ID) = 1) PRIMARY KEY,
    FirstName VARCHAR(20) CHECK(ISNUMERIC(FirstName) = 0) NOT NULL,
    Surname VARCHAR(30) CHECK(ISNUMERIC(Surname) = 0) NOT NULL,
    PhoneNumber VARCHAR(15) CHECK(ISNUMERIC(PhoneNumber) = 1) NOT NULL,
    Email VARCHAR(50) CHECK (CHARINDEX('@', Email) > 0) NOT NULL,
    Refferal CHAR(11) NULL CHECK (Refferal IS NULL OR (LEN(Refferal) = 11 AND ISNUMERIC(Refferal) = 1))
);

CREATE TABLE dbo.TempProcedure(
	ID CHAR(10) PRIMARY KEY,
	ProcedureType VARCHAR(30) NOT NULL,
	Price MONEY NOT NULL,
	Duration FLOAT NOT NULL
);

CREATE TABLE dbo.TempProduct(
	ID CHAR(10) PRIMARY KEY,
	ProductName CHAR(20) NOT NULL
);

CREATE TABLE dbo.TempProcedure_Product(
	ProcedureProductID CHAR(10) PRIMARY KEY,
	Procedure_ID CHAR(10) REFERENCES dbo.ProcedureTable ON UPDATE CASCADE,
	Product_ID CHAR(10) REFERENCES dbo.ProductTable ON UPDATE CASCADE,
	Quantity INT CHECK(Quantity > 0),
);

CREATE TABLE dbo.TempStaff (
	ID CHAR(11) CHECK (LEN(ID) = 11 AND ISNUMERIC(ID) = 1) PRIMARY KEY,
	FirstName VARCHAR(20) CHECK(ISNUMERIC(FirstName) = 0) NOT NULL,
	Surname VARCHAR(30) CHECK(ISNUMERIC(SurName) = 0)NOT NULL,
	PhoneNumber VARCHAR(15) CHECK(ISNUMERIC(PhoneNumber) = 1)NOT NULL,
	Email VARCHAR(40) CHECK (CHARINDEX('@', Email) > 0),
	Qualification VARCHAR(50) CHECK (Qualification IN (
	'Haircutting and Styling Certificate',
	'Esthetician License',
	'Nail Technician License',
	'Cosmetology License',
	'Massage Therapy License',
	'Hair Color Specialist Certification'
	)) NOT NULL
);

CREATE TABLE dbo.TempAppointment(
    ID CHAR(10) PRIMARY KEY,
    AppointmentDate DATE CHECK(YEAR(AppointmentDate) > 1999) NOT NULL,
    ConfirmationType VARCHAR(20) CHECK(ConfirmationType IN (
        'Phone call',
        'Email',
        'SMS'
    )) NOT NULL,
    AppointmentStatus VARCHAR(10) CHECK(AppointmentStatus IN (
        'Scheduled',
        'Completed',
        'Canceled'
    )),
    Rate INT CHECK (Rate > 0 AND Rate < 6) NOT NULL,
    Feedback VARCHAR(200),
    FK_Procedure_Product CHAR(10) REFERENCES dbo.Procedure_Product,
    FK_Client CHAR(11) REFERENCES dbo.Client,
    FK_StaffMember CHAR(11) REFERENCES dbo.StaffMember
);


BULK INSERT dbo.TempClient
FROM 'C:\Users\alla\Desktop\hd\data_generator\Client_2.bulk'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n' 
);

BULK INSERT dbo.TempProcedure
FROM 'C:\Users\alla\Desktop\hd\data_generator\ProcedureTable_2.bulk'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n' 
);

BULK INSERT dbo.TempProduct
FROM 'C:\Users\alla\Desktop\hd\data_generator\ProductTable_2.bulk'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n' 
);

BULK INSERT dbo.TempProcedure_Product
FROM 'C:\Users\alla\Desktop\hd\data_generator\Procedure_product_2.bulk'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n' 
);

BULK INSERT dbo.TempStaff
FROM 'C:\Users\alla\Desktop\hd\data_generator\StaffMember_2.bulk'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n' 
);

BULK INSERT dbo.TempAppointment
FROM 'C:\Users\alla\Desktop\hd\data_generator\Appointment_2.bulk'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n' 
);
 SELECT * FROM dbo.Client

UPDATE dbo.Client
SET 
    dbo.Client.Surname = T.Surname,
    dbo.Client.PhoneNumber = T.PhoneNumber,
    dbo.Client.Email = T.Email
FROM dbo.Client
JOIN dbo.TempClient T ON dbo.Client.ID = T.ID;


SELECT * FROM dbo.Client

UPDATE dbo.ProcedureTable
SET 
    dbo.ProcedureTable.Price = T.Price,
    dbo.procedureTable.Duration = T.Duration
FROM dbo.ProcedureTable
JOIN dbo.TempProcedure T ON dbo.ProcedureTable.ID = T.ID;

UPDATE dbo.ProductTable
SET 
    dbo.ProductTable.ProductName = T.ProductName
FROM dbo.ProductTable
JOIN dbo.TempProduct T ON dbo.ProductTable.ID = T.ID;

UPDATE dbo.Procedure_Product
SET 
    dbo.Procedure_Product.Quantity = T.Quantity
FROM dbo.Procedure_Product
JOIN dbo.TempProcedure_Product T ON dbo.Procedure_Product.ProcedureProductID = T.ProcedureProductID;

UPDATE dbo.StaffMember
SET 
    dbo.StaffMember.Surname = T.Surname,
	dbo.StaffMember.PhoneNumber = T.PhoneNumber,
	dbo.StaffMember.Email = T.Email,
	dbo.StaffMember.Qualification = T.Qualification
FROM dbo.StaffMember
JOIN dbo.TempStaff T ON dbo.StaffMember.ID = T.ID;

INSERT INTO dbo.Client (ID, FirstName, Surname, PhoneNumber, Email, Refferal)
SELECT T.ID, T.FirstName, T.Surname, T.PhoneNumber, T.Email, T.Refferal
FROM dbo.TempClient T
LEFT JOIN dbo.Client C ON T.ID = C.ID
WHERE C.ID IS NULL

INSERT INTO dbo.ProcedureTable(ID, ProcedureType, Price, Duration)
SELECT T.ID, T.ProcedureType, T.Price, T.Duration
FROM dbo.TempProcedure T
LEFT JOIN dbo.ProcedureTable P ON T.ID = P.ID
WHERE P.ID IS NULL 

INSERT INTO dbo.ProductTable(ID,ProductName)
SELECT T.ID, T.ProductName
FROM dbo.TempProduct T
LEFT JOIN dbo.ProductTable P ON T.ID = P.ID
WHERE P.ID IS NULL 

INSERT INTO dbo.Procedure_Product(ProcedureProductID,Procedure_ID, Product_ID, Quantity)
SELECT T.ProcedureProductID,T.Procedure_ID, T.Product_ID, T.Quantity
FROM dbo.TempProcedure_Product T
LEFT JOIN dbo.Procedure_Product P ON T.ProcedureProductID = P.ProcedureProductID
WHERE P.ProcedureProductID IS NULL 

INSERT INTO dbo.StaffMember(ID,FirstName, Surname, PhoneNumber, Email, Qualification)
SELECT T.ID,T.FirstName, T.Surname, T.PhoneNumber, T.Email, T.Qualification
FROM dbo.TempStaff T
LEFT JOIN dbo.StaffMember S ON T.ID = S.ID
WHERE S.ID IS NULL 

INSERT INTO dbo.Appointment (ID, AppointmentDate, ConfirmationType, AppointmentStatus, Rate, Feedback, FK_Procedure_Product, FK_Client, FK_StaffMember)
SELECT T.ID, T.AppointmentDate, T.ConfirmationType, T.AppointmentStatus, T.Rate, T.Feedback, T.FK_Procedure_Product, T.FK_Client, T.FK_StaffMember
FROM dbo.TempAppointment T
LEFT JOIN dbo.Appointment A ON T.ID = A.ID
WHERE A.ID IS NULL;


DROP TABLE dbo.TempClient;
DROP TABLE dbo.TempProcedure;
DROP TABLE dbo.TempProduct;
DROP TABLE dbo.TempProcedure_Product;
DROP TABLE dbo.TempStaff;
DROP TABLE dbo.TempAppointment;
