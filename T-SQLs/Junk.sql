USE BookingManagementDW;

INSERT INTO JunkDT (Confirmation_type, Referral_flag)
SELECT DISTINCT
    A.ConfirmationType AS Confirmation_type,
    CASE 
        WHEN C.Refferal IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS Referral_flag
FROM [Booking management system].dbo.Appointment A
INNER JOIN [Booking management system].dbo.Client C
    ON A.FK_Client = C.ID;
