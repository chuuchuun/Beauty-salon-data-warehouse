USE BookingManagementDW; -- Replace with your database name
GO

IF OBJECT_ID('vETLProcedure', 'V') IS NOT NULL DROP VIEW vETLProcedure;
GO

CREATE VIEW vETLProcedure AS
SELECT 
    Procedure_ID = NULL, -- Placeholder as this will be auto-generated in ProcedureDT
    Procedure_type = ProcedureType,
    Duration_category = CASE 
        WHEN Duration < 0.5 THEN 'Under 30 minutes'
        WHEN Duration >= 0.5 AND Duration <= 1 THEN 'Between 30 minutes and 1 hour'
        WHEN Duration > 1 AND Duration <= 2 THEN 'Between 1 and 2 hours'
        ELSE 'More than 2 hours'
    END
FROM [Booking management system].dbo.ProcedureTable;
GO

-- Example of a MERGE script to insert data from vETLProcedure into ProcedureDT
MERGE INTO ProcedureDT AS Target
USING vETLProcedure AS Source
ON Target.Procedure_type = Source.Procedure_type
    AND Target.Duration_category = Source.Duration_category -- Avoid duplicates by type and duration category
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Procedure_type, Duration_category)
    VALUES (Source.Procedure_type, Source.Duration_category);
GO
