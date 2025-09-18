-- 101
-- Given a sample table with emails sent vs. received by the users, calculate the response rate (%) which is given as emails sent/ emails received. For simplicity consider sent emails are delivered. List all the users that fall under the top 25 percent based on the highest response rate.
-- Please consider users who have sent at least one email and have received at least one email.
CREATE TABLE gmail_data (
    from_user VARCHAR(20),
    to_user VARCHAR(20),
    email_day DATE
);

INSERT INTO gmail_data (from_user, to_user, email_day) VALUES
('a84065b793ad1019', '75d29573774f83236', '2023-11-28'),
('32ded68d8943e808', '32ded68d8943e808', '2023-12-29'),
('157e3e9278e32aba', 'e0e0defcfc9d49c17e', '2023-08-04'),
('114bfa4ddf828264', '47be288778661f698', '2023-11-25'),
('6edf0be24e82d7f1a', '850b4b793adf068514', '2023-05-30'),
('6edf0be24e82d7f1a', '6b5037431a7d4ea0', '2023-11-30'),
('6edf0be24e82d7f1a', 'b5875492386e916f', '2023-12-05');

-- 104
-- 

CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(10)
);

CREATE TABLE sales (
    sale_id INT,
    product_id INT,
    region_name VARCHAR(20),
    sale_date DATE,
    quantity_sold INT
);

CREATE TABLE seasons (
    start_date DATE,
    end_date DATE,
    season_name VARCHAR(10)
);


-- 105
-- 
drop tables if exists student_courses;
CREATE TABLE student_courses (
    student_id INT,
    course_id INT,
    major_flag VARCHAR(1)
);

INSERT INTO student_courses (student_id, course_id, major_flag) VALUES
(1, 101, 'N'),
(2, 101, 'Y'),
(2, 102, 'N'),
(3, 103, 'Y'),
(4, 102, 'N'),
(4, 103, 'Y'),
(4, 104, 'N'),
(5, 104, 'N');


SELECT student_id, course_id AS primary_course
FROM student_courses sc
WHERE major_flag = 'Y'
   OR student_id IN (
        SELECT student_id
        FROM student_courses
        GROUP BY student_id
        HAVING COUNT(*) = 1
   )
ORDER BY student_id;

-- 107
-- Write an SQL query to find all the contiguous ranges of log_id values.
drop table  if exists logs;
CREATE TABLE logs (
    log_id INT
);


INSERT INTO logs (log_id) VALUES
(1),
(2),
(3),
(7),
(8),
(10),
(12),
(13),
(14),
(15),
(16);

SELECT MIN(log_id) AS start_id,
       MAX(log_id) AS end_id
FROM (
    SELECT log_id,
           log_id - ROW_NUMBER() OVER (ORDER BY log_id) AS grp
    FROM logs
) t
GROUP BY grp
ORDER BY start_id;

-- 108
-- 
drop table if exists products;
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(12)
);
drop table if exists cities;
CREATE TABLE cities (
    city_id INT,
    city_name VARCHAR(10)
);
drop table if exists sales;
CREATE TABLE sales (
    sale_id INT,
    product_id INT,
    city_id INT,
    sale_date VARCHAR(12),
    quantity INT
);

INSERT INTO products (product_id, product_name) VALUES
(1, 'Laptop'),
(2, 'Smartphone'),
(3, 'Tablet'),
(4, 'Headphones'),
(5, 'Smartwatch');

INSERT INTO cities (city_id, city_name) VALUES
(1, 'Mumbai'),
(2, 'Delhi'),
(3, 'Bangalore'),
(4, 'Chennai'),
(5, 'Hyderabad');

INSERT INTO sales (sale_id, product_id, city_id, sale_date, quantity) VALUES
(1, 1, 1, '2024-01-01', 30),
(2, 1, 2, '2024-01-02', 40),
(3, 1, 3, '2024-01-03', 35),
(4, 2, 1, '2024-01-04', 20),
(5, 2, 2, '2024-01-05', 15),
(6, 2, 3, '2024-01-06', 10),
(7, 3, 1, '2024-01-07', 5),
(8, 3, 2, '2024-01-08', 2),
(9, 4, 1, '2024-01-09', 50),
(10, 4, 2, '2024-01-10', 30),
(11, 5, 1, '2024-01-11', 25);


SELECT 
    p.product_name
FROM 
    products p
JOIN 
    sales s ON p.product_id = s.product_id
JOIN 
    cities c ON s.city_id = c.city_id
GROUP BY 
    p.product_id, p.product_name
HAVING 
    COUNT(DISTINCT s.city_id) = (SELECT COUNT(*) FROM cities) 
    AND SUM(s.quantity) >= 2
ORDER BY 
    p.product_name;
    
-- 110
-- The marketing team at a retail company wants to analyze customer purchasing behavior. They are particularly interested in understanding how many customers who bought a laptop later went on to purchase a laptop bag, with no intermediate purchases in between. Write an SQL to get number of customer in each country who bought laptop and number of customers who bought laptop bag just after buying a laptop. Order the result by country.
drop table if exists transactions;
CREATE TABLE transactions (
    transaction_id INT,
    customer_id INT,
    product_name VARCHAR(10),
    transaction_timestamp DATETIME,
    country VARCHAR(5)
);
INSERT INTO transactions (transaction_id, customer_id, product_name, transaction_timestamp, country) VALUES
(1, 101, 'Laptop', '2024-01-01 10:00:00', 'India'),
(2, 101, 'Laptop Bag', '2024-01-02 10:00:00', 'India'),
(3, 102, 'Mouse', '2024-01-03 11:00:00', 'India'),
(4, 103, 'Tablet', '2024-01-04 12:00:00', 'India'),
(5, 101, 'Laptop Bag', '2024-01-05 09:00:00', 'India'),
(6, 201, 'Laptop', '2024-01-07 09:15:00', 'USA'),
(7, 201, 'Laptop Bag', '2024-01-08 09:15:00', 'USA'),
(8, 102, 'Smartphone', '2024-01-06 15:00:00', 'India'),
(9, 103, 'Keyboard', '2024-01-10 14:00:00', 'India');

SELECT 
    t1.country,
    COUNT(DISTINCT t1.customer_id) AS customers_who_bought_laptop,
    COUNT(DISTINCT t2.customer_id) AS customers_who_bought_laptop_bag
FROM 
    transactions t1
LEFT JOIN 
    transactions t2 ON t1.customer_id = t2.customer_id 
                     AND t2.product_name = 'Laptop Bag'
                     AND t2.transaction_timestamp > t1.transaction_timestamp
                     AND NOT EXISTS (
                         SELECT 1 
                         FROM transactions t3 
                         WHERE t3.customer_id = t1.customer_id 
                           AND t3.transaction_timestamp > t1.transaction_timestamp 
                           AND t3.transaction_timestamp < t2.transaction_timestamp
                     )
WHERE 
    t1.product_name = 'Laptop'
GROUP BY 
    t1.country
ORDER BY 
    t1.country;

-- 111
-- Write a SQL query to find the number of reportees (both direct and indirect) under each manager. The output should include:
-- m_id: The manager ID.
-- num_of_reportees: The total number of unique reportees (both direct and indirect) under that manager.
-- Order the result by number of reportees in descending order.

CREATE TABLE hierarchy (
    e_id VARCHAR(10),
    m_id VARCHAR(10)
);

INSERT INTO hierarchy (e_id, m_id) VALUES
('A', 'C'),
('B', 'C'),
('C', NULL),
('D', 'F'),
('E', 'F'),
('F', 'E'),
('G', 'E'),
('H', 'G'),
('I', 'F'),
('J', 'I'),
('K', 'I');

SELECT 
    m_id,
    COUNT(DISTINCT e_id) AS num_of_reportees
FROM 
    hierarchy
GROUP BY 
    m_id
HAVING 
    m_id IS NOT NULL
ORDER BY 
    num_of_reportees DESC;

-- 112
-- Meta (formerly Facebook) is analyzing the performance of Instagram Reels across different states in the USA. You have access to a table named REEL that tracks the cumulative views of each reel over time. Write an SQL to get average daily views for each Instagram Reel in each state. Round the average to 2 decimal places and sort the result by average is descending order.

CREATE TABLE reel (
    reel_id INT,
    record_date DATE,
    state VARCHAR(50),
    cumulative_views INT
);

INSERT INTO reel (reel_id, record_date, state, cumulative_views) VALUES
(1, '2024-08-01', 'california', 1000),
(1, '2024-08-02', 'california', 2000),
(1, '2024-08-03', 'california', 2500),
(1, '2024-08-04', 'california', 3500),
(1, '2024-08-05', 'california', 4000),
(1, '2024-08-01', 'nevada', 800),
(1, '2024-08-02', 'nevada', 1200),
(1, '2024-08-03', 'nevada', 1800),
(1, '2024-08-04', 'nevada', 2500),
(1, '2024-08-05', 'nevada', 3200);

SELECT 
    r.reel_id,
    r.state,
    ROUND(AVG(daily_views), 2) AS avg_daily_views
