-- 1
-- An e-commerce company, has observed a notable surge in return orders recently. They suspect that a specific group of customers may be responsible for a significant portion of these returns. To address this issue, their initial goal is to identify customers who have returned more than 50% of their orders. This way, they can proactively reach out to these customers to gather feedback.
-- Write an SQL to find list of customers along with their return percent (Round to 2 decimal places), display the output in ascending order of customer name.
CREATE TABLE company.orders (
    customer_name VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    order_id INT PRIMARY KEY,
    sales INT NOT NULL
);
CREATE TABLE company.returns (
    order_id INT PRIMARY KEY,
    return_date DATE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
INSERT INTO orders (customer_name, order_date, order_id, sales) VALUES
('Alice', '2025-01-05', 101, 500),
('Alice', '2025-02-10', 102, 300),
('Alice', '2025-03-15', 103, 450),
('Bob',   '2025-01-08', 104, 700),
('Bob',   '2025-02-20', 105, 200),
('Charlie','2025-01-12', 106, 400),
('Charlie','2025-02-18', 107, 600),
('Charlie','2025-03-05', 108, 350),
('Charlie','2025-04-01', 109, 250),
('Diana', '2025-01-25', 110, 800);
select * from company.orders;

INSERT INTO returns (order_id, return_date) VALUES
(101, '2025-01-20'), 
(102, '2025-02-15'),  
(105, '2025-02-25'), 
(106, '2025-01-30'),
(107, '2025-02-25'),
(109, '2025-04-05');
select * from company.returns;


select customer_name,
ROUND (
(count(r.order_id) * 100/ count(o.order_id)),2
) as return_percent
from company.orders o
left join company.returns r
on r.order_id= o.order_id
group by o.customer_name
having (count(r.order_id) * 1.0/ count(o.order_id))>0.5
order by customer_name asc;

-- 2
-- You are provided with a table named Products containing information about various products, including their names and prices. Write a SQL query to count number of products in each category based on its price into three categories below. Display the output in descending order of no of products.
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(20),
    price INT
);
INSERT INTO Products (product_id, product_name, price) VALUES
(1, 'Pen', 50),
(2, 'Notebook', 120),
(3, 'Chair', 600),
(4, 'Table', 450),
(5, 'Eraser', 20),
(6, 'Laptop', 1200),
(7, 'Book', 80),
(8, 'Smartphone', 700),
(9, 'Pencil', 30),
(10, 'Bag', 300);

SELECT 
    CASE 
        WHEN price < 100 THEN 'Low Price'
        WHEN price BETWEEN 100 AND 500 THEN 'Medium Price'
        ELSE 'High Price'
    END AS price_category,
    COUNT(*) AS no_of_products
FROM Products
GROUP BY 
    CASE 
        WHEN price < 100 THEN 'Low Price'
        WHEN price BETWEEN 100 AND 500 THEN 'Medium Price'
        ELSE 'High Price'
    END
ORDER BY no_of_products DESC;

-- 3
-- LinkedIn is a professional social networking app. They want to give top voice badge to their best creators to encourage them to create more quality content. A creator qualifies for the badge if he/she satisfies following criteria.
-- 1- Creator should have more than 50k followers.
-- 2- Creator should have more than 100k impressions on the posts that they published in the month of Dec-2023.
-- 3- Creator should have published atleast 3 posts in Dec-2023.
-- Write a SQL to get the list of top voice creators name along with no of posts and impressions by them in the month of Dec-2023.
CREATE TABLE company.creators (
    creator_id INT PRIMARY KEY,
    creator_name VARCHAR(20) NOT NULL,
    followers INT NOT NULL
);
CREATE TABLE company.posts (
    post_id VARCHAR(3) PRIMARY KEY,
    creator_id INT NOT NULL,
    publish_date DATE NOT NULL,
    impressions INT NOT NULL,
    FOREIGN KEY (creator_id) REFERENCES creators(creator_id)
);
INSERT INTO company.creators (creator_id, creator_name, followers) VALUES
(1, 'Alice', 60000),
(2, 'Bob', 45000),
(3, 'Charlie', 120000),
(4, 'Diana', 80000);
select * from company.creators;
INSERT INTO company.posts (post_id, creator_id, publish_date, impressions) VALUES
('P01', 1, '2023-12-05', 40000),
('P02', 1, '2023-12-12', 35000),
('P03', 1, '2023-12-20', 30000),
('P04', 2, '2023-12-03', 50000),
('P05', 2, '2023-12-15', 30000),
('P06', 3, '2023-12-01', 45000),
('P07', 3, '2023-12-10', 40000),
('P08', 3, '2023-12-18', 35000),
('P09', 3, '2023-12-25', 30000),
('P10', 4, '2023-12-05', 20000),
('P11', 4, '2023-12-12', 30000),
('P12', 4, '2023-11-28', 15000); 
select * from company.posts;

