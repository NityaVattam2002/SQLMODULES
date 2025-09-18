-- 81
-- In a financial analysis project, you are tasked with identifying companies that have consistently increased their revenue by at least 25% every year. You have a table named revenue that contains information about the revenue of different companies over several years.
-- Your goal is to find companies whose revenue has increased by at least 25% every year consecutively. So for example If a company's revenue has increased by 25% or more for three consecutive years but not for the fourth year, it will not be considered.
-- Write an SQL query to retrieve the names of companies that meet the criteria mentioned above along with total lifetime revenue , display the output in ascending order of company id
drop table if exists revenue;
CREATE TABLE revenue (
    company_id INT,
    year INT,
    revenue DECIMAL(10, 2)
);
INSERT INTO revenue (company_id, year, revenue) VALUES
(1, 2018, 10000.00),
(1, 2019, 12500.00),
(1, 2020, 15625.00),
(1, 2021, 19531.25),
(1, 2022, 24414.06),
(2, 2018, 8000.00),
(2, 2019, 10000.00),
(2, 2020, 13000.00),
(2, 2021, 15625.00),
(3, 2018, 5000.00),
(3, 2019, 6000.00),
(3, 2020, 7200.00),
(3, 2021, 8640.00),
(3, 2022, 10368.00);

SELECT 
    r1.company_id,
    SUM(r1.revenue) AS total_revenue
FROM 
    revenue r1
JOIN 
    revenue r2 ON r1.company_id = r2.company_id AND r1.year = r2.year + 1
JOIN 
    revenue r3 ON r2.company_id = r3.company_id AND r2.year = r3.year + 1
WHERE 
    r1.revenue >= r2.revenue * 1.25 AND
    r2.revenue >= r3.revenue * 1.25
GROUP BY 
    r1.company_id
ORDER BY 
    r1.company_id ASC;

-- 82
-- You are tasked to determine the mother and father's name for each child based on the given data. The people table provides information about individuals, including their names and genders. The relations table specifies parent-child relationships, linking each child (c_id) to their parent (p_id). Each parent is identified by their ID, and their gender is used to distinguish between mothers (F) and fathers (M).
CREATE TABLE people (
    id INT,
    name VARCHAR(20),
    gender CHAR(2)
);

CREATE TABLE relations (
    c_id INT,
    p_id INT
);

INSERT INTO people (id, name, gender) VALUES
(107, 'Days', 'F'),
(145, 'Hawbaker', 'M'),
(155, 'Hansel', 'F'),
(202, 'Blackston', 'M'),
(227, 'Criss', 'F'),
(278, 'Keffer', 'M'),
(329, 'Mozingo', 'F'),
(425, 'Nolf', 'M'),
(534, 'Waugh', 'M'),
(305, 'Canty', 'M');

INSERT INTO relations (c_id, p_id) VALUES
(145, 202),
(145, 107),
(278, 155),
(329, 425),
(329, 227),
(534, 586);

SELECT 
    p_child.name AS child_name,
    MAX(CASE WHEN p_parent.gender = 'F' THEN p_parent.name END) AS mother_name,
    MAX(CASE WHEN p_parent.gender = 'M' THEN p_parent.name END) AS father_name
FROM 
    relations r
JOIN 
    people p_child ON r.c_id = p_child.id
JOIN 
    people p_parent ON r.p_id = p_parent.id
GROUP BY 
    p_child.name
ORDER BY 
    p_child.name ASC;

-- 83
-- Suppose you are analyzing the purchase history of customers in an e-commerce platform. Your task is to identify customers who have bought different products on different dates.
-- Write an SQL to find customers who have bought different products on different dates, means product purchased on a given day is not repeated on any other day by the customer. Also note that for the customer to qualify he should have made purchases on at least 2 distinct dates. Please note that customer can purchase same product more than once on the same day and that doesn't disqualify him. Output should contain customer id and number of products bought by the customer in ascending order of userid.
CREATE TABLE purchase_history (
    userid INT,
    productid INT,
    purchasedate DATE
);

INSERT INTO purchase_history (userid, productid, purchasedate) VALUES
(1, 1, '2012-01-23'),
(1, 1, '2012-01-23'),
(1, 2, '2012-01-23'),
(2, 2, '2012-01-25'),
(2, 3, '2012-01-25'),
(2, 4, '2012-01-26'),
(3, 1, '2012-01-27');

SELECT 
    ph.userid,
    COUNT(DISTINCT ph.productid) AS product_count
FROM 
    purchase_history ph
GROUP BY 
    ph.userid