FROM (
    SELECT 
        r1.reel_id,
        r1.state,
        r1.record_date,
        (r1.cumulative_views - COALESCE(r2.cumulative_views, 0)) AS daily_views
    FROM 
        reel r1
    LEFT JOIN 
        reel r2 ON r1.reel_id = r2.reel_id 
                 AND r1.state = r2.state 
                 AND r1.record_date = DATE_ADD(r2.record_date, INTERVAL 1 DAY)
) AS daily_data
GROUP BY 
    reel_id, state
ORDER BY 
    avg_daily_views DESC;

-- 113
-- 

CREATE TABLE rating_table (
    trip_time DATETIME,
    driver_id VARCHAR(10),
    trip_id INT,
    rating INT
);
INSERT INTO rating_table (trip_time, driver_id, trip_id, rating) VALUES
('2023-01-01 10:00:00', 'D1', 1, 5),
('2023-01-01 11:00:00', 'D1', 2, 4),
('2023-01-01 12:00:00', 'D1', 3, 3),
('2023-01-01 13:00:00', 'D1', 4, 5),
('2023-01-01 14:00:00', 'D1', 5, 5),
('2023-01-01 15:00:00', 'D1', 6, 4),

('2023-01-02 09:00:00', 'D2', 7, 5),
('2023-01-02 10:00:00', 'D2', 8, 5),
('2023-01-02 11:00:00', 'D2', 9, 2),
('2023-01-02 12:00:00', 'D2', 10, 5),
('2023-01-02 13:00:00', 'D2', 11, 4),

('2023-01-03 08:00:00', 'D3', 12, 3),
('2023-01-03 09:00:00', 'D3', 13, 4),
('2023-01-03 10:00:00', 'D3', 14, 5),
('2023-01-03 11:00:00', 'D3', 15, 5),
('2023-01-03 12:00:00', 'D3', 16, 5),
('2023-01-03 13:00:00', 'D3', 17, 2);


SELECT driver_id, MAX(streak_len) AS max_streak
FROM (
    SELECT driver_id, grp, COUNT(*) AS streak_len
    FROM (
        SELECT driver_id,
               rating,
               SUM(is_new) OVER (PARTITION BY driver_id ORDER BY trip_time) AS grp
        FROM (
            SELECT driver_id,
                   trip_time,
                   rating,
                   CASE 
                       WHEN rating >= 4 
                            AND (LAG(rating) OVER (PARTITION BY driver_id ORDER BY trip_time) < 4 
                                 OR LAG(rating) OVER (PARTITION BY driver_id ORDER BY trip_time) IS NULL)
                       THEN 1 ELSE 0
                   END AS is_new
            FROM rating_table
        ) t
        WHERE rating >= 4
    ) x
    GROUP BY driver_id, grp
) y
GROUP BY driver_id
ORDER BY max_streak DESC, driver_id DESC;


-- 114
--
CREATE TABLE players (
    player_id INT,
    group_id INT
);
drop table if exists matches;
CREATE TABLE matches (
    match_id INT,
    first_player INT,
    second_player INT,
    first_score INT,
    second_score INT
);

INSERT INTO players (player_id, group_id) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 2),
(7, 3),
(8, 3),
(9, 3),
(10, 1),
(11, 2),
(12, 3);

INSERT INTO matches (match_id, first_player, second_player, first_score, second_score) VALUES
(1, 1, 2, 5, 3),
(2, 1, 3, 4, 7),
(3, 4, 5, 6, 2),
(4, 6, 5, 8, 3),
(5, 7, 8, 5, 5),
(6, 9, 7, 2, 6),
(7, 10, 11, 3, 2),
(8, 12, 11, 4, 4);
SELECT 
    p.group_id,
    p.player_id AS winner_id
FROM 
    players p
JOIN (
    SELECT 
        CASE 
            WHEN m.first_player IS NOT NULL THEN m.first_player 
            ELSE m.second_player 
        END AS player_id,
        p.group_id,
        SUM(CASE 
                WHEN m.first_player = p.player_id THEN m.first_score 
                ELSE m.second_score 
            END) AS total_score
    FROM 
        matches m
    JOIN 
        players p ON p.player_id IN (m.first_player, m.second_player)
    GROUP BY 
        p.group_id, player_id
) AS scores ON p.player_id = scores.player_id
WHERE 
    scores.total_score = (
        SELECT 
            MAX(total_score)
        FROM (
            SELECT 
                SUM(CASE 
                        WHEN m.first_player = p.player_id THEN m.first_score 
                        ELSE m.second_score 
                    END) AS total_score
            FROM 
                matches m
            JOIN 
                players p ON p.player_id IN (m.first_player, m.second_player)
            WHERE 
                p.group_id = scores.group_id
            GROUP BY 
                p.player_id
        ) AS group_scores
    )
ORDER BY 
    p.group_id, winner_id DESC;
    
-- 115
-- 

CREATE TABLE numbers (
    n INT
);

INSERT INTO numbers (n) VALUES
(1),
(2),
(3),
(4),
(7);

SELECT 
    n
FROM 
    numbers,
    (SELECT 1 AS seq UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7) AS temp
WHERE 
    seq <= n
ORDER BY 
    n;

-- 116
-- Please refer to the 3 tables below from a football tournament. Write an SQL which lists every game with the goals scored by each team. The result set should show: match id, match date, team1, score1, team2, score2. Sort the result by match id.
drop table if exists team;
CREATE TABLE team (
    id INT,
    name VARCHAR(20),
    coach VARCHAR(20)
);
drop table if exists game;
CREATE TABLE game (
    match_id INT,
    match_date DATE,
    stadium VARCHAR(20),
    team1 INT,
    team2 INT
);
drop table if exists goal;
CREATE TABLE goal (
    match_id INT,
    team_id INT,
    player VARCHAR(20),
    goal_time TIME
);

INSERT INTO team (id, name, coach) VALUES
(1, 'Mumbai FC', 'Sunil Chhetri'),
(2, 'Delhi Dynamos', 'Sandesh Jhingan'),
(3, 'Bengaluru FC', 'Gurpreet Singh'),
(4, 'Goa FC', 'Brandon Fernandes');

INSERT INTO game (match_id, match_date, stadium, team1, team2) VALUES
(1, '2024-09-01', 'Wankhede', 1, 2),
(2, '2024-09-02', 'Jawaharlal Nehru', 3, 4),
(3, '2024-09-03', 'Sree Kanteerava', 1, 3),
(4, '2024-09-04', 'Wankhede', 1, 4);

INSERT INTO goal (match_id, team_id, player, goal_time) VALUES
(1, 1, 'Anirudh Thapa', '18:23:00'),
(1, 2, 'Sunil Chhetri', '67:12:00'),
(1, 1, 'Udanta Singh', '22:15:00'),
(2, 3, 'Ferran Corominas', '55:21:00'),
(2, 2, 'Sunil Chhetri', '78:14:00'),
(3, 1, 'Sunil Chhetri', '80:30:00'),
(3, 1, 'Bipin Singh', '38:14:00'),
(3, 2, 'Cleiton Silva', '41:20:00'),
(3, 3, 'Cleiton Silva', '62:56:00');


SELECT 
    g.match_id,
    g.match_date,
    t1.name AS team1,
    COALESCE(SUM(CASE WHEN go.team_id = g.team1 THEN 1 ELSE 0 END), 0) AS score1,
    t2.name AS team2,
    COALESCE(SUM(CASE WHEN go.team_id = g.team2 THEN 1 ELSE 0 END), 0) AS score2
FROM 
    game g
LEFT JOIN 
    goal go ON g.match_id = go.match_id
JOIN 
    team t1 ON g.team1 = t1.id
JOIN 
    team t2 ON g.team2 = t2.id
GROUP BY 
    g.match_id, g.match_date, t1.name, t2.name
ORDER BY 
    g.match_id;

-- 117
-- You are given two tables, sales_amount and exchange_rate. The sales_amount table contains sales transactions in various currencies, and the exchange_rate table provides the exchange rates for converting different currencies into USD, along with the dates when these rates became effective.
CREATE TABLE sales_amount (
    sale_date INT,
    sales_amount INT,
    currency VARCHAR(10)
);

CREATE TABLE exchange_rate (
    from_currency VARCHAR(10),
    to_currency VARCHAR(10),
    exchange_rate DECIMAL(10, 4),
    effective_date DATE
);
INSERT INTO exchange_rate (from_currency, to_currency, exchange_rate, effective_date) VALUES
('INR', 'USD', 0.14, '2019-12-31'),
('INR', 'USD', 0.16, '2020-01-10'),
('GBP', 'USD', 1.32, '2020-12-20'),
('GBP', 'USD', 1.35, '2020-01-01'),
('GBP', 'USD', 1.31, '2020-01-02'),
('Ringgit', 'USD', 0.24, '2020-01-01');

