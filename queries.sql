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
INSERT INTO Users VALUES
 ('U001', 'Rahul Sinha', 'Delhi', '18-25', '2022-05-01'),
 ('U002', 'Aisha Khan', 'Mumbai', '26-35', '2022-03-12'),
 ('U003', 'Vikram Joshi', 'Bangalore', '18-25', '2022-08-10'),
 ('U004', 'Meera Das', 'Hyderabad', '36-45', '2023-01-15'),
 ('U005', 'Tushar Roy', 'Chennai', '26-35', '2022-07-22');

 INSERT INTO Restaurants VALUES ('R001', 'Spicy Kitchen', 'Delhi', 'North Indian', 4.3, 35);
INSERT INTO Restaurants VALUES ('R002', 'Sushi Point', 'Mumbai', 'Japanese', 4.7, 25);
INSERT INTO Restaurants VALUES ('R003', 'Dosa Delight', 'Bangalore', 'South Indian', 4.1, 30);
INSERT INTO Restaurants VALUES ('R004', 'Biryani House', 'Hyderabad', 'Mughlai', 3.8, 45);
INSERT INTO Restaurants VALUES ('R005', 'Pasta Plaza', 'Chennai', 'Italian', 4.5, 28);

INSERT INTO Orders VALUES
 ('O001', 'U001', 'R001', 250, '2023-07-01 13:15', 'No'),
 ('O002', 'U002', 'R002', 450, '2023-07-01 19:45', 'No'),
 ('O003', 'U003', 'R003', 300, '2023-07-02 08:45', 'Yes'),
 ('O004', 'U004', 'R004', 200, '2023-07-03 20:10', 'No'),
 ('O005', 'U005', 'R005', 350, '2023-07-04 14:30', 'Yes');

 INSERT INTO Reviews VALUES ('RV001', 'U001', 'R001', 4, 'Tasty food, on time'),
 ('RV002', 'U002', 'R002', 5, 'Amazing presentation'),
 ('RV003', 'U003', 'R003', 3, 'Too salty, late'),
 ('RV004', 'U004', 'R004', 4, 'Good portion, decent t,aste'),
 ('RV005', 'U005', 'R005', 2, 'Cold and bland');

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