HAVING 
    COUNT(DISTINCT ph.purchasedate) >= 2 AND 
    COUNT(DISTINCT ph.productid || ph.purchasedate) = COUNT(DISTINCT ph.productid)
ORDER BY 
    ph.userid ASC;

-- 84
-- In a bustling city, Uber operates a fleet of drivers who provide transportation services to passengers. As part of Uber's policy, drivers are subject to a commission deduction from their total earnings. The commission rate is determined based on the average rating received by the driver over their recent trips. This ensures that drivers delivering exceptional service are rewarded with lower commission rates, while those with lower ratings are subject to higher commission rates.

CREATE TABLE trips (
    trip_id INT PRIMARY KEY,
    driver_id INT,
    fare INT,
    rating DECIMAL(3,2)
);

INSERT INTO trips (trip_id, driver_id, fare, rating) VALUES
(1, 101, 200, 4.8),
(2, 101, 150, 4.6),
(3, 101, 300, 4.7),
(4, 101, 250, 4.9),
(5, 101, 180, 4.5),
(6, 101, 220, 4.3),
(7, 102, 100, 4.2),
(8, 102, 120, 4.5),
(9, 102, 180, 4.8),
(10, 102, 200, 4.6),
(11, 102, 300, 4.9),
(12, 103, 400, 5.0),
(13, 103, 350, 4.9),
(14, 103, 300, 4.8),
(15, 103, 200, 4.6),
(16, 103, 180, 4.4);

SELECT d.driver_id,
       ROUND(SUM(
         CASE 
           WHEN t.trip_num <= 3 THEN t.fare * (1 - 0.24)   
           WHEN AVG(last3.rating) OVER (PARTITION BY t.driver_id ORDER BY t.trip_num 
                                        ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) >= 4.7 
             THEN t.fare * (1 - 0.20)
           WHEN AVG(last3.rating) OVER (PARTITION BY t.driver_id ORDER BY t.trip_num 
                                        ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) >= 4.5 
             THEN t.fare * (1 - 0.23)
           ELSE t.fare * (1 - 0.24)
         END
       ),2) AS total_net_earnings
FROM (
    SELECT tr1.trip_id,
           tr1.driver_id,
           tr1.fare,
           tr1.rating,
           COUNT(*) AS trip_num
    FROM trips tr1
    JOIN trips tr2 
      ON tr1.driver_id = tr2.driver_id
     AND tr1.trip_id >= tr2.trip_id
    GROUP BY tr1.trip_id, tr1.driver_id, tr1.fare, tr1.rating
) t
JOIN trips d ON t.driver_id = d.driver_id
GROUP BY d.driver_id
ORDER BY d.driver_id;

-- 85
-- You are working for a customer support team at an e-commerce company. The company provides customer support through both web-based chat and mobile app chat. Each conversation between a customer and a support agent is logged in a database table named conversation. The table contains information about the sender (customer or agent), the message content, the order related to the conversation, and other relevant details.
-- Your task is to analyze the conversation data to extract meaningful insights for improving customer support efficiency. Write an SQL query to fetch the following information from the conversation table for each order_id and sort the output by order_id.

CREATE TABLE conversation (
    senderDeviceType VARCHAR(20),
    customerId INT,
    orderId VARCHAR(10),
    resolution VARCHAR(10),
    agentId INT,
    messageSentTime DATETIME,
    cityCode VARCHAR(6)
);

INSERT INTO conversation (senderDeviceType, customerId, orderId, resolution, agentId, messageSentTime, cityCode) VALUES
('Android Customer', 17071099, '59528555', 'True', NULL, '2019-08-19 08:01:00', 'NYC'),
('Web Customer', 17071099, '59528555', 'False', NULL, '2019-08-19 08:01:00', 'NYC'),
('Android Customer', 12871241, '59528830', 'False', NULL, '2019-08-19 07:59:00', 'LA'),
('Web Agent', 12345678, '59528830', 'False', 87654321, '2019-08-19 09:00:00', 'LA'),
('Web Agent', 98765432, '59528557', 'False', 98765432, '2019-08-19 09:05:00', 'NYC'),
('Android Customer', 24681357, '59528557', 'False', NULL, '2019-08-19 09:10:00', 'NYC');