INSERT INTO sales_amount (sale_date, sales_amount, currency) VALUES
(20200101, 500, 'INR'),
(20200101, 100, 'GBP'),
(20200102, 1000, 'GBP'),
(20200102, 500, 'INR'),
(20200117, 200, 'GBP'),
(20200115, 800, 'INR'),
(20200110, 150, 'GBP'),
(20200115, 100, 'INR');

WITH sessionized AS (
    SELECT
        user_id,
        event_type,
        event_time,
        CASE
            WHEN LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time) IS NULL
                 OR TIMESTAMPDIFF(MINUTE,
                                  LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time),
                                  event_time) > 30
            THEN 1 ELSE 0
        END AS new_session_flag
    FROM events
),
session_groups AS (
    SELECT
        user_id,
        event_type,
        event_time,
        SUM(new_session_flag) OVER (PARTITION BY user_id ORDER BY event_time
                                    ROWS UNBOUNDED PRECEDING) AS session_num
    FROM sessionized
)
SELECT
    CONCAT(user_id, '_', session_num) AS session_id,
    user_id,
    MIN(event_time) AS session_start_time,
    MAX(event_time) AS session_end_time,
    TIMESTAMPDIFF(MINUTE, MIN(event_time), MAX(event_time)) AS session_duration,
    COUNT(*) AS event_count
FROM session_groups
GROUP BY user_id, session_num
ORDER BY user_id, session_start_time;

-- 119
-- You have a table named covid_tests with the following columns: name, id, age, and corad score. The corad score values are categorized as follows:
-- -1 indicates a negative result.
-- Scores from 2 to 5 indicate a mild condition.
-- Scores from 6 to 10 indicate a serious condition.

CREATE TABLE covid_tests (
    name VARCHAR(10),
    id INT,
    age INT,
    corad_score INT
);

INSERT INTO covid_tests (name, id, age, corad_score) VALUES
('Aarav', 1, 25, -1),
('Vivaan', 2, 30, 3),
('Aditya', 3, 40, 6),
('Vihaan', 4, 38, -1),
('Arjun', 5, 21, 5),
('Kabir', 6, 29, 9),
('Rohan', 7, 48, 7),
('Sai', 8, 34, 5),
('Krishna', 9, 44, 4),
('Siddharth', 10, 43, 5),
('Nisha', 11, 37, 5);

SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE 'Other'
    END AS age_group,
    SUM(CASE WHEN corad_score = -1 THEN 1 ELSE 0 END) AS count_negative,
    SUM(CASE WHEN corad_score BETWEEN 2 AND 5 THEN 1 ELSE 0 END) AS count_mild,
    SUM(CASE WHEN corad_score BETWEEN 6 AND 10 THEN 1 ELSE 0 END) AS count_serious
FROM 
    covid_tests
GROUP BY 
    age_group
ORDER BY 
    age_group;

-- 120
-- In a quick commerce business, Analyzing the frequency and timing of purchases can help the company identify engaged customers and tailor promotions accordingly.
drop table if exists orders1;
CREATE TABLE orders1 (
    customer_id INT,
    order_id INT,
    order_date DATE
);

INSERT INTO orders1 (customer_id, order_id, order_date) VALUES
(1, 101, '2023-01-15'),
(1, 102, '2023-02-10'),
(1, 103, '2023-03-05'),
(2, 201, '2023-01-20'),
(2, 202, '2023-02-15'),
(2, 203, '2023-02-25'),
(3, 301, '2023-03-30'),
(3, 302, '2023-04-01'),
(3, 303, '2023-05-01'),
(4, 401, '2023-01-15'),
(4, 402, '2023-01-20'),
(4, 403, '2023-01-25');
SELECT 
    customer_id,
    COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) AS no_of_orders
FROM 
    orders1
GROUP BY 
    customer_id
HAVING 
    no_of_orders >= 3;

-- 121
-- During a warehouse packaging process, items of various weights (1 kg to 5 kg) need to be packed sequentially into boxes. Each box can hold a maximum of 5 kg in total. The items are presented in a table according to their arrival order, and the goal is to pack them into boxes, keeping the order (based on id) while ensuring each box’s total weight does not exceed 5 kg.
-- Requirements:
-- Pack items into boxes in their given order based on id.
-- Each box should not exceed 5 kg in total weight.
-- Once a box reaches the 5 kg limit or would exceed it by adding the next item, start packing into a new box.
-- Assign a box number to each item based on its position in the sequence, so that items within each box do not exceed the 5 kg limit.

CREATE TABLE items (
    id INT,
    weight INT
);

INSERT INTO items (id, weight) VALUES
(1, 1),
(2, 3),
(3, 5),
(4, 3),
(5, 2),
(6, 4),
(7, 1),
(8, 2),
(9, 5),
(10, 3),
(11, 2),
(12, 3);

WITH running AS (
    SELECT
        id,
        weight,
        SUM(weight) OVER (ORDER BY id) AS cum_weight
    FROM items
),
boxing AS (
    SELECT
        id,
        weight,
        -- box number = how many times cumulative weight crossed multiples of 5 + 1
        FLOOR((cum_weight - 1) / 5) + 1 AS box_number
    FROM running
)
SELECT id, weight, box_number
FROM boxing
ORDER BY id;

-- 122
-- You are working with an employee database where each employee has a department id and a salary. Your task is to find the third highest salary in each department. If there is no third highest salary in a department, then the query should return salary as null for that department. Sort the output by department id.
drop table if exists employees;
CREATE TABLE employees (
    employee_id INT,
    department_id INT,
    salary INT
);
INSERT INTO employees (employee_id, department_id, salary) VALUES
(1, 1, 5000),
(2, 1, 4000),
(3, 1, 3000),
(4, 2, 5000),
(5, 2, 3500),
(6, 3, 4000),
(7, 3, 3000),
(8, 3, 5000),
(9, 4, 10000),
(10, 4, 3000),
(11, 5, 4200);
SELECT 
    department_id,
    MAX(CASE WHEN rn = 3 THEN salary END) AS third_highest_salary
FROM (
    SELECT 
        department_id,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM employees
) t
GROUP BY department_id
ORDER BY department_id;

-- 123
-- 
CREATE TABLE assessments (
    candidate_id INT,
    experience INT,
    sql_score INT,
    algo INT,
    bug_fixing INT
);
INSERT INTO assessments (candidate_id, experience, sql_score, algo, bug_fixing) VALUES
(1, 3, NULL, 50, NULL),
(2, 5, NULL, 100, NULL),
(3, 2, 100, 100, 100),
(4, 3, 50, 50, 50),
(5, 1, 100, NULL, NULL),
(6, 2, 100, 100, NULL),
(7, 4, NULL, NULL, 100),
(8, 5, 100, 100, 100),
(9, 1, NULL, NULL, NULL),
(10, 3, 100, 100, 100);

SELECT 
    experience,
    COUNT(candidate_id) AS total_candidates,
    SUM(
        CASE 
            WHEN (sql_score = 100 OR sql_score IS NULL) 
              AND (algo = 100 OR algo IS NULL) 
              AND (bug_fixing = 100 OR bug_fixing IS NULL)
            THEN 1 
            ELSE 0 
        END
    ) AS perfect_score_count
FROM 
    assessments
GROUP BY 
    experience
ORDER BY 
    experience;

-- 124
-- Netflix’s analytics team wants to identify the Top 3 most popular shows based on the viewing patterns of its users. The definition of "popular" is based on two factors:
-- Unique Watchers: The total number of distinct users who have watched a show.
-- Total Watch Duration: The cumulative time users have spent watching the show

CREATE TABLE watch_history (
    user_id INT,
    show_id INT,
    watch_date DATE,
    watch_duration INT
);
INSERT INTO watch_history (user_id, show_id, watch_date, watch_duration) VALUES
(1, 101, '2024-11-01', 120),
(2, 101, '2024-11-01', 130),
(3, 101, '2024-11-01', 60),
(4, 102, '2024-11-03', 200),
(5, 102, '2024-11-03', 150),
(6, 103, '2024-11-01', 1000),
(7, 101, '2024-11-01', 140),
(8, 104, '2024-11-01', 250),
(9, 106, '2024-11-02', 300),
(10, 106, '2024-11-02', 500);

SELECT 
    show_id,
    COUNT(DISTINCT user_id) AS unique_watchers,
    SUM(watch_duration) AS total_duration
FROM 
    watch_history
GROUP BY 
    show_id
ORDER BY 
    unique_watchers DESC, 
    total_duration DESC
LIMIT 3;

-- 125
-- You are tasked with managing project budgets at a company. Each project has a fixed budget, and multiple employees work on these projects. The company's payroll is based on annual salaries, and each employee works for a specific duration on a project.
drop table if exists employees;
CREATE TABLE employees (
    id INT,
    name VARCHAR(50),
    salary INT
);
drop table if exists projects;
CREATE TABLE projects (
    id INT,
    title VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget INT
);

CREATE TABLE project_employees (
    project_id INT,
    employee_id INT
);
INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 100000),
(2, 'Bob', 120000),
(3, 'Charlie', 90000),
(4, 'David', 110000),
(5, 'Eva', 95000),
(6, 'Frank', 105000),
(7, 'Grace', 98000),
(8, 'Helen', 115000);