select c.creator_name,
count(p.post_id)as posts,
SUM(p.impressions)as imp_id 
from company.creators c
left join company.posts p
on c.creator_id=p.creator_id
WHERE p.publish_date BETWEEN '2023-12-01' AND '2023-12-25'
group by c.creator_name,c.followers
having(
count(p.post_id) >3
and sum(p.impressions)>100000
and c.followers>50000)
ORDER BY c.creator_name ASC;
;
-- 4
 -- An e-commerce company want to start special reward program for their premium customers.  The customers who have placed a greater number of orders than the average number of orders placed by customers are considered as premium customers.
-- Write an SQL to find the list of premium customers along with the number of orders placed by each of them, display the results in highest to lowest no of orders.
DROP TABLE if exists company.order1;
CREATE TABLE company.order1 (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_name VARCHAR(20) NOT NULL,
    sales INT NOT NULL
);

INSERT INTO order1 (order_id, order_date, customer_name, sales) VALUES
(101, '2025-01-05', 'Alice', 500),
(102, '2025-01-10', 'Alice', 300),
(103, '2025-01-15', 'Alice', 450),
(104, '2025-02-01', 'Bob', 700),
(105, '2025-02-05', 'Bob', 200),
(106, '2025-02-10', 'Charlie', 400),
(107, '2025-02-15', 'Charlie', 600),
(108, '2025-02-20', 'Charlie', 350),
(109, '2025-03-01', 'Diana', 250),
(110, '2025-03-05', 'Diana', 450),
(111, '2025-03-10', 'Eve', 300);
select * from company.order1;

select customer_name,
count(order_id) as no_of_orders,
max(order_id) as `highest order`,
min(order_id) as `lowest order`
from company.order1
group by customer_name;


-- 6
-- You have access to data from an electricity billing system, detailing the electricity usage and cost for specific households over billing periods in the years 2023 and 2024. Your objective is to present the total electricity consumption, total cost and average monthly consumption for each household per year display the output in ascending order of each household id & year of the bill.
CREATE TABLE company.electricity_bill (
    bill_id INT PRIMARY KEY,
    household_id INT NOT NULL,
    billing_period VARCHAR(7) NOT NULL,  -- Format: 'YYYY-MM'
    consumption_kwh DECIMAL(10,2) NOT NULL,
    total_cost DECIMAL(10,2) NOT NULL
);
INSERT INTO electricity_bill (bill_id, household_id, billing_period, consumption_kwh, total_cost) VALUES
(1, 101, '2023-01', 320.50, 48.08),
(2, 101, '2023-02', 280.75, 42.12),
(3, 101, '2023-03', 310.20, 46.53),
(4, 102, '2023-01', 450.00, 67.50),
(5, 102, '2023-02', 470.00, 70.50),
(6, 101, '2024-01', 330.00, 49.50),
(7, 101, '2024-02', 340.00, 51.00),
(8, 102, '2024-01', 460.00, 69.00),
(9, 102, '2024-02', 480.00, 72.00),
(10, 103, '2023-01', 250.00, 37.50),
(11, 103, '2023-02', 260.00, 39.00),
(12, 103, '2024-01', 270.00, 40.50);
select * from company.electricity_bill;


