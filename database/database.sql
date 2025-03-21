use [Booking management system]
CREATE TABLE dbo.Client(
	ID CHAR(11) CHECK (LEN(ID) = 11 AND ISNUMERIC(ID) = 1) PRIMARY KEY,
	FirstName VARCHAR(20) CHECK(ISNUMERIC(FirstName) = 0) NOT NULL,
	Surname VARCHAR(30) CHECK(ISNUMERIC(SurName) = 0)NOT NULL,
	PhoneNumber VARCHAR(15) CHECK(ISNUMERIC(PhoneNumber) = 1)NOT NULL,
	Email VARCHAR(50) CHECK (CHARINDEX('@', Email) > 0),
    Refferal CHAR(11) NULL CHECK (Refferal IS NULL OR (LEN(Refferal) = 11 AND ISNUMERIC(Refferal) = 1))
);

CREATE TABLE dbo.ProcedureTable(
	ID CHAR(10) PRIMARY KEY,
	ProcedureType VARCHAR(30) NOT NULL,
	Price MONEY NOT NULL,
	Duration FLOAT NOT NULL
);

CREATE TABLE dbo.ProductTable(
	ID CHAR(10) PRIMARY KEY,
	ProductName CHAR(20) NOT NULL
);

CREATE TABLE dbo.Procedure_Product(
    ProcedureProductID CHAR(10) PRIMARY KEY,
	Procedure_ID CHAR(10) REFERENCES dbo.ProcedureTable ON UPDATE CASCADE,
	Product_ID CHAR(10) REFERENCES dbo.ProductTable ON UPDATE CASCADE,
	Quantity INT CHECK(Quantity > 0),
);

CREATE TABLE dbo.StaffMember (
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

CREATE TABLE dbo.Appointment(
	ID CHAR(10) PRIMARY KEY,
	AppointmentDate DATETIME CHECK(YEAR(AppointmentDate) > 1999) NOT NULL,
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