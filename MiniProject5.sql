SHOW databases;
USE classicmodels;

-- 1. Product ranking by price within product lines

SELECT * FROM products;
SELECT productLine, productName, MSRP,
-- PARTITION BY() is used to divide data into groups. It is dividing the products on the basis of product line.
-- ORDER BY() is used to order the values in a column either in ascending or descending order.
	   ROW_NUMBER() OVER(PARTITION BY productLine ORDER BY MSRP DESC) AS price_rank, -- ROW_NUMBER() is used to assign a unique number to the rows including the duplicate values.
       RANK() OVER(PARTITION BY productLine ORDER BY MSRP DESC) AS price_rank_R, -- RANK() is used to rank each row in a column and this function skips the duplicate value ranks. 
       DENSE_RANK() OVER(PARTITION BY productLine ORDER BY MSRP DESC) AS price_rank_D -- DENSE_RANK() is used to rank each row without skipping the duplicates.
FROM products;

-- 2. Calculating Running Total of Payments per Customer
-- This is used to find the total payment by a customer.
SELECT * FROM payments;
SELECT customerNumber, paymentDate, amount,
    SUM(amount) OVER(PARTITION BY customerNumber ORDER BY paymentDate) AS running_payment_total -- PARTITION BY() is used to divide the customers based on the customer number to get the total payment of each customer.
FROM payments;

-- 3. Highest Ranked Products Within Product Lines

WITH RankedProducts AS (
		SELECT productLine, productName, MSRP,
		ROW_NUMBER() OVER(PARTITION BY productLine ORDER BY MSRP DESC) AS row_num
		FROM products
        )
        SELECT productLine, productName, MSRP, row_num
        FROM RankedProducts
        WHERE row_num <= 1;

-- 3. Top 3 Most Expensive Products per Product Line

WITH RankedProducts AS (
		SELECT productLine, productName, MSRP,
		ROW_NUMBER() OVER(PARTITION BY productLine ORDER BY MSRP DESC) AS row_num
		FROM products
        )
        SELECT productLine, productName, MSRP, row_num
        FROM RankedProducts
        WHERE row_num <= 3;
        
-- 4. Month-over-Month Sales Comparision

WITH MonthlySales AS (
		SELECT
			DATE_FORMAT(paymentDate, '%Y-%m') AS sales_month,
            SUM(amount) AS total_sales
		FROM payments
        GROUP BY sales_month
)
 SELECT sales_month, total_sales,
        LAG(total_sales,1) OVER(ORDER BY sales_month) AS previous_month_sales, -- LAG() goes 1 row back to find the previous values.
-- 5. This is used to find the growth or decline in sales compared to the previous month
        ROUND(total_sales- LAG(total_sales,1) OVER(ORDER BY sales_month),2) AS monthly_growth
FROM MonthlySales;

-- 6. 3-Month Moving Average of Sales

WITH MonthlySales AS (
    SELECT
        DATE_FORMAT(paymentDate, '%Y-%m') AS sales_month,
        SUM(amount) AS total_sales
    FROM payments
    GROUP BY sales_month
),
LaggedSales AS (
    SELECT sales_month, total_sales,
        LAG(total_sales, 1) OVER (ORDER BY sales_month) AS prev_month,
        LAG(total_sales, 2) OVER (ORDER BY sales_month) AS prev_2_months,
        ROW_NUMBER() OVER (ORDER BY sales_month) AS month_num
    FROM MonthlySales
)
SELECT sales_month, total_sales,
    ROUND(
        (total_sales + prev_month + prev_2_months) / 
        LEAST(month_num, 3), 
        2
    ) AS moving_avg_3_months
FROM LaggedSales;






