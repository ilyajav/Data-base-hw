SELECT
    car.name AS car_name,
    car.class AS car_class,
    AVG(res.position) AS average_position,
    COUNT(res.race) AS race_count,
    cls.country AS car_country
FROM
    Cars car
JOIN
    Results res ON car.name = res.car
JOIN
    Classes cls ON car.class = cls.class
WHERE
    (SELECT COUNT(*) FROM Cars c WHERE c.class = car.class) >= 2
GROUP BY
    car.name, car.class, cls.country
HAVING
    AVG(res.position) < (
        SELECT AVG(r.position)
        FROM Cars c
        JOIN Results r ON c.name = r.car
        WHERE c.class = car.class
    )
ORDER BY
    car.class,
    average_position ASC;