select household_id,
left(billing_period,4) as bill_year,
sum(consumption_kwh) as total_consumption,
sum(total_cost) as full_cost,
avg(consumption_kwh) as average_consumption
from company.electricity_bill
group by household_id,left(billing_period,4)
order by household_id,bill_year;

-- 8
-- Imagine you're working for a library and you're tasked with generating a report on the borrowing habits of patrons. You have two tables in your database: Books and Borrowers.
-- Write an SQL to display the name of each borrower along with a comma-separated list of the books they have borrowed in alphabetical order, display the output in ascending order of Borrower Name.
CREATE TABLE company.Books (
    BookID INT PRIMARY KEY,
    BookName VARCHAR(30),
    Genre VARCHAR(20)
);
INSERT INTO company.Books VALUES
(1, 'The Great Gatsby', 'Fiction'),
(2, 'To Kill a Mockingbird', 'Fiction'),
(3, '1984', 'Dystopian'),
(4, 'Pride and Prejudice', 'Romance'),
(5, 'The Hobbit', 'Fantasy'),
(6, 'Moby Dick', 'Adventure');
select* from company.books;
CREATE TABLE company.Borrowers (
    BorrowerID INT PRIMARY KEY,
    BorrowerName VARCHAR(10),
    BookID INT,
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

INSERT INTO company.Borrowers VALUES
(1, 'Alice', 1),
(2, 'Alice', 3),
(3, 'Alice', 5),
(4, 'Bob', 2),
(5, 'Bob', 4),
(6, 'Charlie', 6),
(7, 'Charlie', 1),
(8, 'David', 5);
select * from company.borrowers;

select borrowername, 
group_concat(bookname)
-- In MySQL: GROUP_CONCAT(BookName ORDER BY BookName SEPARATOR ', ')
from company.borrowers 
join company.books
on borrowers.bookid=books.bookid
group by borrowername
order by borrowername;
-- 9
-- Flipkart wants to build a very important business metrics where they want to track on daily basis how many new and repeat customers are purchasing products from their website. A new customer is defined when he purchased anything for the first time from the website and repeat customer is someone who has done at least one purchase in the past.
-- Display order date , new customers , repeat customers  in ascending order of repeat customers.
drop table if exists orders2;
CREATE TABLE orders2 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);
INSERT INTO orders2(order_id, customer_id, order_date) VALUES
(1, 101, '2024-01-05'), -- First order of 101
(2, 102, '2024-01-06'), -- First order of 102
(3, 101, '2024-02-01'), -- Repeat customer 101
(4, 103, '2024-02-02'), -- First order of 103
(5, 102, '2024-03-10'), -- Repeat customer 102
(6, 104, '2024-03-15'), -- First order of 104
(7, 101, '2024-03-20'), -- Repeat customer 101
(8, 105, '2024-03-25'), -- First order of 105
(9, 102, '2024-04-01'), -- Repeat customer 102
(10, 104, '2024-04-05');

select order_date,
sum(distinct customer_id) as new_customer,
sum(customer_id) as repeat_customer
from orders2
group by order_date
order by new_customer,repeat_customer asc;

-- 10
-- -- Sachin Tendulkar - Also known as little master. You are given runs scored by Sachin in his first 10 matches. You need to write an SQL to get match number when he completed 500 runs and his batting average at the end of 10 matches. Batting Average = (Total runs scored) / (no of times batsman got out)
CREATE TABLE sachin (
    match_no INT PRIMARY KEY,
    runs_scored INT,
    status VARCHAR(10)   -- 'out' or 'notout'
);
INSERT INTO sachin (match_no, runs_scored, status) VALUES
(1, 36, 'out'),
(2, 59, 'out'),
(3, 24, 'out'),
(4, 80, 'out'),
(5, 120, 'out'),
(6, 25, 'notout'),
(7, 55, 'out'),
(8, 45, 'out'),
(9, 75, 'out'),
(10, 110, 'out');

