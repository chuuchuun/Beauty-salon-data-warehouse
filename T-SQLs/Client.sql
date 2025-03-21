USE BookingManagementDW; -- Replace with your database name
GO

IF OBJECT_ID('vETLClient', 'V') IS NOT NULL DROP VIEW vETLClient;
GO

CREATE VIEW vETLClient AS
SELECT 
    Client_ID = NULL, 
    PESEL = C.ID,
    Name_and_surname = CONCAT(C.FirstName, ' ', C.Surname),
    Phone_number = C.PhoneNumber,
    Email = C.Email,
    Is_current = 1
FROM [Booking management system].dbo.Client C;
GO

MERGE INTO ClientDT AS Target
USING vETLClient AS Source
ON Target.PESEL = Source.PESEL AND Target.Is_current = 1 
WHEN MATCHED AND 
    (Target.Name_and_surname != Source.Name_and_surname 
    OR Target.Phone_number != Source.Phone_number 
    OR Target.Email != Source.Email) THEN
    UPDATE SET Target.Is_current = 0;

INSERT INTO ClientDT (PESEL, Name_and_surname, Phone_number, Email, Is_current)
SELECT Source.PESEL, Source.Name_and_surname, Source.Phone_number, Source.Email, 1
FROM vETLClient AS Source
WHERE NOT EXISTS (
    SELECT 1
    FROM ClientDT AS Target
    WHERE Target.PESEL = Source.PESEL AND Target.Is_current = 1
);
GO