INSERT INTO projects (id, title, start_date, end_date, budget) VALUES
(1, 'Website Redesign', '2024-01-15', '2024-07-15', 50000),
(2, 'App Development', '2024-02-01', '2024-05-31', 100000),
(3, 'Cloud Migration', '2024-03-01', '2024-04-30', 20000),
(4, 'Analytics Platform', '2024-05-05', '2024-08-05', 80000);

INSERT INTO project_employees (project_id, employee_id) VALUES
(1, 1),
(2, 2),
(2, 3),
(2, 4),
(3, 5),
(4, 6),
(4, 7),
(4, 8);
SELECT 
    p.title,
    CASE 
        WHEN (SUM(e.salary) * DATEDIFF(p.end_date, p.start_date) / 365) > p.budget THEN 'overbudget' 
        ELSE 'within budget' 
    END AS budget_status
FROM 
    projects p
LEFT JOIN 
    project_employees pe ON p.id = pe.project_id
LEFT JOIN 
    employees e ON pe.employee_id = e.id
GROUP BY 
    p.id, p.title, p.budget, p.start_date, p.end_date
ORDER BY 
    p.title;

-- 126
-- You are given an orders table that contains information about customer purchases, including the products they bought. Write a query to find all customers who have purchased both "Laptop" and "Mouse", but have never purchased "Phone Case". Additionally, include the total number of distinct products purchased by these customers. Sort the result by customer id.
drop table if exists orders1;
CREATE TABLE orders1 (
    customer_id INT,
    order_id INT,
    product_name VARCHAR(50)
);

INSERT INTO orders1 (customer_id, order_id, product_name) VALUES
(1, 101, 'Laptop'),
(1, 102, 'Phone Case'),
(1, 103, 'Headphones'),
(2, 104, 'Laptop'),
(2, 105, 'Mouse'),
(2, 106, 'Mouse'),
(3, 107, 'Laptop'),
(3, 108, 'Mouse'),
(4, 109, 'Laptop'),
(5, 110, 'Phone Case'),
(6, 111, 'Laptop');

SELECT 
    customer_id,
    COUNT(DISTINCT product_name) AS total_products
FROM 
    orders1
WHERE 
    customer_id IN (
        SELECT customer_id
        FROM orders
        WHERE product_name IN ('Laptop', 'Mouse')
        GROUP BY customer_id
        HAVING COUNT(DISTINCT product_name) = 2
    )
    AND customer_id NOT IN (
        SELECT customer_id
        FROM orders1
        WHERE product_name = 'Phone Case'
    )
GROUP BY 
    customer_id
ORDER BY 
    customer_id;

