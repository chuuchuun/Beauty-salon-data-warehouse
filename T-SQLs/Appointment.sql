 USE BookingManagementDW;

DROP TABLE IF EXISTS #ProcedureMapping;
DROP TABLE IF EXISTS #ProductMapping;

CREATE TABLE #ProcedureMapping (
    Procedure_ID CHAR(10) PRIMARY KEY,
    Mapped_ID INT IDENTITY(1,1)
);

INSERT INTO #ProcedureMapping (Procedure_ID)
SELECT DISTINCT ID
FROM [Booking management system].dbo.ProcedureTable;

CREATE TABLE #ProductMapping (
    Product_ID CHAR(10) PRIMARY KEY,
    Mapped_ID INT IDENTITY(1,1)
);

INSERT INTO #ProductMapping (Product_ID)
SELECT DISTINCT ID
FROM [Booking management system].dbo.ProductTable;

SELECT * FROM #ProductMapping;
MERGE INTO AppointmentFT AS target
USING (
    SELECT DISTINCT 
        ROW_NUMBER() OVER (
            PARTITION BY 
                C.Client_ID, 
                PM.Mapped_ID, 
                D.Date_ID, 
                COALESCE(t.Time_ID, 1), 
                PrM.Mapped_ID, 
                S.Staff_ID, 
                J.Junk_ID 
            ORDER BY A.AppointmentDate
        ) AS RowNum,
        C.Client_ID,
        PM.Mapped_ID AS Procedure_ID,
        (SELECT TOP 1 Date_ID FROM DateDT WHERE Date = DATEADD(DAY, -1, CAST(A.AppointmentDate AS DATE))) AS Creation_date_ID,
        D.Date_ID AS Appointment_date_ID,
        S.Staff_ID,
        t.Time_ID AS Time_ID,
        PrM.Mapped_ID AS Product_ID,
        A.Rate AS Rating,
        PP.Quantity AS Product_quantity,
        PT.Price AS Procedure_price,
        J.Junk_ID
    FROM 
        [Booking management system].dbo.Appointment A
    JOIN 
        dbo.ClientDT C ON A.FK_Client = C.PESEL 
    JOIN 
        [Booking management system].dbo.Procedure_Product PP ON A.FK_Procedure_Product = PP.ProcedureProductID
    JOIN 
        [Booking management system].dbo.ProcedureTable PT ON PP.Procedure_ID = PT.ID
    JOIN 
        #ProcedureMapping PM ON PP.Procedure_ID = PM.Procedure_ID
    JOIN 
        [Booking management system].dbo.ProductTable PrT ON PP.Product_ID = PrT.ID
    JOIN 
        #ProductMapping PrM ON PP.Product_ID = PrM.Product_ID
    JOIN 
        dbo.Staff_memberDT S ON A.FK_StaffMember = S.PESEL
    JOIN 
        dbo.DateDT D ON CAST(A.AppointmentDate AS DATE) = D.Date
    LEFT JOIN TimeDT t 
        ON DATEPART(HOUR, CAST(a.AppointmentDate AS DATETIME)) = t.Hour 
       AND DATEPART(MINUTE, CAST(a.AppointmentDate AS DATETIME)) = t.Minute
    JOIN 
        dbo.JunkDT J ON A.ConfirmationType = J.Confirmation_type
    WHERE 
        A.AppointmentDate IS NOT NULL
) AS source
ON (
    target.Client_ID = source.Client_ID
    AND target.Procedure_ID = source.Procedure_ID
    AND target.Creation_date_ID = source.Creation_date_ID
    AND target.Appointment_date_ID = source.Appointment_date_ID
    AND target.Staff_member_ID = source.Staff_ID
    AND target.Time_ID = source.Time_ID
    AND target.Product_ID = source.Product_ID
    AND target.Junk_ID = source.Junk_ID
)
WHEN NOT MATCHED BY TARGET AND RowNum = 1 THEN
    INSERT (Client_ID, Procedure_ID, Creation_date_ID, Appointment_date_ID, Staff_member_ID, Time_ID, Product_ID, Rating, Product_quantity, Procedure_price, Junk_ID)
    VALUES (source.Client_ID, source.Procedure_ID, source.Creation_date_ID, source.Appointment_date_ID, source.Staff_ID, source.Time_ID, source.Product_ID, source.Rating, source.Product_quantity, source.Procedure_price, source.Junk_ID);
