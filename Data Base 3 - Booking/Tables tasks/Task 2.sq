WITH bookings_analysis AS (
    SELECT 
        c.ID_customer,
        c.name,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS total_hotels,
        SUM(r.price * (b.check_out_date - b.check_in_date)) AS total_spent
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    JOIN 
        Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY 
        c.ID_customer, c.name
    HAVING 
        COUNT(b.ID_booking) > 2 AND COUNT(DISTINCT h.ID_hotel) > 1
),
spending_analysis AS (
    SELECT 
        c.ID_customer,
        c.name,
        SUM(r.price * (b.check_out_date - b.check_in_date)) AS total_spent,
        COUNT(b.ID_booking) AS total_bookings
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    GROUP BY 
        c.ID_customer, c.name
    HAVING 
        SUM(r.price * (b.check_out_date - b.check_in_date)) > 500
)
SELECT 
    b.ID_customer,
    b.name,
    b.total_bookings,
    b.total_spent,
    b.total_hotels
FROM 
    bookings_analysis b
JOIN 
    spending_analysis s ON b.ID_customer = s.ID_customer
ORDER BY 
    b.total_spent ASC;
