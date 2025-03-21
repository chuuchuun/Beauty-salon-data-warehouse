DROP TABLE IF EXISTS dbo.StaffExperienceSalary;
DROP TABLE IF EXISTS dbo.StaffExperienceSalaryWithExperience;
use BookingManagementDW
GO

CREATE TABLE dbo.StaffExperienceSalary (
    ID CHAR(11) CHECK (LEN(ID) = 11 AND ISNUMERIC(ID) = 1) PRIMARY KEY,
    DateOfStarting DATE,
    Salary MONEY NOT NULL,
    Education VARCHAR(30)
);

BULK INSERT dbo.StaffExperienceSalary
FROM 'C:\Users\alla\Desktop\hd\task5\database\data\staff_members_details.csv'  -- Adjust to the actual file path
WITH (
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n', 
    FIRSTROW = 2          
);

SELECT 
    ID,
    DateOfStarting,
    Salary,
    Education,
    DATEDIFF(YEAR, DateOfStarting, GETDATE()) AS Experience_years
INTO dbo.StaffExperienceSalaryWithExperience
FROM dbo.StaffExperienceSalary;

USE BookingManagementDW; 
GO

IF OBJECT_ID('vETLStaff', 'V') IS NOT NULL DROP VIEW vETLStaff;
GO

CREATE VIEW vETLStaff AS
SELECT 
    Staff_ID = NULL,
    PESEL = S.ID,
    Name_and_surname = CONCAT(S.FirstName, ' ', S.Surname),
    Phone_number = S.PhoneNumber,
    Email = S.Email,
    Qualification = S.Qualification,
    Experience_years_category = CASE 
    WHEN DATEDIFF(YEAR, ES.DateOfStarting, '2021-02-02') < 1 THEN 'Under 1 year'
    WHEN DATEDIFF(YEAR, ES.DateOfStarting, '2021-01-01') >= 1 AND DATEDIFF(YEAR, ES.DateOfStarting, '2021-01-01') < 3 THEN 'Between 1 and 3 years'
    WHEN DATEDIFF(YEAR, ES.DateOfStarting, '2021-01-01') >= 3 AND DATEDIFF(YEAR, ES.DateOfStarting, '2021-01-01') < 5 THEN 'Between 3 and 5 years'
    ELSE 'More than 5 years'
END,

    Education = ES.Education,
    Salary_category = CASE 
        WHEN ES.Salary < 1000 THEN 'Under 1000 USD'
        WHEN ES.Salary >= 1000 AND ES.Salary < 2000 THEN 'Between 1000 and 2000 USD'
        WHEN ES.Salary >= 2000 AND ES.Salary < 5000 THEN 'Between 2000 and 5000 USD'
        ELSE 'More than 5000 USD'
    END,
    Is_current = 1 
FROM [Booking management system].dbo.StaffMember S
LEFT JOIN dbo.StaffExperienceSalaryWithExperience ES
ON S.ID = ES.ID;
GO

MERGE INTO Staff_memberDT AS Target
USING vETLStaff AS Source
ON Target.PESEL = Source.PESEL AND Target.Is_current = 1
WHEN MATCHED AND 
    (Target.Name_and_surname != Source.Name_and_surname 
    OR Target.Phone_number != Source.Phone_number 
    OR Target.Email != Source.Email
    OR Target.Qualification != Source.Qualification
    OR Target.Experience_years_category != Source.Experience_years_category
    OR Target.Education != Source.Education
    OR Target.Salary_category != Source.Salary_category) THEN
    UPDATE SET Target.Is_current = 0;

INSERT INTO Staff_memberDT (PESEL, Name_and_surname, Phone_number, Email, Qualification, 
                            Experience_years_category, Education, Salary_category, Is_current)
SELECT Source.PESEL, Source.Name_and_surname, Source.Phone_number, Source.Email, 
       Source.Qualification, Source.Experience_years_category, Source.Education, 
       Source.Salary_category, 1
FROM vETLStaff AS Source
WHERE NOT EXISTS (
    SELECT 1
    FROM Staff_memberDT AS Target
    WHERE Target.PESEL = Source.PESEL AND Target.Is_current = 1
);
GO