-- 127
-- You are given three tables: students, friends and packages. Friends table has student id and friend id(only best friend). A student can have more than one best friends.
-- Write a query to output the names of those students whose ALL friends got offered a higher salary than them. Display those students name and difference between their salary and average of their friends salaries.
drop table if exists students;
CREATE TABLE students (
    id INT,
    name VARCHAR(50)
);
drop table if exists friends;
CREATE TABLE friends (
    id INT,
    friend_id INT
);
drop table if exists packages;
CREATE TABLE packages (
    id INT,
    salary INT
);
INSERT INTO students (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana'),
(5, 'Eve');

INSERT INTO friends (id, friend_id) VALUES
(1, 2),
(1, 3),
(2, 1),
(2, 3),
(3, 1),
(4, 5),
(5, 4);

INSERT INTO packages (id, salary) VALUES
(1, 50000),
(2, 60000),
(3, 70000),
(4, 40000),
(5, 30000);
SELECT 
    s.name,
    (p.salary - AVG(fp.salary)) AS salary_difference
FROM 
    students s
JOIN 
    packages p ON s.id = p.id
JOIN 
    friends f ON s.id = f.id
JOIN 
    packages fp ON f.friend_id = fp.id
GROUP BY 
    s.id, s.name, p.salary
HAVING 
    MIN(fp.salary) > p.salary;

-- 128
-- You are given a table of train schedule which contains the arrival and departure times of trains at each station on a given day.
-- At each station one platform can accommodate only one train at a time, from the beginning of the minute the train arrives until the end of the minute it departs.
-- Write a query to find the minimum number of platforms required at each station to handle all train traffic to ensure that no two trains overlap at any station
CREATE TABLE train_schedule (
    station_id INT,
    train_id INT,
    arrival_time TIME,
    departure_time TIME
);
INSERT INTO train_schedule (station_id, train_id, arrival_time, departure_time) VALUES
(100, 1, '08:00:00', '08:15:00'),
(100, 2, '08:05:00', '08:15:00'),
(100, 3, '08:05:00', '08:30:00'),
(100, 4, '08:11:00', '08:20:00'),
(100, 5, '08:15:00', '08:20:00'),
(100, 6, '12:15:00', '12:30:00'),
(100, 7, '12:15:00', '12:25:00'),
(100, 8, '12:20:00', '12:30:00'),
(100, 9, '12:25:00', '12:35:00'),
(100, 10, '12:25:00', '12:45:00'),
(100, 11, '15:00:00', '15:15:00'),
(100, 12, '15:10:00', '15:20:00');
SELECT 
    station_id,
    COUNT(*) AS platforms_required
FROM (
    SELECT 
        station_id,
        arrival_time,
        departure_time,
        COUNT(*) OVER (PARTITION BY station_id ORDER BY arrival_time, departure_time) AS active_trains
    FROM 
        train_schedule
    WHERE 
        arrival_time < departure_time
) AS train_times
GROUP BY 
    station_id
ORDER BY 
    station_id;

-- 129
-- We have a driver table which has driver id and join date for each Uber drivers. We have another table rides where we have ride id, ride date and driver id. A driver becomes inactive if he doesn't have any ride for consecutive 28 days after joining the company. Driver can become active again once he takes a new ride. We need to find number of active drivers for uber at the end of each month for year 2023.
drop table if exists drivers;
CREATE TABLE drivers (
    driver_id INT,
    join_date DATE
);

CREATE TABLE rides (
    ride_id INT,
    ride_date DATE,
    driver_id INT
);

CREATE TABLE calendar_dim (
    cal_date DATE
);

INSERT INTO drivers (driver_id, join_date) VALUES
(1, '2023-01-05'),
(2, '2023-02-15'),
(3, '2023-03-10'),
(4, '2023-01-03'),
(5, '2023-07-01'),
(6, '2023-08-08'),
(7, '2023-05-20');

INSERT INTO rides (ride_id, ride_date, driver_id) VALUES
(1, '2023-01-05', 1),
(2, '2023-02-15', 2),
(3, '2023-02-20', 3),
(4, '2023-03-25', 4),
(5, '2023-04-05', 5),
(6, '2023-08-05', 6),
(7, '2023-06-01', 7);


SELECT 
    m.cal_date AS month_end,
    COUNT(DISTINCT d.driver_id) AS active_drivers
FROM calendar_dim m
JOIN drivers d 
    ON d.join_date <= m.cal_date
LEFT JOIN (
    SELECT r.driver_id, r.ride_date, c.cal_date,
           MAX(r.ride_date) OVER (PARTITION BY r.driver_id, c.cal_date 
                                  ORDER BY r.ride_date 
                                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS last_ride
    FROM rides r
    JOIN calendar_dim c 
        ON r.ride_date <= c.cal_date
) x
    ON d.driver_id = x.driver_id AND x.cal_date = m.cal_date
WHERE m.cal_date = DATEADD(DAY, -DAY(m.cal_date), DATEADD(MONTH, 1, m.cal_date))  -- month end
  AND (
        m.cal_date <= DATEADD(DAY, 28, d.join_date)   -- within 28 days of join
        OR (x.last_ride IS NOT NULL 
            AND DATEDIFF(DAY, x.last_ride, m.cal_date) <= 28) -- last ride within 28 days
      )
GROUP BY m.cal_date
ORDER BY m.cal_date;

-- 130
-- ou work in the Human Resources (HR) department of a growing company that tracks the status of its employees year over year. The company needs to analyze employee status changes between two consecutive years: 2020 and 2021.

CREATE TABLE emp_2020 (
    emp_id INT,
    designation VARCHAR(50)
);

CREATE TABLE emp_2021 (
    emp_id INT,
    designation VARCHAR(50)
);

INSERT INTO emp_2020 (emp_id, designation) VALUES
(1, 'Developer'),
(2, 'Developer'),
(3, 'Manager'),
(5, 'Trainee'),
(6, 'Developer');

INSERT INTO emp_2021 (emp_id, designation) VALUES
(1, 'Trainee'),
(2, 'Developer'),
(3, 'Developer'),
(4, 'Manager'),
(5, 'Trainee'),
(6, 'Developer');

-- 1. Promoted or Resigned (from 2020 perspective)
SELECT 
    e2020.emp_id,
    CASE
        WHEN e2021.emp_id IS NOT NULL AND e2020.designation <> e2021.designation THEN 'Promoted'
        WHEN e2021.emp_id IS NULL THEN 'Resigned'
    END AS status
FROM emp_2020 e2020
LEFT JOIN emp_2021 e2021
    ON e2020.emp_id = e2021.emp_id

UNION

-- 2. New Hires (from 2021 perspective)
SELECT 
    e2021.emp_id,
    'New Hire' AS status
FROM emp_2021 e2021
LEFT JOIN emp_2020 e2020
    ON e2021.emp_id = e2020.emp_id
WHERE e2020.emp_id IS NULL

ORDER BY emp_id;

-- 131
-- You work in the Human Resources (HR) department of a growing company that tracks the status of its employees year over year. The company needs to analyze employee status changes between two consecutive years: 2020 and 2021.
-- The company's HR system has two separate records of employees for the years 2020 and 2021 in the same table, which include each employee's unique identifier (emp_id) and their corresponding designation (role) within the organization for each year.
-- The task is to track how the designations of employees have changed over the year. Specifically, you are required to identify the following changes:
drop table if exists employees;
CREATE TABLE employees (
    emp_id INT,
    year INT,
    designation VARCHAR(50)
);

INSERT INTO employees (emp_id, year, designation) VALUES
(1, 2020, 'Trainee'),
(2, 2020, 'Developer'),
(3, 2020, 'Developer'),
(4, 2020, 'Manager'),
(5, 2020, 'Trainee'),
(6, 2021, 'Developer'),
(3, 2021, 'Manager'),
(1, 2021, 'Trainee'),
(2, 2021, 'Developer');

-- Resigned and Promoted Employees
SELECT 
    e2020.emp_id,
    e2020.designation AS designation_2020,
    e2021.designation AS designation_2021,
    CASE 
        WHEN e2021.emp_id IS NULL THEN 'Resigned'       -- Employee was in 2020 but not in 2021
        WHEN e2020.designation <> e2021.designation THEN 'Promoted' -- Employee got a promotion
    END AS change_status
FROM 
    employees e2020
LEFT JOIN 
    employees e2021 ON e2020.emp_id = e2021.emp_id AND e2021.year = 2021
WHERE 
    e2020.year = 2020 AND (e2021.emp_id IS NULL OR e2020.designation <> e2021.designation)

UNION ALL

-- New Hires
SELECT 
    e2021.emp_id,
    NULL AS designation_2020,
    e2021.designation AS designation_2021,
    'New Hire' AS change_status
FROM 
    employees e2021
LEFT JOIN 
    employees e2020 ON e2021.emp_id = e2020.emp_id AND e2020.year = 2020
WHERE 
    e2021.year = 2021 AND e2020.emp_id IS NULL
ORDER BY 
    emp_id;

-- 132
-- Write an SQL to get the date of the last Sunday as per today's date. If you are solving the problem on Sunday then it should still return the date of last Sunday (not current date).

CREATE TABLE today_date_table (
    today_date DATETIME
);


INSERT INTO today_date_table (today_date) VALUES
('2025-06-13 00:00:20');
SELECT DATE_SUB(today_date, INTERVAL (WEEKDAY(today_date) + 1) % 7 + 1 DAY) AS last_sunday
FROM today_date_table;

-- 133
-- A company manages project data from three source systems with varying reliability: EagleEye: The most reliable and prioritized internal system. SwiftLink: A trusted partner system with moderate reliability. DataVault: A third-party system used as a fallback.
drop table if exists projects;
CREATE TABLE projects (
    id INT,
    project_number INT,
    source_system VARCHAR(50)
);
INSERT INTO projects (id, project_number, source_system) VALUES
(1, 101, 'EagleEye'),
(2, 101, 'SwiftLink'),
(3, 102, 'DataVault'),
(4, 102, 'SwiftLink'),
(5, 103, 'DataVault');

SELECT
    id,
    project_number,
    Source_System
FROM (
    SELECT
        id,
        project_number,
        Source_System,
        ROW_NUMBER() OVER (
            PARTITION BY project_number
            ORDER BY 
                CASE Source_System
                    WHEN 'EagleEye' THEN 1
                    WHEN 'SwiftLink' THEN 2
                    WHEN 'DataVault' THEN 3
                    ELSE 4
                END
        ) AS rn
    FROM projects
) t
WHERE rn = 1;

-- 134
-- Imagine you are working for Swiggy (a food delivery service platform). As part of your role in the data analytics team, you're tasked with identifying dormant customers - those who have registered on the platform but have not placed any orders recently. Identifying dormant customers is crucial for targeted marketing efforts and customer re-engagement strategies.
-- A dormant customer is defined as a user who registered more than 6 months ago from today but has not placed any orders in the last 3 months. Your query should return the list of dormant customers and order amount of last order placed by them. If no order was placed by a customer then order amount should be 0. order the output by user id.
drop table if exists users;
CREATE TABLE users (
    user_id INT,
    name VARCHAR(100),
    email VARCHAR(100),
    signup_date DATE
);

drop table if exists orders1;
CREATE TABLE orders1 (
    order_id INT,
    order_date DATE,
    user_id INT,
    order_amount INT
);




SELECT
    u.user_id,
    COALESCE(o.order_amount, 0) AS last_order_amount
FROM users u
LEFT JOIN (
    SELECT t1.user_id, t1.order_amount
    FROM orders1 t1
    JOIN (
        SELECT user_id, MAX(order_date) AS last_order_date
        FROM orders1
        GROUP BY user_id
    ) t2
    ON t1.user_id = t2.user_id AND t1.order_date = t2.last_order_date
) o
ON u.user_id = o.user_id
WHERE u.signup_date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
  AND (o.user_id IS NULL OR o.user_id IS NOT NULL AND o.order1_date < DATE_SUB(CURDATE(), INTERVAL 3 MONTH))
ORDER BY u.user_id;

-- 135
-- At Spotify, we track user activity to understand their engagement with the platform. One of the key metrics we focus on is how consistently a user listens to music each day. A user is considered "consistent" if they have login session every single day since their first login.

CREATE TABLE user_sessions (
    user_id INT,
    login_timestamp DATETIME
);
INSERT INTO user_sessions (user_id, login_timestamp) VALUES
(1, '2025-06-06 00:01:05'),
(1, '2025-06-07 00:01:05'),
(1, '2025-06-08 02:01:05'),
(1, '2025-06-09 00:01:05'),
(1, '2025-06-10 01:01:05'),
(1, '2025-06-11 00:01:05'),
(2, '2025-06-13 00:01:05');

SELECT
    user_id
FROM (
    SELECT
        user_id,
        DATE(MIN(login_timestamp)) AS first_login,
        COUNT(DISTINCT DATE(login_timestamp)) AS total_login_days,
        DATEDIFF(CURDATE(), DATE(MIN(login_timestamp))) + 1 AS expected_days
    FROM user_sessions
    GROUP BY user_id
) t
WHERE total_login_days = expected_days;

-- 136
-- rating: The overall star rating of the company as per rules below:
    /*Promoted companies : should always have NULL as their rating.
    For non-promoted companies:
        Format: <#_stars> (<average_rating>, based on <total_reviews> reviews), where:
        <#_stars>: Rounded down average rating to the nearest whole number.
        <average_rating>: Exact average rating rounded to 1 decimal place.
        <total_reviews>: Total number of reviews across all categories for the company.
Rules: Non-promoted companies should only be included if their average rating is 1 star or higher.

Results should be sorted:
By promotion status (promoted first).
In descending order of the average rating (before rounding).
By the total number of reviews (descending).*/

CREATE TABLE companies (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    phone VARCHAR(255),
    is_promoted INT
);

INSERT INTO companies (id, name, phone, is_promoted) VALUES
(1, 'Wehner and Sons', '+86 (302) 414-2559', 0),
(2, 'Schaefer-Rogahn', '+33 (982) 752-6689', 0),
(3, 'King and Sons', '+51 (578) 555-1781', 1),
(4, 'Considine LLC', '+33 (487) 383-2644', 0),
(5, 'Parisian-Zieme', '+1 (399) 688-1824', 0),
(6, 'Renner and Parisian', '+7 (720) 699-2313', 0),
(7, 'Fadel and Fahey', '+86 (307) 777-1731', 1);
drop table if exists categories;
CREATE TABLE categories (
    company_id INT,
    name VARCHAR(255),
    rating DECIMAL(3, 1)
);

INSERT INTO categories (company_id, name, rating) VALUES
(1, 'Drilled Shafts', 5.0),
(1, 'Granite Surfaces', 3.0),
(1, 'Structural and Misc Steel', 0.0),
(2, 'Waterproofing & Caulking', 0.0),
(3, 'Drywall & Acoustical', 1.0),
(3, 'Electrical and Fire Alarm', 2.0),
(3, 'Drywall & Acoustical A', 3.0),
(3, 'Oranament Railings', 3.0),
(4, 'Exterior Signage', 0.0),
(4, 'Termite Control1', 3.0),
(4, 'Termite Control2', 1.0);


SELECT
    CASE
        WHEN c.is_promoted = 1 THEN CONCAT('[PROMOTED] ', c.name)
        ELSE c.name
    END AS name,
    c.phone,
    CASE
        WHEN c.is_promoted = 1 THEN NULL
        ELSE CONCAT(
            FLOOR(AVG(ct.rating)),
            ' (',
            ROUND(AVG(ct.rating), 1),
            ', based on ',
            COUNT(ct.rating),
            ' reviews)'
        )
    END AS rating
FROM
    companies AS c
LEFT JOIN
    categories AS ct ON c.id = ct.company_id
GROUP BY
    c.id, c.name, c.phone, c.is_promoted
HAVING
    c.is_promoted = 1 OR AVG(ct.rating) >= 1.0
ORDER BY
    c.is_promoted DESC,
    AVG(ct.rating) DESC,
    COUNT(ct.rating) DESC;
    
-- 137
-- Myntra marketing team wants to measure the effectiveness of recent campaigns aimed at acquiring new customers. A new customer is defined as someone who made their first-ever purchase during a specific period, with no prior purchase history.
-- They have asked you to identify the new customers acquired in the last 3 months, excluding the current month. Output should display customer id and their first purchase date. Order the result by customer id.
drop table if exists transactions;
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    transaction_date DATE,
    amount INT
);

INSERT INTO transactions (transaction_id, customer_id, transaction_date, amount) VALUES
(1, 1, '2025-01-13', 100),
(2, 5, '2025-02-13', 200),
(3, 5, '2025-05-13', 200),
(4, 1, '2025-03-13', 150),
(5, 3, '2025-04-13', 120),
(6, 4, '2025-03-10', 130),
(7, 4, '2025-04-13', 230),
(8, 6, '2025-05-09', 110),
(9, 2, '2025-05-29', 180),
(10, 6, '2025-06-01', 90),
(11, 7, '2025-05-13', 110),
(12, 7, '2025-05-13', 180);

SELECT
    customer_id,
    MIN(transaction_date) AS first_purchase_date
FROM
    transactions
GROUP BY
    customer_id
HAVING
    MIN(transaction_date) >= '2025-03-01'
    AND MIN(transaction_date) <= '2025-05-31'
ORDER BY
    customer_id;

-- 138
-- You are given a table with customers information that contains inconsistent and messy data. Your task is to clean the data by writing an SQL query to:
/*1- Trim extra spaces from the customer name and email fields.

2- Convert all email addresses to lowercase for consistency.

3- Remove duplicate records based on email address (keep the record with lower customer id).

4- Standardize the phone number format to only contain digits (remove dashes, spaces, and special characters).

5- Replace NULL values in address with 'Unknown'.*/


drop table if exists customers;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    address VARCHAR(255)
);

