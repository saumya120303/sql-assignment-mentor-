create database saumya;

use saumya;


create table emp(id int, name varchar(20), salary int, profession varchar(20));

insert into emp values(1,'sam',1420,'doctor'),
(2,'shyam',2006,'actor'),
(3,'samuel',1201,'cricketer'),
(4,'sammy',5000,'singer');



select * from emp;


#1 to retrieve all the names foolowed by their professions enclosed in prantheses
select concat(name,'(', LEFT(profession,1),')') as output from emp;

#2 to find difference between average of emp table and error emp table
create table erremp(id int, name varchar(20), salary int, profession varchar(20));
insert into erremp values(1,'sam',142,'doctor'),
(2,'shyam',26,'actor'),
(3,'samuel',121,'cricketer'),
(4,'sammy',5,'singer');

select avg(emp.salary) -avg(erremp.salary) from emp join erremp on erremp.id=emp.id;

#3
create table bt(n int, p int);
insert into bt values(1,2),
(3,2),
(6,8),
(9,8),
(2,5),
(8,5),
(5, null);

select * from bt;

SELECT N,
       CASE
           WHEN P IS NULL THEN 'Root'
           WHEN (SELECT COUNT(*) FROM b WHERE P = B.N) > 0 THEN 'Inner'
           ELSE 'Leaf'
       END AS NodeType
FROM bt AS B
ORDER BY N;

#4


CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    user_id varchar(20),
    transaction_date DATE,
    product_id varchar(20),
    quantity INT
);
INSERT INTO transactions (transaction_id, user_id, transaction_date, product_id, quantity)
VALUES (1, 'U1', '2020-12-16', 'P1', 2),
(2,'U2','2020-12-16','P2',1),
(3,'U1','2020-12-16','P3',1),
(4,'U4','2020-12-16','P4',4),
(5,'U2','2020-12-17','P5',3),
(6,'U2','2020-12-17','P6',2),
(7,'U4','2020-12-18','P4',1),
(8,'U3','2020-12-19','P8',2),
(9,'U3','2020-12-19','P9',8);

SELECT 
    user_id,
    COUNT(DISTINCT transaction_date) AS purchase_days
FROM transactions GROUP BY user_id
HAVING COUNT(DISTINCT transaction_date) > 1;



#5
CREATE TABLE subscriptions (
    user_id varchar(20),
    subscription_start DATE,
    subscription_end DATE
);

insert into subscriptions values('U1','2020-01-01','2020-01-31'),
('U2','2020-01-16','2020-01-26'),
('U3','2020-01-28','2020-02-06'),
('U4','2020-02-16','2020-02-26');

SELECT 
    s1.user_id,
    CASE 
        WHEN EXISTS (
            SELECT 1
            FROM subscriptions s2
            WHERE s2.user_id != s1.user_id
            AND s2.subscription_start <= s1.subscription_end
            AND s2.subscription_end >= s1.subscription_start
        ) THEN 'True'
        ELSE 'False'
    END AS has_overlapping_subscription
FROM 
    subscriptions s1;

#6
-- Create table fb_eu_energy
CREATE TABLE fb_eu_energy (
    date DATE,
    Consumption INT
);

-- Insert sample data into fb_eu_energy
INSERT INTO fb_eu_energy (date, Consumption) VALUES
    ('2020-01-01', 400),
    ('2020-01-02', 350),
    ('2020-01-03', 500),
    ('2020-01-04', 500),
    ('2020-01-07', 600);

-- Create table fb_na_energy
CREATE TABLE fb_na_energy (
    date DATE,
    Consumption INT
);

-- Insert sample data into fb_na_energy
INSERT INTO fb_na_energy (date, Consumption) VALUES
    ('2020-01-01', 250),
    ('2020-01-02', 375),
    ('2020-01-03', 600),
    ('2020-01-06', 500),
    ('2020-01-07', 250);

-- Create table fb_asia_energy
CREATE TABLE fb_asia_energy (
    date DATE,
    Consumption INT
);

-- Insert sample data into fb_asia_energy
INSERT INTO fb_asia_energy (date, Consumption) VALUES
    ('2020-01-01', 400),
    ('2020-01-02', 400),
    ('2020-01-04', 675),
    ('2020-01-05', 1200),
    ('2020-01-06', 750);


WITH TotalEnergy AS (
    SELECT date,
           SUM(Consumption) OVER (ORDER BY date) AS cumulative_total_energy,
           SUM(Consumption) OVER () AS total_energy
    FROM (
        SELECT date, Consumption FROM fb_eu_energy
        UNION ALL
        SELECT date, Consumption FROM fb_na_energy
        UNION ALL
        SELECT date, Consumption FROM fb_asia_energy
    ) AS all_energy
)
SELECT date,
       cumulative_total_energy,
       ROUND((cumulative_total_energy * 100.0) / total_energy) AS percentage_of_total_energy
FROM TotalEnergy;
