use BookingManagementDW
UPDATE A
SET A.FK_Client = (SELECT TOP 1 PESEL
                   FROM dbo.ClientDT
                   WHERE Is_current = 1) 
FROM [Booking management system].dbo.Appointment A
WHERE A.FK_Client IN (
    SELECT PESEL
    FROM dbo.ClientDT
    WHERE Is_current = 0
);

UPDATE A
SET A.FK_StaffMember = (SELECT TOP 1 PESEL
                        FROM dbo.Staff_memberDT
                        WHERE Is_current = 1) 
FROM [Booking management system].dbo.Appointment A
WHERE A.FK_StaffMember IN (
    SELECT PESEL
    FROM dbo.Staff_memberDT
    WHERE Is_current = 0
);