INSERT INTO customers (customer_id, customer_name, email, phone, address) VALUES
(1, 'John Doe ', 'JOHN.DOE@GMAIL.COM', '(123)-456-7890', '123 Main St'),
(2, 'Jane Smith', 'Jane.Smith@Yahoo.com', '987 654 3210', '456 Oak Ave'),
(3, 'JOHN DOE', 'JOHN.DOE@GMAIL.COM', '123-456-7890', '123 Main St'),
(4, ' Alex White', 'Alex.White@Outlook.com', '111-222-3333', '789 Pine Rd'),
(5, 'Bob Brown', 'Bob.Brown@Gmail.Com', '+1 (555) 888-9999', '555 Birch Ln'),
(6, 'Emily Davis', 'EMILY.DAVIS@GMAIL.COM', '555 666 7777', NULL),
(7, 'Michael Johnson', 'Michael.Johnson@Hotmail.com', '444-555-6666', '123 Main St'),
(8, 'David Miller', 'DAVID.MILLER@YAHOO.COM', '(777) 888-9999', '222 Cedar St'),
(9, 'David M', 'david.miller@yahoo.com', '999.888.7777', NULL),
(10, 'William Taylor', 'WILLIAM.TAYLOR@OUTLOOK.COM', '+1 123-456-7890', '444 Spruce Ln'),
(11, 'Michael Johnson', 'Michael.Johnson@Hotmail.com', '444-555-6666', '456 Oak Ave'),
(12, 'Olivia Brown', 'Olivia.Brown@Yahoo.com', '333 222 1111', '111 Maple Ave');

SELECT
    customer_id,
    TRIM(customer_name) AS customer_name,
    LOWER(TRIM(email)) AS email,
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), ' ', ''), '(', ''), ')', ''), '+', '') AS phone,
    COALESCE(address, 'Unknown') AS address
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY LOWER(TRIM(email)) ORDER BY customer_id) AS rn
    FROM
        customers
) AS subquery
WHERE
    rn = 1
ORDER BY
    customer_id;
    
-- 139
-- Given a sales dataset that records daily transactions for various products, write an SQL query to calculate last quarter's total sales and quarter-to-date (QTD) sales for each product, helping analyze past performance and current trends.
drop table if exists sales;
CREATE TABLE sales (
    id INT,
    product_id INT,
    sale_date DATE,
    sales_amount INT
);

INSERT INTO sales (id, product_id, sale_date, sales_amount) VALUES
(1, 101, '2025-03-05', 500),
(2, 101, '2025-03-15', 700),
(3, 101, '2025-03-25', 600),
(4, 101, '2025-04-04', 400),
(5, 101, '2025-04-14', 300),
(6, 101, '2025-05-14', 900),
(7, 101, '2025-05-24', 850),
(8, 101, '2025-05-29', 700),
(9, 101, '2025-06-03', 950),
(10, 101, '2025-06-08', 1100),
(11, 102, '2025-03-05', 800),
(12, 102, '2025-03-15', 850);


SELECT
    product_id,
    SUM(CASE WHEN sale_date BETWEEN '2025-04-01' AND '2025-06-30' THEN sales_amount ELSE 0 END) AS last_quarter_sales,
    SUM(CASE WHEN sale_date BETWEEN '2025-07-01' AND '2025-09-17' THEN sales_amount ELSE 0 END) AS qtd_sales
FROM
    sales
GROUP BY
    product_id;
    
    
-- 140
-- Given a list of matches in the group stage of the football World Cup, compute the number of points each team currently has.

drop table if exists teams;
CREATE TABLE teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(255)
);

-- Insert data into the 'teams' table
INSERT INTO teams (team_id, team_name) VALUES
(10, 'Give'),
(20, 'Never'),
(30, 'You'),
(40, 'Up'),
(50, 'Gonna');

drop table if exists matches;
CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    host_team INT,
    guest_team INT,
    host_goals INT,
    guest_goals INT
);

INSERT INTO matches (match_id, host_team, guest_team, host_goals, guest_goals) VALUES
(1, 30, 20, 1, 0),
(2, 10, 20, 1, 2),
(3, 20, 50, 2, 2),
(4, 10, 30, 1, 0),
(5, 30, 50, 0, 1);


SELECT
    t.team_id,
    t.team_name,
    COALESCE(SUM(total_points), 0) AS num_points
FROM
    teams t
LEFT JOIN (
    SELECT
        host_team AS team_id,
        CASE
            WHEN host_goals > guest_goals THEN 3
            WHEN host_goals = guest_goals THEN 1
            ELSE 0
        END AS total_points
    FROM
        matches

    UNION ALL

    SELECT
        guest_team AS team_id,
        CASE
            WHEN guest_goals > host_goals THEN 3
            WHEN guest_goals = host_goals THEN 1
            ELSE 0
        END AS total_points
    FROM
        matches
) AS match_results ON t.team_id = match_results.team_id
GROUP BY
    t.team_id, t.team_name
ORDER BY
    num_points DESC, t.team_id;
    
-- 141
-- Identify passengers with more than 5 flights from the same airport since last 1 year from current date. Display passenger id, departure airport code and number of flights.

CREATE TABLE flight_details (
    Flight_id VARCHAR(255),
    Departure_airport_code VARCHAR(255),
    Arrival_airport_code VARCHAR(255)
);

INSERT INTO flight_details (Flight_id, Departure_airport_code, Arrival_airport_code) VALUES
('F101', 'JFK', 'LAX'),
('F102', 'JFK', 'ORD'),
('F103', 'JFK', 'ATL'),
('F104', 'JFK', 'LAX'),
('F105', 'JFK', 'SEA'),
('F106', 'JFK', 'MIA'),
('F107', 'JFK', 'DFW'),
('F108', 'JFK', 'SFO'),
('F109', 'JFK', 'LAS'),
('F110', 'JFK', 'BOS'),
('F111', 'JFK', 'DEN'),
('F112', 'SFO', 'SFO');

CREATE TABLE passenger_flights (
    Passenger_id VARCHAR(255),
    Flight_id VARCHAR(255),
    Departure_date DATE
);

