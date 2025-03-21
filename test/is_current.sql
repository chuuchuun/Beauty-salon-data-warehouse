use BookingManagementDW

SELECT PESEL, COUNT(*) AS DuplicateCount
FROM dbo.ClientDT
GROUP BY PESEL
HAVING COUNT(*) > 1;

select * from Staff_memberDT
where PESEL = '00022044457'

select * from ClientDT
where PESEL = '95091330325'