select
(select min(match_no) as match_when_500
from
(select match_no,
sum(runs_scored) over (order by match_no) as cum_runs
from sachin
 ) as t
where cum_runs>=500) as match_when_500,
round(sum(runs_scored)*1.0/sum(case when status='out' then 1 else 0 end),2) as battling_average
from sachin;

-- 11
-- You are provided with two tables: Students and Grades. Write a SQL query to find students who have higher grade in Math than the average grades of all the students together in Math. Display student name and grade in Math order by grades.
drop table if exists students;
CREATE TABLE Students (
    student_id INT,
    student_name VARCHAR(50),
    class_id INT
);

INSERT INTO Students (student_id, student_name, class_id) VALUES
(1, 'John Doe', 1),
(2, 'Jane Smith', 2),
(3, 'Alice Johnson', 1),
(4, 'Bob Brown', 3),
(5, 'Emily Clark', 2),
(6, 'Michael Lee', 1),
(7, 'Sarah Taylor', 3);

drop table if exists grades;
CREATE TABLE Grades (
    student_id INT,
    subject VARCHAR(20),
    grade INT
);

INSERT INTO Grades (student_id, subject, grade) VALUES
(1, 'Math', 85),
(2, 'Math', 78),
(3, 'Math', 92),
(4, 'Math', 79),
(5, 'Math', 88),
(6, 'Math', 95),
(7, 'Math', 83);
select student_name,grade
from students s
join grades g on 
s.student_id=g.student_id
where g.subject='math'
and g.grade>
 (select avg (grade)
  from grades
  where subject ='math')
order by g.grade;

-- 12
-- You are provided with data from a food delivery service called Deliveroo. Each order has details about the delivery time, the rating given by the customer, and the total cost of the order. Write an SQL to find customer with highest total expenditure. Display customer id and total expense by him/her.

drop table if exists orders1;
CREATE TABLE orders1 (
    order_id INT,
    customer_id INT,
    restaurant_id INT,
    delivery_time INT,
    total_cost INT
);

INSERT INTO orders1 (order_id, customer_id, restaurant_id, delivery_time, total_cost) VALUES
(1, 101, 201, 30, 2550),
(2, 102, 202, 40, 3000),
(3, 101, 203, 25, 1575),
(4, 103, 201, 50, 2200),
(5, 104, 202, 45, 1850),
(6, 105, 204, 35, 2725),
(7, 106, 203, 20, 1600);

select year(business_date) as first_year ,
count(distinct city_id) as new_city
from business_operations
group by year(business_date)
order by first_year asc;


-- 13
--  TCS wants to award employees based on number of projects completed by each individual each month. Write an SQL to find best employee for each month along with number of projects completed by him/her in that month, display the output in descending order of number of completed projects.
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    employee_name VARCHAR(10),
    project_completion_date DATE
);
INSERT INTO projects (project_id, employee_name, project_completion_date) VALUES
(1, 'Alice', '2025-01-10'),
(2, 'Bob', '2025-01-15'),
(3, 'Alice', '2025-01-20'),
(4, 'Charlie', '2025-02-05'),
(5, 'Alice', '2025-02-12'),
(6, 'Bob', '2025-02-15'),
(7, 'Bob', '2025-02-20'),
(8, 'Charlie', '2025-02-25'),
(9, 'Alice', '2025-03-05');
select p1.employee_name,
count(project_id) as project,
MONTH(project_completion_date) as months
from projects p1
group by p1.employee_name, MONTH(project_completion_date)
having count(p1.project_id) in 
(select max(project)
from
(select p2.employee_name, MONTH(project_completion_date) as monthno,count(project_id) as project
from projects p2
group by p2.employee_name,monthno) as t
where months=monthno);

