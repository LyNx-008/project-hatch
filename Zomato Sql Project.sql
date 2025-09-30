CREATE TABLE if not exists Users (
    user_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(50),
    age_group VARCHAR(10),
    sign_up_date DATE
);
CREATE TABLE Restaurants (
    restaurant_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(50),
    cuisine_type VARCHAR(50),
    avg_rating DECIMAL(2,1),
    avg_delivery_time INT
); 
CREATE TABLE Orders (
    order_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10),
    restaurant_id VARCHAR(10),
    order_amount INT,
    order_time timestamp,
    is_cancelled VARCHAR(5),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);
CREATE TABLE Reviews (
    review_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10),
    restaurant_id VARCHAR(10),
    rating INT,
    review_text TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

 SELECT age_group, COUNT(order_id) AS total_orders
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY age_group
ORDER BY total_orders DESC;

SELECT cuisine_type,COUNT(order_id) as total_orders from  restaurants r
join orders o on r.restaurant_id=o.restaurant_id
group by r.cuisine_type 
order by total_orders desc ;

SELECT r.location AS city, COUNT(o.is_cancelled) AS cancellations
FROM Orders o
JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.is_cancelled = 'Yes'
GROUP BY r.location
ORDER BY cancellations DESC;

SELECT r.name AS restaurant_name, SUM(o.order_amount) AS total_revenue
FROM Orders o
JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.is_cancelled = 'No'
GROUP BY r.name
ORDER BY total_revenue DESC;

SELECT r.cuisine_type, AVG(rv.rating) AS avg_user_rating
FROM Reviews rv
JOIN Restaurants r ON rv.restaurant_id = r.restaurant_id
GROUP BY r.cuisine_type
ORDER BY avg_user_rating DESC;

SELECT r.name, r.avg_delivery_time, AVG(rv.rating) AS avg_user_rating
FROM Restaurants r
JOIN Reviews rv ON r.restaurant_id = rv.restaurant_id
GROUP BY r.name, r.avg_delivery_time
ORDER BY r.avg_delivery_time DESC;

SELECT DATE(order_time) AS order_date, COUNT(*) AS total_orders
FROM Orders
GROUP BY order_date
ORDER BY order_date;


SELECT r.name,COUNT(CASE WHEN o.is_cancelled = 'Yes' THEN 1 END) * 100.0 / COUNT(*) AS cancellation_rate
FROM Orders o
JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.name
ORDER BY cancellation_rate DESC;