select v.maker, m.model from motorcycle m join vehicle v on v.model = m.model
where m.horsepower > 150 and m.price < 20000.00 and m.type = 'Sport'