SELECT 
    orderId,
    cityCode,
    MIN(CASE WHEN senderDeviceType LIKE '%Agent%' THEN messageSentTime END) AS first_agent_message,
    MIN(CASE WHEN senderDeviceType LIKE '%Customer%' THEN messageSentTime END) AS first_customer_message,
    COUNT(CASE WHEN senderDeviceType LIKE '%Agent%' THEN 1 END) AS num_messages_agent,
    COUNT(CASE WHEN senderDeviceType LIKE '%Customer%' THEN 1 END) AS num_messages_customer,
    CASE 
        WHEN MIN(senderDeviceType) LIKE '%Agent%' THEN 'Agent'
        ELSE 'Customer'
    END AS first_message_by,
    MAX(CASE WHEN resolution = 'True' THEN 1 ELSE 0 END) AS resolved,
    CASE 
        WHEN COUNT(DISTINCT agentId) > 1 THEN 1
        ELSE 0
    END AS reassigned
FROM 
    conversation
GROUP BY 
    orderId, cityCode
ORDER BY 
    orderId;


-- 86
-- In the Indian Premier League (IPL), each team plays two matches against every other team: one at their home venue and one at their opponent's venue. We want to identify team combinations where each team wins the away match but loses the home match against the same opponent. Write an SQL query to find such team combinations, where each team wins at the opponent's venue but loses at their own home venue.

CREATE TABLE Matches (
    match_id INT,
    home_team VARCHAR(10),
    away_team VARCHAR(10),
    winner_team VARCHAR(10)
);

INSERT INTO Matches (match_id, home_team, away_team, winner_team) VALUES
(1, 'CSK', 'MI', 'MI'),
(2, 'GL', 'RR', 'RR'),
(3, 'Kings11', 'SRH', 'SRH'),
(4, 'DD', 'KKR', 'KKR'),
(5, 'RR', 'GL', 'GL'),
(6, 'Kings11', 'SRH', 'Kings11'),
(7, 'KKR', 'DD', 'DD'),
(8, 'MI', 'CSK', 'CSK');

SELECT 
    m1.home_team AS team1,
    m1.away_team AS team2
FROM 
    Matches m1
JOIN 
    Matches m2 ON m1.home_team = m2.away_team AND m1.away_team = m2.home_team
WHERE 
    m1.winner_team = m2.away_team AND 
    m2.winner_team = m1.home_team
GROUP BY 
    m1.home_team, m1.away_team;


-- 87
-- You are tasked with writing an SQL query to determine whether a leave request can be approved for each employee based on their available leave balance for 2024. Employees receive 1.5 leaves at the start of each month, and they may have some balance leaves carried over from the previous year 2023(available in employees table). A leave request can only be approved if the employee has a sufficient leave balance at the start date of planned leave period.
drop table if exists employees;
CREATE TABLE employees (
    employee_id INT,
    leave_balance_from_2023 INT,
    name VARCHAR(20)
);

CREATE TABLE leave_requests (
    request_id INT,
    employee_id INT,
    leave_start_date DATE,
    leave_end_date DATE
);


INSERT INTO employees (employee_id, leave_balance_from_2023, name) VALUES
(1, 5, 'John Doe'),
(2, 6, 'Jane Smith'),
(3, 4, 'Alice Johnson');

INSERT INTO leave_requests (request_id, employee_id, leave_start_date, leave_end_date) VALUES
(1, 1, '2024-01-05', '2024-01-15'),
(2, 1, '2024-01-21', '2024-01-27'),
(3, 2, '2024-02-12', '2024-02-17'),
(4, 2, '2024-07-04', '2024-07-12'),
(5, 1, '2024-03-20', '2024-03-25');

SELECT 
    lr.request_id,
    lr.employee_id,
    CASE 
        WHEN (e.leave_balance_from_2023 + (1.5 * 12)) >= (DATEDIFF(lr.leave_end_date, lr.leave_start_date) + 1) THEN 'Approved'
        ELSE 'Rejected'
    END AS leave_status
FROM 
    leave_requests lr
JOIN 
    employees e ON lr.employee_id = e.employee_id
ORDER BY 
    lr.request_id;

-- 88
-- In the Netflix dataset containing information about viewers and their viewing history, devise a query to identify viewers who primarily use mobile devices for viewing, but occasionally switch to other devices. Specifically, find viewers who have watched at least 75% of their total viewing time on mobile devices but have also used at least one other devices such as tablets or smart TVs for viewing. Provide the user ID and the percentage of viewing time spent on mobile devices. Round the result to nearest integer.
CREATE TABLE viewing_history (
    user_id INT,
    title VARCHAR(20),
    device_type VARCHAR(10),
    watch_mins INT
);

