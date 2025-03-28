WITH class_avg AS (
    SELECT
        c.class,
        AVG(r.position) AS avg_position
    FROM
        Cars c
        JOIN Results r ON c.name = r.car
    GROUP BY
        c.class
),
min_avg AS (
    SELECT MIN(avg_position) AS min_avg
    FROM class_avg
),
selected_classes AS (
    SELECT class
    FROM class_avg
    WHERE avg_position = (SELECT min_avg FROM min_avg)
)
SELECT
    cars.name AS car_name,
    classes.class AS car_class,
    AVG(results.position) AS average_position,
    COUNT(results.race) AS race_count,
    classes.country AS car_country,
    (SELECT COUNT(*)
     FROM Cars c2
     JOIN Results r2 ON c2.name = r2.car
     WHERE c2.class = classes.class) AS total_races
FROM
    Cars cars
    JOIN Classes classes ON cars.class = classes.class
    JOIN Results results ON cars.name = results.car
WHERE
    classes.class IN (SELECT class FROM selected_classes)
GROUP BY
    cars.name, classes.class, classes.country;