-- 14
-- Write a query to find workaholics employees. Workaholics are those who satisfy at least one of the given criterions: 1- Worked for more than 8 hours a day for at least 3 days in a week. 2- worked for more than 10 hours a day for at least 2 days in a week. You are given the login and logout timings of all the employees for a given week. Write a SQL to find all the workaholic employees along with the criterion that they are satisfying (1,2 or both), display it in the order of increasing employee id
drop table if exists employees;
CREATE TABLE employees (
    emp_id INT,
    login DATETIME,
    logout DATETIME
);
INSERT INTO employees (emp_id, login, logout) VALUES
(1, '2025-08-25 09:00:00', '2025-08-25 18:30:00'),
(1, '2025-08-26 09:00:00', '2025-08-26 17:30:00'),
(1, '2025-08-27 09:00:00', '2025-08-27 19:30:00'),
(1, '2025-08-28 09:00:00', '2025-08-28 20:00:00'),
(2, '2025-08-25 10:00:00', '2025-08-25 18:00:00'),
(2, '2025-08-26 09:30:00', '2025-08-26 21:30:00'),
(2, '2025-08-27 09:00:00', '2025-08-27 19:30:00'),
(3, '2025-08-25 08:00:00', '2025-08-25 16:00:00');

select emp_id,
concat(
case when sum(case when TIMESTAMPDIFF(HOUR,login,logout) >8 then 1 else 0 end)>=3 then '1' else '' end,
case when sum(case when TIMESTAMPDIFF(HOUR,login,logout) >10 then 2 else 0 end)>=2 then '2' else '' end
) as criterion
from employees
group by emp_id
having criterion <> ''
order by emp_id asc;

-- 17
-- Amazon is expanding their pharmacy business to new cities every year. You are given a table of business operations where you have information about cities where Amazon is doing operations along with the business date information.
CREATE TABLE business_operations (
    business_date DATE,
    city_id INT
);
INSERT INTO business_operations (business_date, city_id) VALUES
('2020-03-15', 101),
('2020-07-20', 102),
('2020-11-05', 103),
('2021-01-10', 104),
('2021-04-12', 105),
('2021-09-18', 102), -- city 102 already existed, not new
('2022-02-22', 106),
('2022-05-13', 107),
('2022-09-07', 108),
('2023-03-19', 109),
('2023-08-25', 110),
('2024-01-30', 111),
('2024-05-21', 107); -- repeat city

SELECT 
    YEAR(first_date) AS year,
    COUNT(city_id) AS new_cities
FROM (
    SELECT 
        city_id,
        MIN(business_date) AS first_date
    FROM business_operations
    GROUP BY city_id
) AS city_first_entry
GROUP BY YEAR(first_date)
ORDER BY YEAR(first_date);

-- 31
-- You are given the data of employees along with their salary and department. Write an SQL to find list of employees who have salary greater than average employee salary of the company.  However, while calculating the company average salary to compare with an employee salary do not consider salaries of that employee's department, display the output in ascending order of employee ids.
drop table if exists employee;
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    salary INT,
    department VARCHAR(15)
);

INSERT INTO employee (emp_id, salary, department) VALUES
(100, 40000, 'Analytics'),
(101, 30000, 'Analytics'),
(102, 50000, 'Analytics'),
(103, 45000, 'Engineering'),
(104, 48000, 'Engineering'),
(105, 51000, 'Engineering'),
(106, 46000, 'Science'),
(107, 38000, 'Science'),
(108, 37000, 'Science'),
(109, 42000, 'Analytics'),
(110, 55000, 'Engineering');

SELECT e.emp_id, e.salary, e.department
FROM employee e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employee
    WHERE department <> e.department
)
ORDER BY e.emp_id;


-- 34
-- You are given the table of employee details. Write an SQL to find details of employee with salary more than their manager salary but they joined the company after the manager joined.
-- Display employee name, salary and joining date along with their manager's salary and joining date, sort the output in ascending order of employee name.
-- Please note that manager id in the employee table referring to emp id of the same table.
drop table if exists employee;
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    joining_date DATE,
    salary INT,
    manager_id INT
);


INSERT INTO employee (emp_id, emp_name, joining_date, salary, manager_id) VALUES
(1, 'Ankit', '2021-01-01', 10000, 4),
(2, 'Mohit', '2022-05-01', 15000, 5),
(3, 'Vikas', '2023-06-01', 10000, 4),
(4, 'Rohit', '2022-02-01', 5000, 2),
(5, 'Mudit', '2021-03-01', 12000, 6),
(6, 'Agam', '2024-02-01', 12000, 2),
(7, 'Sanjay', '2024-02-21', 9000, 2),
(8, 'Ashish', '2023-01-05', 5000, 2),
(9, 'Mukesh', '2020-02-03', 6000, 6),
(10, 'Rakesh', '2022-08-01', 7000, 6);


