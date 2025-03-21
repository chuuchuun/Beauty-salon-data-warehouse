use [Booking management system]

BULK INSERT dbo.Client
FROM 'C:\Users\alla\Desktop\hd\task5\database\data\Client.bulk'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);


BULK INSERT dbo.ProcedureTable
FROM 'C:\Users\alla\Desktop\hd\task5\database\data\ProcedureTable.bulk'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);

BULK INSERT dbo.ProductTable
FROM 'C:\Users\alla\Desktop\hd\task5\database\data\ProductTable.bulk'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);

BULK INSERT dbo.Procedure_Product
FROM 'C:\Users\alla\Desktop\hd\task5\database\data\Procedure_Product.bulk'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);

BULK INSERT dbo.StaffMember
FROM 'C:\Users\alla\Desktop\hd\task5\database\data\StaffMember.bulk'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);

BULK INSERT dbo.Appointment
FROM 'C:\Users\alla\Desktop\hd\task5\database\data\Appointment.bulk'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);

