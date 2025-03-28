select
    c.name AS car_name,
    c.class as car_class,
    AVG(r.position) AS average_position,
    COUNT(r.race) AS races_count
FROM
    Cars c
JOIN Results r ON c.name = r.car
GROUP BY
    c.class, c.name
HAVING
    AVG(r.position) = (
        SELECT MIN(avg_pos)
        FROM (
            SELECT
                c2.class,
                AVG(r2.position) AS avg_pos
            FROM
                Cars c2
            JOIN Results r2 ON c2.name = r2.car
            WHERE
                c2.class = c.class
            GROUP BY
                c2.name
        ) AS class_avg
    )
ORDER BY
    average_position;
