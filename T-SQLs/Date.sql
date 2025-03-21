USE BookingManagementDW;

DECLARE @batchSize INT = 1000; -- Number of rows to insert per batch
DECLARE @startDate DATE = '1999-01-01';
DECLARE @endDate DATE = '2024-12-12';
DECLARE @currentEndDate DATE;

WHILE @startDate <= @endDate
BEGIN
    SET @currentEndDate = DATEADD(DAY, @batchSize - 1, @startDate);
    
    IF @currentEndDate > @endDate
        SET @currentEndDate = @endDate;

    INSERT INTO DateDT (
        Date,
        Year,
        Month,
        Month_number,
        Day_number,
        Day_of_week,
        Holiday
    )
    SELECT DISTINCT
        CurrentDate AS Date,
        YEAR(CurrentDate) AS Year,
        CASE MONTH(CurrentDate)
            WHEN 1 THEN 'January'
            WHEN 2 THEN 'February'
            WHEN 3 THEN 'March'
            WHEN 4 THEN 'April'
            WHEN 5 THEN 'May'
            WHEN 6 THEN 'June'
            WHEN 7 THEN 'July'
            WHEN 8 THEN 'August'
            WHEN 9 THEN 'September'
            WHEN 10 THEN 'October'
            WHEN 11 THEN 'November'
            WHEN 12 THEN 'December'
        END AS Month,
        MONTH(CurrentDate) AS Month_number,
        DAY(CurrentDate) AS Day_number,
        DATENAME(WEEKDAY, CurrentDate) AS Day_of_week,
        CASE
            WHEN DATENAME(WEEKDAY, CurrentDate) IN ('Saturday', 'Sunday') THEN 'Yes'
            ELSE 'No'
        END AS Holiday
    FROM (
        SELECT DATEADD(DAY, Number, @startDate) AS CurrentDate
        FROM master.dbo.spt_values
        WHERE type = 'P' AND Number BETWEEN 0 AND DATEDIFF(DAY, @startDate, @currentEndDate)
    ) AS DateRange;

    SET @startDate = DATEADD(DAY, @batchSize, @startDate);
END;