select 
e.emp_name as employee_name,
e.salary as employee_salary,
e.joining_date as employee_joining_date,
m.salary as manager_salary,
m.joining_date as manager_joining_date
from employee e
join employee m on
e.manager_id=m.emp_id
where e.salary>m.salary and 
e.joining_date > m.joining_date
order by e.emp_name asc;

-- 37 
-- Suppose you are a data analyst working for Spotify (a music streaming service company) . Your company is interested in analyzing user engagement with playlists and wants to identify the most popular tracks among all the playlists. Write an SQL query to find the top 2 most popular tracks based on number of playlists they are part of. Your query should return the top 2 track ID along with total number of playlist they are part of , sorted by the same and track id in descending order , Please consider only those playlists which were played by at least 2 distinct users.

CREATE TABLE playlists (
    playlist_id INT,
    user_id VARCHAR(10),
    PRIMARY KEY (playlist_id, user_id)
);

CREATE TABLE playlist_tracks (
    playlist_id INT,
    track_id INT,
    PRIMARY KEY (playlist_id, track_id)
);

CREATE TABLE playlists_info (
    playlist_id INT,
    playlist_name VARCHAR(50),
    PRIMARY KEY (playlist_id)
);


INSERT INTO playlists (playlist_id, user_id) VALUES
(1, 'u1'),
(1, 'u2'),
(1, 'u3'),
(2, 'u3'),
(3, 'u1'),
(3, 'u1'),
(4, 'u4'),
(4, 'u2'),
(5, 'u1');

INSERT INTO playlist_tracks (playlist_id, track_id) VALUES
(1, 101),
(1, 102),
(1, 103),
(1, 104),
(2, 102),
(2, 104),
(3, 104),
(4, 107);

INSERT INTO playlists_info (playlist_id, playlist_name) VALUES
(1, 'Chill Vibes'),
(2, 'Morning Jams'),
(3, 'Workout Beats'),
(4, 'Party Mix'),
(5, 'Study Playlist');

select p.track_id,
count(distinct p.playlist_id) as total_playlist
from playlist_tracks p
join playlist_plays pp on
p.playlist_id=pp.playlist_id
group by p.track_id 
having count(distinct pp.user_id) =2
order by total_playlist desc , p.track_id desc;


-- 38
-- Suppose you are a data analyst working for a retail company, and your team is interested in analysing customer feedback to identify trends and patterns in product reviews.
-- Your task is to write an SQL query to find all product reviews containing the word "excellent" or "amazing" in the review text. However, you want to exclude reviews that contain the word "not" immediately before "excellent" or "amazing". Please note that the words can be in upper or lower case or combination of both. 
-- Your query should return the review_id,product_id, and review_text for each review meeting the criteria, display the output in ascending order of review_id.


CREATE TABLE product_reviews (
    review_id INT,
    product_id INT,
    review_text VARCHAR(40)
);
INSERT INTO product_reviews (review_id, product_id, review_text) VALUES
(1, 101, 'The product is excellent!'),
(2, 101, 'This product is Amazing.'),
(3, 102, 'Not an excellent product.'),
(4, 102, 'The quality is Excellent.'),
(5, 103, 'This is not an amazing product!'),
(6, 103, 'An amazing product!'),
(7, 104, 'This product is not Excellent.'),
(8, 104, 'This is a not excellent product.'),
(9, 105, 'The product is not amazing.'),
(10, 106, 'An excellent product, not amazing.'),
(11, 101, 'A good product.');

select product_id
from product_reviews
where (lower(review_text) like '%excellent%' or lower(review_text) like '%amazing%')
and not (lower(review_text) like '%notexcellent%' or lower(review_text) like '%notamazing%')
order by review_id asc;


