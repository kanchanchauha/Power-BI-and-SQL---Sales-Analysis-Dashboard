 Task 1. Create and Use Database
   
CREATE DATABASE coffee_shop_sales_db;
USE coffee_shop_sales_db;

Task 2. Rename Table
ALTER TABLE `coffee shop sales`
RENAME TO coffee_shop_sales;

Task 3. Describe Table Structure
DESCRIBE coffee_shop_sales;

Task 4. Change Data Type of transaction_date & transaction_time
-- Convert and change column type
UPDATE coffee_shop_sales 
SET transaction_date = STR_TO_DATE(transaction_date, '%d-%m-%Y');

ALTER TABLE coffee_shop_sales
MODIFY transaction_date DATE;


-- Convert and change column type
UPDATE coffee_shop_sales 
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');

ALTER TABLE coffee_shop_sales
MODIFY transaction_time TIME;


Task 6. Rename Column
ALTER TABLE coffee_shop_sales
CHANGE COLUMN ï»¿transaction_id transaction_id INT PRIMARY KEY;


Task 7. Calculate Total Sales for February
SELECT ROUND(SUM(transaction_qty * unit_price), 2) AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 2; -- February


Task 8. Monthly Sales Summary
SELECT 
    MONTH(transaction_date) AS month_num,
    MONTHNAME(transaction_date) AS month_name,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_sales
FROM coffee_shop_sales
GROUP BY MONTH(transaction_date), MONTHNAME(transaction_date);


Task 9. Month-over-Month Sales Change
SELECT
  month_num AS month,
  month_name AS Name,
  ROUND(total_sales, 2) AS total_sales,

  -- Absolute difference
  total_sales - LAG(total_sales) OVER (ORDER BY month_num) AS previous_month_sales,

  -- Percent change
  ROUND(
    (total_sales - LAG(total_sales) OVER (ORDER BY month_num)) /
    NULLIF(LAG(total_sales) OVER (ORDER BY month_num), 0) * 100,
    2
  ) AS percent_change

FROM (
  SELECT
    MONTH(transaction_date) AS month_num,
    MONTHNAME(transaction_date) AS month_name,
    SUM(transaction_qty * unit_price) AS total_sales
  FROM coffee_shop_sales
  GROUP BY MONTH(transaction_date), MONTHNAME(transaction_date)
) AS monthly_summary;


Task 10. Total Number of Orders in February
SELECT COUNT(*) AS total_orders
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 2;


Task 11. Sales Comparison: Weekdays vs Weekends
SELECT
  CASE 
    WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
    ELSE 'Weekdays'
  END AS day_type,
  
  CONCAT(ROUND(SUM(transaction_qty * unit_price) / 1000, 2), 'K') AS total_sales
FROM coffee_shop_sales
GROUP BY 
  CASE 
    WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
    ELSE 'Weekdays'
  END;