INSERT INTO viewing_history (user_id, title, device_type, watch_mins) VALUES
(1, 'Stranger Things', 'Mobile', 60),
(1, 'The Crown', 'Mobile', 45),
(1, 'Narcos', 'Smart TV', 100),
(2, 'Stranger Things', 'Mobile', 55),
(2, 'The Crown', 'Tablet', 80),
(2, 'Narcos', 'Mobile', 70),
(3, 'Stranger Things', 'Mobile', 90),
(3, 'The Crown', 'Smart TV', 20);

SELECT 
    user_id,
    ROUND(SUM(CASE WHEN device_type = 'Mobile' THEN watch_mins ELSE 0 END) * 100.0 / SUM(watch_mins)) AS mobile_percentage
FROM 
    viewing_history
GROUP BY 
    user_id
HAVING 
    ROUND(SUM(CASE WHEN device_type = 'Mobile' THEN watch_mins ELSE 0 END) * 100.0 / SUM(watch_mins)) >= 75
    AND COUNT(DISTINCT CASE WHEN device_type != 'Mobile' THEN device_type END) > 0;

-- 89
-- In the Netflix viewing history dataset, you are tasked with identifying viewers who have a consistent viewing pattern across multiple devices. Specifically, viewers who have watched the same title on more than 1 device type.
-- Write an SQL query to find users who have watched more number of titles on multiple devices than the number of titles they watched on single device. Output the user id , no of titles watched on multiple devices and no of titles watched on single device, display the output in ascending order of user_id.

drop table if exists viewing_history;
CREATE TABLE viewing_history (
    user_id INT,
    title VARCHAR(20),
    device_type VARCHAR(10)
);

INSERT INTO viewing_history (user_id, title, device_type) VALUES
(1, 'Stranger Things', 'Mobile'),
(1, 'Stranger Things', 'Smart TV'),
(1, 'The Crown', 'Mobile'),
(2, 'Narcos', 'Tablet'),
(2, 'Narcos', 'Mobile'),
(2, 'The Crown', 'Tablet'),
(3, 'Stranger Things', 'Mobile'),
(3, 'The Crown', 'Smart TV'),
(3, 'Narcos', 'Smart TV');

SELECT 
    user_id,
    COUNT(DISTINCT title) AS titles_watched_on_multiple_devices,
    COUNT(DISTINCT CASE WHEN device_count = 1 THEN title END) AS titles_watched_on_single_device
FROM (
    SELECT 
        user_id,
        title,
        COUNT(DISTINCT device_type) AS device_count
    FROM 
        viewing_history
    GROUP BY 
        user_id, title
) AS title_device_counts
GROUP BY 
    user_id
HAVING 
    COUNT(DISTINCT title) > COUNT(DISTINCT CASE WHEN device_count = 1 THEN title END)
ORDER BY 
    user_id ASC;

-- 91
-- You are provided with election data from multiple districts in India. Each district conducted elections for selecting a representative from various political parties. Your task is to analyze the election results to determine the winning party at national levels. Here are the steps to identify winner:
-- 1- Determine the winning party in each district based on the candidate with the highest number of votes.
-- 2- If multiple candidates from different parties have the same highest number of votes in a district
-- , consider it a tie, and all tied candidates are declared winners for that district.
-- 3- Calculate the total number of seats won by each party across all districts
-- 4- A party wins the election if it secures more than 50% of the total seats available nationwide.
-- Display the total number of seats won by each party and a result column specifying Winner or Loser. Order the output by total seats won in descending order.

CREATE TABLE elections (
    district_name VARCHAR(20),
    candidate_id INT,
    party_name VARCHAR(10),
    votes INT
);
INSERT INTO elections (district_name, candidate_id, party_name, votes) VALUES
('Delhi North', 101, 'Congress', 1500),
('Delhi North', 102, 'BJP', 1500),
('Mumbai South', 106, 'Congress', 2000),
('Mumbai South', 107, 'BJP', 1800),
('Kolkata East', 111, 'BJP', 2200),
('Kolkata East', 114, 'AAP', 1500),
('Chennai Central', 116, 'Congress', 1900),
('Chennai Central', 117, 'BJP', 1700);

SELECT 
    party_name,
    COUNT(DISTINCT district_name) AS total_seats,
    CASE 
        WHEN COUNT(DISTINCT district_name) > (SELECT COUNT(DISTINCT district_name) FROM elections) / 2 THEN 'Winner'
        ELSE 'Loser'
    END AS result
FROM (
    SELECT 
        district_name,
        party_name,
        votes,
        RANK() OVER (PARTITION BY district_name ORDER BY votes DESC) AS vote_rank
    FROM 
        elections
) AS ranked_candidates
WHERE 
    vote_rank = 1
