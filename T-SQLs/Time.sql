USE BookingManagementDW;

;WITH Hours AS (
    SELECT Number AS Hour
    FROM (VALUES 
        (0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12), 
        (13), (14), (15), (16), (17), (18), (19), (20), (21), (22), (23)
    ) AS H(Number)
),
Minutes AS (
    SELECT Number AS Minute
    FROM (VALUES 
        (0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12), 
        (13), (14), (15), (16), (17), (18), (19), (20), (21), (22), (23), 
        (24), (25), (26), (27), (28), (29), (30), (31), (32), (33), (34), 
        (35), (36), (37), (38), (39), (40), (41), (42), (43), (44), (45), 
        (46), (47), (48), (49), (50), (51), (52), (53), (54), (55), (56), 
        (57), (58), (59)
    ) AS M(Number)
),
TimeOfDay AS (
    SELECT 
        H.Hour,
        M.Minute,
        CASE 
            WHEN H.Hour BETWEEN 0 AND 8 THEN 'Between 0 and 8'
            WHEN H.Hour BETWEEN 9 AND 12 THEN 'Between 9 and 12'
            WHEN H.Hour BETWEEN 13 AND 15 THEN 'Between 13 and 15'
            WHEN H.Hour BETWEEN 16 AND 20 THEN 'Between 16 and 20'
            WHEN H.Hour BETWEEN 21 AND 23 THEN 'Between 21 and 23'
        END AS Time_of_day
    FROM Hours H
    CROSS JOIN Minutes M
)
INSERT INTO TimeDT (Hour, Minute, Time_of_day)
SELECT Hour, Minute, Time_of_day
FROM TimeOfDay;

