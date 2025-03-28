WITH CarStats AS (
    SELECT
        Cars.name AS car_name,
        Cars.class AS car_class,
        AVG(Results.position) AS average_position,
        COUNT(Results.race) AS race_count,
        Classes.country AS car_country
    FROM Cars
    JOIN Results ON Cars.name = Results.car
    JOIN Classes ON Cars.class = Classes.class
    GROUP BY Cars.name, Cars.class, Classes.country
    HAVING AVG(Results.position) > 3.0
),
ClassCounts AS (
    SELECT
        car_class,
        COUNT(*) AS low_avg_count
    FROM CarStats
    GROUP BY car_class
),
MaxCount AS (
    SELECT MAX(low_avg_count) AS max_count
    FROM ClassCounts
)
SELECT
    cs.car_name,
    cs.car_class,
    cs.average_position,
    cs.race_count,
    cs.car_country
FROM CarStats cs
JOIN ClassCounts cc ON cs.car_class = cc.car_class
JOIN MaxCount mc ON cc.low_avg_count = mc.max_count
ORDER BY cc.low_avg_count DESC;