GROUP BY 
    party_name
ORDER BY 
    total_seats DESC;

-- 92
-- A pizza eating competition is organized. All the participants are organized into different groups. In a contest , A participant who eat the most pieces of pizza is the winner and recieves their original bet plus 30% of all losing participants bets. In case of a tie all winning participants will get equal share (of 30%) divided among them .Return the winning participants' names for each group and amount of their payout(round to 2 decimal places) . ordered ascending by group_id , participant_name.

CREATE TABLE Competition (
    group_id INT,
    participant_name VARCHAR(10),
    slice_count INT,
    bet INT
);
INSERT INTO Competition (group_id, participant_name, slice_count, bet) VALUES
(1, 'Alice', 10, 51),
(1, 'Bob', 15, 42),
(1, 'Eve', 8, 21),
(1, 'Tom', 12, 30),
(2, 'Jerry', 20, 50),
(2, 'Charlie', 12, 40),
(2, 'David', 10, 35),
(2, 'Mike', 15, 30),
(2, 'Nancy', 8, 20),
(2, 'Oliver', 12, 30),
(3, 'Frank', 12, 51);

SELECT 
    c.group_id,
    c.participant_name,
    ROUND(c.bet + (30.0 * (total_bets - CASE WHEN max_slices = c.slice_count THEN c.bet ELSE 0 END) / (COUNT(*) - 1)), 2) AS payout
FROM 
    Competition c
JOIN 
    (SELECT 
         group_id,
         SUM(bet) AS total_bets,
         MAX(slice_count) AS max_slices
     FROM 
         Competition
     GROUP BY 
         group_id) AS totals ON c.group_id = totals.group_id
WHERE 
    c.slice_count = totals.max_slices
GROUP BY 
    c.group_id, c.participant_name, c.bet, totals.total_bets, totals.max_slices
ORDER BY 
    c.group_id ASC, c.participant_name ASC;

-- 98
-- You are given a history of credit card transaction data for the people of India across cities as below. Your task is to find out highest spend card type and lowest spent card type for each city, display the output in ascending order of city.
drop table if exists credit_card_transactions;
CREATE TABLE credit_card_transactions (
    transaction_id INT,
    city VARCHAR(10),
    transaction_date DATE,
    card_type VARCHAR(12),
    gender VARCHAR(1),
    amount INT
);

INSERT INTO credit_card_transactions (transaction_id, city, transaction_date, card_type, gender, amount) VALUES
(1, 'Delhi', '2024-01-13', 'Gold', 'F', 500),
(2, 'Bengaluru', '2024-01-13', 'Silver', 'M', 1000),
(3, 'Mumbai', '2024-01-14', 'Gold', 'F', 900),
(4, 'Bengaluru', '2024-01-14', 'Gold', 'M', 800),
(5, 'Delhi', '2024-01-15', 'Platinum', 'M', 1200),
(6, 'Mumbai', '2024-01-15', 'Silver', 'F', 700),
(7, 'Mumbai', '2024-01-16', 'Platinum', 'M', 1250),
(8, 'Bengaluru', '2024-01-16', 'Platinum', 'F', 1100);

SELECT 
    city,
    MAX(card_type) AS highest_spend_card,
    MIN(card_type) AS lowest_spend_card
FROM (
    SELECT 
        city,
        card_type,
        SUM(amount) AS total_spent
    FROM 
        credit_card_transactions
    GROUP BY 
        city, card_type
) AS totals
GROUP BY 
    city
ORDER BY 
    city ASC;

-- 99
-- You are a facilities manager at a corporate office building, responsible for tracking employee visits, floor preferences, and resource usage within the premises. The office building has multiple floors, each equipped with various resources such as desks, computers, monitors, and other office supplies. You have a database table “entries” that stores information about employee visits to the office building. Each record in the table represents a visit by an employee and includes details such as their name, the floor they visited, and the resources they used during their visit.
-- Write an SQL query to retrieve the total visits, most visited floor, and resources used by each employee, display the output in ascending order of employee name.

CREATE TABLE entries (
    emp_name VARCHAR(10),
    address VARCHAR(10),
    floor INT,
    resources VARCHAR(10)
);
INSERT INTO entries (emp_name, address, floor, resources) VALUES
('Ankit', 'Bangalore', 1, 'CPU'),
('Ankit', 'Bangalore', 1, 'CPU'),
('Ankit', 'Bangalore', 2, 'DESKTOP'),
('Bikaas', 'Bangalore', 2, 'DESKTOP'),
('Bikaas', 'Bangalore', 2, 'MONITOR');

















