USE [GitProjects]
GO

SELECT [Product_ID]
      ,[Sale_Date]
      ,[Sales_Rep]
      ,[Region]
      ,[Sales_Amount]
      ,[Quantity_Sold]
      ,[Product_Category]
      ,[Unit_Cost]
      ,[Unit_Price]
      ,[Customer_Type]
      ,[Discount]
      ,[Payment_Method]
      ,[Sales_Channel]
      ,[Region_and_Sales_Rep]
  FROM [dbo].[sales_data1]

GO

ALTER TABLE [sales_data1]
DROP COLUMN Unit_Cost, Unit_Price,Discount;

SELECT * FROM [sales_data1]

--BASIC QUERIES
--1. Retrieve all sales data for the year 2024.
SELECT * FROM [sales_data1]
WHERE YEAR(SALE_DATE) = 2024

--2. Find the total sales amount for each year (2024 & 2025).
SELECT YEAR(SALE_DATE)[YEAR], CEILING(SUM(SALES_AMOUNT))[TOTAL SUM] FROM [sales_data1] 
WHERE YEAR(Sale_Date) IN (2024, 2025)
GROUP BY YEAR(SALE_DATE);

--3.List all unique product categories sold in 2024.
SELECT DISTINCT(PRODUCT_CATEGORY) FROM [sales_data1]
WHERE YEAR(SALE_DATE) = 2024;
--4.
SELECT * FROM [sales_data1]
-- INTERMEDIATE QUERIES
--5. Find the top 5 sales representatives with the highest total sales amount. 
SELECT REGION_AND_SALES_REP,[TOTALSALES] FROM(
SELECT
	REGION_AND_SALES_REP,
	SUM(SALES_AMOUNT)[TOTALSALES],
	RANK() OVER(ORDER BY SUM(SALES_AMOUNT)DESC)[RANK]
FROM [sales_data1]
GROUP BY REGION_AND_SALES_REP)T
WHERE [RANK] <=5

SELECT TOP 5 Sales_Rep, SUM(Sales_Amount) AS Total_Sales 
FROM [sales_data1] 
GROUP BY Sales_Rep 
ORDER BY Total_Sales DESC ;

--6. Identify the region with the highest sales in 2024.
SELECT REGION , CEILING(SUM(SALES_AMOUNT)) AS [TOTAL SALES] FROM [sales_data1]
WHERE YEAR(SALE_DATE) =2024
GROUP BY REGION
ORDER BY SUM(SALES_AMOUNT) DESC;

--7. Get the count of sales transactions made via each payment method.
SELECT PAYMENT_METHOD, COUNT(*)[CtnTransac] FROM [sales_data1]
GROUP BY PAYMENT_METHOD
ORDER BY [CtnTransac] desc;

--8 Get the count of sales transcations made vua sale channel.
SELECT SALES_CHANNEL, COUNT(*)[CtnTransac] FROM [sales_data1]
GROUP BY SALES_CHANNEL
ORDER BY [CtnTransac] desc;

-- 9 Find the month with the highest sales amount in 2025.
SELECT TOP 1 
	DATENAME(MONTH,SALE_DATE)[MONTH], 
	CEILING(SUM(SALES_AMOUNT))[TOTAL AMOUNT] 
FROM [sales_data1]
WHERE YEAR(SALE_DATE) = 2025
GROUP BY DATENAME(MONTH,SALE_DATE)
ORDER BY SUM(SALES_AMOUNT)

--ADVANCED QUERIES
--10 Find the top 3 best-selling products (by total sales) in 2023.
SELECT TOP 3
	PRODUCT_CATEGORY,
	SUM(SALES_AMOUNT)[TOTAL SALES],
	ROW_NUMBER() OVER(ORDER BY SUM(SALES_AMOUNT)DESC)[RANK]
FROM [sales_data1]
GROUP BY PRODUCT_CATEGORY

--11. Calculate total revenue after discounts for each sales channel.
SELECT Sales_Channel, SUM(Sales_Amount * (1 - Discount)) AS Total_Revenue 
FROM [sales_data1] 
GROUP BY Sales_Channel;


--12 Identify customers who made multiple purchases (returning customers).
SELECT 
	CUSTOMER_TYPE, 
	COUNT(*) AS [TOTAL TRANSACTIONS]
FROM [sales_data1]
WHERE CUSTOMER_TYPE = 'Returning'
GROUP BY CUSTOMER_TYPE;

--13. Find the sales rep with the highest average sales amount per transaction.
SELECT TOP 1
	SALES_REP,
	AVG(SALES_AMOUNT)[AVG SALES]
FROM [sales_data1]
GROUP BY SALES_REP
ORDER BY AVG(SALES_AMOUNT) DESC

--14. Calculate the total profit per product category (assuming profit = unit price - unit cost).
SELECT Product_Category, 
       SUM((Unit_Price - Unit_Cost) * Quantity_Sold) AS Total_Profit 
FROM [sales_data1] 
GROUP BY Product_Category;

-- 15. Find the most frequently used payment method for online sales.
SELECT TOP 1
	PAYMENT_METHOD, COUNT(*) AS USAGE_COUNT 
FROM [sales_data1] 
WHERE SALES_CHANNEL = 'ONLINE' 
GROUP BY PAYMENT_METHOD 
ORDER BY USAGE_COUNT DESC 

