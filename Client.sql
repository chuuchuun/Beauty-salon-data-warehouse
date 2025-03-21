USE BookingManagementDW; -- Replace with your database name
GO

IF OBJECT_ID('vETLClient', 'V') IS NOT NULL DROP VIEW vETLClient;
GO

CREATE VIEW vETLClient AS
SELECT 
    Client_ID = NULL, -- Placeholder as this will be auto-generated in ClientDT
    PESEL = ID,
    Name_and_surname = CONCAT(FirstName, ' ', Surname),
    Phone_number = PhoneNumber,
    Email = Email,
    Is_current = 1 -- Assuming all records are current by default
FROM [Booking management system].dbo.Client;
GO

-- Example of a MERGE script to insert data from vETLClient into ClientDT
MERGE INTO ClientDT AS Target
USING vETLClient AS Source
ON Target.PESEL = Source.PESEL -- Check if the PESEL exists
WHEN MATCHED AND Target.Name_and_surname != Source.Name_and_surname THEN
    -- Update the current record's Is_current to 0
    UPDATE SET Target.Is_current = 0
WHEN NOT MATCHED BY TARGET THEN
    -- Insert the new client record if no match is found
    INSERT (PESEL, Name_and_surname, Phone_number, Email, Is_current)
    VALUES (Source.PESEL, Source.Name_and_surname, Source.Phone_number, Source.Email, Source.Is_current)
;
GO