INSERT INTO passenger_flights (Passenger_id, Flight_id, Departure_date) VALUES
('P001', 'F101', '2025-03-02'),
('P001', 'F102', '2025-04-02'),
('P001', 'F103', '2025-05-10'),
('P001', 'F104', '2025-06-09'),
('P001', 'F105', '2024-08-02'),
('P004', 'F106', '2024-05-19'),
('P004', 'F107', '2024-09-20'),
('P004', 'F108', '2024-04-29'),
('P004', 'F109', '2024-05-01'),
('P004', 'F110', '2024-12-04'),
('P004', 'F111', '2025-01-07'),
('P002', 'F112', '2025-03-06');

SELECT
    pf.Passenger_id,
    fd.Departure_airport_code,
    COUNT(fd.Departure_airport_code) AS number_of_flights
FROM
    passenger_flights AS pf
JOIN
    flight_details AS fd ON pf.Flight_id = fd.Flight_id
WHERE
    pf.Departure_date >= '2024-09-17'
GROUP BY
    pf.Passenger_id, fd.Departure_airport_code
HAVING
    COUNT(fd.Departure_airport_code) > 5;
    

-- 142
-- You are given an employees table containing information about employees' salaries across different departments. Your task is to calculate the difference between the highest and second-highest salaries for each department.
drop table if exists employees;
CREATE TABLE employees (
    id INT,
    name VARCHAR(255),
    department VARCHAR(255),
    Salary INT
);

INSERT INTO employees (id, name, department, Salary) VALUES
(1, 'Alice', 'Marketing', 80000),
(2, 'Bob', 'Marketing', 60000),
(3, 'Charlie', 'Marketing', 80000),
(4, 'David', 'Marketing', 60000),
(5, 'Eve', 'Engineering', 90000),
(6, 'Frank', 'Engineering', 85000),
(7, 'Grace', 'Engineering', 90000),
(8, 'Hank', 'Engineering', 70000),
(9, 'Ivy', 'HR', 50000),
(10, 'Jack', 'Finance', 95000),
(11, 'Kathy', 'Finance', 95000),
(12, 'Leo', 'Finance', 95000);


WITH RankedSalaries AS (
    SELECT
        department,
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM
        employees
),
DistinctSalaries AS (
    SELECT
        department,
        COUNT(DISTINCT salary) AS num_distinct_salaries
    FROM
        employees
    GROUP BY
        department
)
SELECT
    rs.department AS "Department Name",
    CASE
        WHEN ds.num_distinct_salaries < 2 THEN NULL
        ELSE MAX(CASE WHEN rs.salary_rank = 1 THEN rs.salary ELSE NULL END) - MAX(CASE WHEN rs.salary_rank = 2 THEN rs.salary ELSE NULL END)
    END AS "Salary Difference"
FROM
    RankedSalaries rs
JOIN
    DistinctSalaries ds ON rs.department = ds.department
GROUP BY
    rs.department
ORDER BY
    rs.department;
    
    
-- 143
-- Company X is analyzing Airbnb listings to help travelers find the most affordable yet well-equipped accommodations in various neighborhoods. Many users prefer to stay in entire homes or apartments instead of shared spaces and require essential amenities like TV and Internet for work or entertainment.

CREATE TABLE airbnb_listings (
    property_id INT PRIMARY KEY,
    neighborhood VARCHAR(255),
    cost_per_night INT,
    room_type VARCHAR(255),
    amenities TEXT
);

INSERT INTO airbnb_listings (property_id, neighborhood, cost_per_night, room_type, amenities) VALUES
(101, 'Manhattan', 80, 'Entire home', 'TV; INTERNET; Kitchen;'),
(102, 'Manhattan', 80, 'Entire home', 'TV; internet; Kitchen;'),
(103, 'Brooklyn', 65, 'Apartment', 'TV; Internet; Air Conditioning'),
(104, 'Queens', 50, 'Entire home', 'TV; Internet; Wifi; Balcony'),
(105, 'Bronx', 90, 'Apartment', 'TV; Internet; Parking'),
(106, 'Bronx', 80, 'Entire home', 'TV; Internet'),
(107, 'Bronx', 85, 'Entire home', 'TV; Internet; Pool'),
(201, 'Manhattan', 70, 'Private room', 'TV; Internet; Heating'),
(202, 'Manhattan', 75, 'Shared room', 'TV; Internet'),
(203, 'Brooklyn', 60, 'Entire home', 'Internet; Heating'),
(204, 'Brooklyn', 55, 'Apartment', 'TV; Kitchen'),
(205, 'Queens', 45, 'Entire home', 'Wifi; Balcony; Garden');

WITH RankedListings AS (
    SELECT
        neighborhood,
        property_id,
        cost_per_night,
        RANK() OVER (
            PARTITION BY neighborhood
            ORDER BY
                cost_per_night,
                LENGTH(amenities) DESC
        ) AS rn
    FROM
        airbnb_listings
    WHERE
        room_type IN ('Entire home', 'Apartment')
        AND LOWER(amenities) LIKE '%tv%'
        AND LOWER(amenities) LIKE '%internet%'
)
SELECT
    neighborhood,
    property_id,
    cost_per_night
FROM
    RankedListings
WHERE
    rn = 1
ORDER BY
    neighborhood;
    
-- 144
-- You are working with a large dataset of out-of-stock (OOS) events for products across multiple marketplaces.Each record in the dataset represents an OOS event for a specific product (MASTER_ID) in a specific marketplace (MARKETPLACE_ID) on a specific date (OOS_DATE). The combination of (MASTER_ID, MARKETPLACE_ID, OOS_DATE) is always unique. Your task is to identify key OOS event dates for each product and marketplace combination.

CREATE TABLE DETAILED_OOS_EVENTS (
    MASTER_ID VARCHAR(255),
    MARKETPLACE_ID INT,
    OOS_DATE DATE,
    PRIMARY KEY (MASTER_ID, MARKETPLACE_ID, OOS_DATE)
);

INSERT INTO DETAILED_OOS_EVENTS (MASTER_ID, MARKETPLACE_ID, OOS_DATE) VALUES
('P04G', 13, '2023-07-03'),
('P04G', 13, '2023-07-04'),
('P04G', 13, '2024-06-30'),
('P04G', 13, '2024-07-01'),
('P04G', 13, '2024-07-02'),
('P04G', 13, '2024-07-03'),
('P04G', 13, '2024-07-04'),
('P04G', 13, '2024-07-05'),
('P04G', 13, '2024-07-06'),
('P04G', 13, '2024-07-07'),
('P04G', 13, '2024-07-08'),
('P04G', 13, '2024-07-09');
WITH RankedSalaries AS (
    SELECT
        department,
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM
        employees
),
DistinctSalaries AS (
    SELECT
        department,
        COUNT(DISTINCT salary) AS num_distinct_salaries
    FROM
        employees
    GROUP BY
        department
)
SELECT
    rs.department AS "Department Name",
    CASE
        WHEN ds.num_distinct_salaries < 2 THEN NULL
        ELSE MAX(CASE WHEN rs.salary_rank = 1 THEN rs.salary ELSE NULL END) - MAX(CASE WHEN rs.salary_rank = 2 THEN rs.salary ELSE NULL END)
    END AS "Salary Difference"
FROM
    RankedSalaries rs
JOIN
    DistinctSalaries ds ON rs.department = ds.department
GROUP BY
    rs.department
ORDER BY
    rs.department;
    
-- 145
-- You’re given two tables: users and events. The users table contains information about users, including the social media platform they belong to (platform column with values ‘LinkedIn’, ‘Meta’, or ‘Instagram’). The events table stores user interactions in the action column, which can be ‘like’, ‘comment’, or ‘post’. Please note that one user can belong to multiple social media platforms.

drop table if exists users;
CREATE TABLE users (
    user_id INT,
    name VARCHAR(255),
    platform VARCHAR(255)
);

INSERT INTO users (user_id, name, platform) VALUES
(1, 'Alice', 'LinkedIn'),
(1, 'Alice', 'Meta'),
(2, 'Bob', 'LinkedIn'),
(2, 'Bob', 'Instagram'),
(3, 'Charlie', 'Meta'),
(3, 'Charlie', 'Instagram'),
(4, 'David', 'Meta'),
(4, 'David', 'LinkedIn'),
(5, 'Eve', 'Instagram'),
(5, 'Eve', 'LinkedIn'),
(6, 'Frank', 'Instagram'),
(6, 'Frank', 'Meta');
drop table if exists events;
CREATE TABLE events (
    event_id INT,
    user_id INT,
    action VARCHAR(255),
    platform VARCHAR(255),
    created_at DATETIME
);

INSERT INTO events (event_id, user_id, action, platform, created_at) VALUES
(101, 1, 'like', 'LinkedIn', '2024-03-20 10:00:00'),
(102, 1, 'comment', 'Meta', '2024-03-21 11:00:00'),
(103, 2, 'post', 'LinkedIn', '2024-03-22 12:00:00'),
(104, 2, 'post', 'Instagram', '2024-03-22 13:00:00'),
(105, 3, 'like', 'Meta', '2024-03-23 13:00:00'),
(106, 3, 'comment', 'Instagram', '2024-03-24 14:00:00'),
(107, 4, 'post', 'Meta', '2024-03-25 15:00:00'),
(108, 4, 'like', 'LinkedIn', '2024-03-26 16:00:00'),
(109, 5, 'post', 'Instagram', '2024-03-27 17:00:00'),
(110, 5, 'like', 'LinkedIn', '2024-03-28 18:00:00'),
(111, 6, 'comment', 'Instagram', '2024-03-29 19:00:00');

SELECT
    u.platform,
    ROUND(
        (
            COUNT(DISTINCT u.user_id) - COUNT(DISTINCT e_engaged.user_id)
        ) * 100.0 / COUNT(DISTINCT u.user_id),
        2
    ) AS percentage_of_non_engaging_users
FROM
    users AS u
LEFT JOIN
    events AS e_engaged ON u.user_id = e_engaged.user_id
    AND u.platform = e_engaged.platform
    AND e_engaged.action IN ('like', 'comment')
GROUP BY
    u.platform
ORDER BY
    u.platform;

-- 146
-- Khan Academy capture data on how users are using their product, with the schemas below. Using this data they would like to report on monthly “engaged” retention rates. Monthly “engaged” retention is defined here as the % of users from each registration cohort that continued to use the product as an “engaged” user having met the threshold of >= 30 minutes per month. They are looking for the retention metric calculated for within 1-3 calendar months post registration.

drop table if exists users;
CREATE TABLE users (
    user_id VARCHAR(255),
    registration_date DATE
);

INSERT INTO users (user_id, registration_date) VALUES
('aaa', '2019-01-03'),
('bbb', '2019-01-02'),
('ccc', '2019-01-15'),
('ddd', '2019-02-07'),
('eee', '2019-02-08');

CREATE TABLE usages (
    user_id VARCHAR(255),
    usage_date DATE,
    location VARCHAR(255),
    time_spent INT
);

INSERT INTO usages (user_id, usage_date, location, time_spent) VALUES
('aaa', '2019-01-03', 'US', 38),
('aaa', '2019-02-01', 'US', 12),
('aaa', '2019-03-04', 'US', 30),
('bbb', '2019-01-03', 'US', 20),
('bbb', '2019-02-04', 'Canada', 31),
('ccc', '2019-01-16', 'US', 40),
('ddd', '2019-02-08', 'US', 45),
('eee', '2019-02-10', 'US', 20),
('eee', '2019-02-20', 'CANADA', 12),
('eee', '2019-03-15', 'US', 21),
('eee', '2019-04-25', 'US', 12);

WITH cohort_users AS (
    -- Base cohort data: users and their registration month
    SELECT
        user_id,
        DATE_FORMAT(registration_date, '%Y-%m-01') AS registration_month
    FROM
        users
),
monthly_usage AS (
    -- Calculate total time spent per user per month
    SELECT
        user_id,
        DATE_FORMAT(usage_date, '%Y-%m-01') AS usage_month,
        SUM(time_spent) AS total_time_spent
    FROM
        usages
    GROUP BY
        user_id, usage_month
),
engaged_users AS (
    -- Filter for users who are 'engaged' (>= 30 minutes per month)
    SELECT
        user_id,
        usage_month
    FROM
        monthly_usage
    WHERE
        total_time_spent >= 30
),
final_data AS (
    -- Join cohorts with engaged users to categorize retention by month post-registration
    SELECT
        cu.registration_month,
        TIMESTAMPDIFF(MONTH, cu.registration_month, eu.usage_month) + 1 AS month_number
    FROM
        cohort_users cu
    JOIN
        engaged_users eu ON cu.user_id = eu.user_id
)
SELECT
    cu.registration_month,
    COUNT(cu.user_id) AS total_users,
    ROUND(
        SUM(CASE WHEN fd.month_number = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(cu.user_id),
        2
    ) AS m1_retention,
    ROUND(
        SUM(CASE WHEN fd.month_number = 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(cu.user_id),
        2
    ) AS m2_retention,
    ROUND(
        SUM(CASE WHEN fd.month_number = 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(cu.user_id),
        2
    ) AS m3_retention
FROM
    cohort_users cu
LEFT JOIN
    final_data fd ON cu.registration_month = fd.registration_month
GROUP BY
    cu.registration_month
ORDER BY
    cu.registration_month;
    
-- 147
-- You are given a table named students with the following structure:

drop table if exists students;
CREATE TABLE students (
    student_id INT,
    skill VARCHAR(255)
);

INSERT INTO students (student_id, skill) VALUES
(1, 'SQL'),
(1, 'Python'),
(2, 'SQL'),
(3, 'Python'),
(4, 'SQL'),
(4, 'Excel'),
(5, 'SQL'),
(6, 'SQL'),
(6, 'Python'),
(6, 'Excel'),
(8, 'sql'),
(9, 'Excel');

SELECT
    student_id
FROM
    students
GROUP BY
    student_id
HAVING
    COUNT(skill) = 1
    AND MAX(LOWER(skill)) = 'sql'
ORDER BY
    student_id;
    
-- 148
-- You are given a table named employees with the following structure:
drop table if exists employees;
CREATE TABLE employees (
    employee_id INT,
    name VARCHAR(255),
    manager_id INT
);

INSERT INTO employees (employee_id, name, manager_id) VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Charlie', 10),
(4, 'David', 2),
(5, 'Eva', 12),
(6, 'Frank', 3),
(7, 'Grace', 2),
(8, 'Hank', 3),
(9, 'Ivy', 1),
(10, 'Jack', 4),
(11, 'Lily', 4),
(12, 'Megan', 15);

SELECT
    employee_id,
    name
FROM
    employees
WHERE
    employee_id NOT IN (
        SELECT manager_id
        FROM employees
        WHERE manager_id IS NOT NULL
    )
ORDER BY
    employee_id ASC;

-- 149
-- The promotions table records all historical promotions of employees (an employee can appear multiple times).
-- Write a query to find all employees who were not promoted in the last 1 year from today. Display id , name and latest promotion date for those employees order by id.

drop table if exists employees;
CREATE TABLE employees (
    id INT,
    name VARCHAR(255)
);

INSERT INTO employees (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David'),
(5, 'Eva'),
(6, 'Frank'),
(7, 'Grace'),
(8, 'Hank'),
(9, 'Ivy'),
(10, 'Jack'),
(11, 'Lily'),
(12, 'Megan');

drop table if exists promotions;
CREATE TABLE promotions (
    emp_id INT,
    promotion_date DATE
);

INSERT INTO promotions (emp_id, promotion_date) VALUES
(1, '2025-04-13'),
(2, '2025-01-13'),
(3, '2024-07-13'),
(4, '2023-12-13'),
(5, '2023-10-13'),
(6, '2023-06-13'),
(6, '2024-12-13'),
(7, '2023-08-13'),
(7, '2022-12-13'),
(8, '2022-12-13'),
(9, '2024-04-13');

WITH LatestPromotions AS (
    SELECT
        emp_id,
        MAX(promotion_date) AS latest_promo_date
    FROM
        promotions
    GROUP BY
        emp_id
)
SELECT
    e.id,
    e.name,
    lp.latest_promo_date
FROM
    employees AS e
LEFT JOIN
    LatestPromotions AS lp ON e.id = lp.emp_id
WHERE
    lp.latest_promo_date < '2024-09-17' OR lp.latest_promo_date IS NULL
ORDER BY
    e.id;
    
-- 150
-- In your organization, each employee has a fixed joining salary recorded at the time they start. Over time, employees may receive one or more promotions, each offering a certain percentage increase to their current salary.

drop table if exists employees;
CREATE TABLE employees (
    id INT,
    name VARCHAR(255),
    joining_salary INT
);

INSERT INTO employees (id, name, joining_salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 70000),
(4, 'David', 55000),
(5, 'Eva', 65000),
(6, 'Frank', 48000),
(7, 'Grace', 72000),
(8, 'Henry', 51000);

drop table if exists promotions;
CREATE TABLE promotions (
    emp_id INT,
    promotion_date DATE,
    percent_increase INT
);

INSERT INTO promotions (emp_id, promotion_date, percent_increase) VALUES
(1, '2021-01-15', 10),
(1, '2022-03-20', 20),
(2, '2023-01-01', 5),
(2, '2024-01-01', 10),
(3, '2022-05-10', 5),
(3, '2023-07-01', 10),
(3, '2024-10-10', 5),
(4, '2021-09-21', 15),
(4, '2022-09-25', 15),
(4, '2023-09-01', 15),
(4, '2024-09-30', 15);

SELECT
    e.id,
    e.name,
    ROUND(
        COALESCE(
            e.joining_salary * EXP(SUM(LOG(1 + p.percent_increase / 100.0))),
            e.joining_salary
        ), 2
    ) AS current_salary
FROM
    employees e
LEFT JOIN
    promotions p ON e.id = p.emp_id
GROUP BY
    e.id, e.name, e.joining_salary
ORDER BY
    e.id;