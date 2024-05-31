-- MELCHIZEDEK ACKAH-BLAY
-- CARS DATA PROJECT
-- 30 MAY 2024


-- CREATING DATABASE FOR THE PROJECT
CREATE DATABASE c;
USE c;

-- CLEANING THE DATA
ALTER TABLE car RENAME COLUMN __year_resale_value TO Resale_Value;
ALTER TABLE car DROP COLUMN Power_perf_factor;

-- EXPLORATORY DATA ANALYSIS

-- 1. Top Manufacturers by Sales: Which manufacturers have the highest total sales?

SELECT Manufacturer,  SUM(Sales_in_thousands) AS Total_Sales
FROM car
GROUP BY Manufacturer
ORDER BY Total_Sales DESC
LIMIT 5;
-- The top 5 manufacturers were Ford, Dodge, Toyota, Honda, and Chevrolet



-- 2. Sales Distribution: How are sales distributed across different manufacturers?
SELECT Manufacturer, Vehicle_type, COUNT(Vehicle_type) AS Total
FROM car
GROUP BY Manufacturer, Vehicle_type
ORDER BY Total DESC;
-- For most manufacturers, the most sold cars were passenger cars. For context, passenger cars make up 8 of the top 10 most sold
-- vehicle types



-- 3. Average Resale Value by Vehicle Type: What is the average resale value for each type of vehicle?
SELECT Vehicle_type, AVG(Resale_Value) AS Average_Resale_Value
FROM car
GROUP BY Vehicle_type
ORDER BY Average_Resale_Value DESC;
-- Passenger vehicles have the highest average resale value



-- 4. Price vs. Resale Value: What is the relationship between the price of a vehicle and its resale value?
SELECT Price_in_thousands, Resale_Value
FROM car
ORDER BY Resale_Value DESC;
-- Generally, the higher the price of a vehicle, the higher the resale value



-- 5. Fuel Efficiency Leaders: Which models have the highest fuel efficiency within each vehicle type?
SELECT Model, AVG(Fuel_efficiency) AS Average_Fuel_Efficiency
FROM car
GROUP BY Model
ORDER BY Average_Fuel_Efficiency DESC
LIMIT 5;
-- The top 5 cars with the best average fuel efficiency are: Metro, SC, Prizm, Corolla, and SL



-- 6. Horsepower by Vehicle Type: How does horsepower vary across different vehicle types?
SELECT Vehicle_type, AVG(Horsepower) AS Average_HorsePower
FROM car
GROUP BY Vehicle_type
ORDER BY Average_HorsePower DESC;
-- Passenger vehicles have high horsepower on average compared to Car vehicles



-- 7. Engine Size Distribution: What is the distribution of engine sizes across different manufacturers?
SELECT Manufacturer, AVG(Engine_size) AS Average_Engine_Size
FROM car
GROUP BY Manufacturer
ORDER BY Average_Engine_Size DESC;

SELECT AVG(Engine_size) AS Average_Engine_Size
FROM car;
-- Lincoln has the biggest average engine size of 4.6 with quite a margin(0.6). Saturn has the smallest average engine size of all
-- vehicle types. The average engine size of all vehicles is 3.05



-- 8. Heaviest and Lightest Vehicles: Which vehicles have the highest and lowest curb weight?
SELECT Manufacturer, Model, AVG(Curb_weight) AS Average_Curb_Weight
FROM car
GROUP BY Manufacturer, Model
ORDER BY Average_Curb_Weight DESC
LIMIT 3;
-- Toyota Land Cruiser, Ford Expedition and Mitsubishi Montero have the highest curb weight
SELECT Manufacturer, Model, AVG(Curb_weight) AS Average_Curb_Weight
FROM car
GROUP BY Manufacturer, Model
ORDER BY Average_Curb_Weight 
LIMIT 3;
-- Chevrolet Metro, Hyundai Accent and Mitsubishi Mirage have the lowest curb weight



-- 9. Wheelbase vs. Length: How does the wheelbase length correlate with the overall length of the vehicle?
SELECT Wheelbase, Length
FROM car
ORDER BY Wheelbase DESC;
-- Generally, the bigger the wheel base, the longer the car



-- 10. Vehicle Width by Manufacturer: Are there significant differences in vehicle width among different manufacturers?
SELECT Manufacturer, AVG(Width) AS Average_Vehicle_Width
FROM car
GROUP BY Manufacturer
ORDER BY Average_Vehicle_Width DESC;
-- Lincoln, which I found to make the biggest engines also make the widest cars followed by Dodge and Plymouth
-- Saturn, which I found to make the smallest engines also make the least wide cars followed closely by Volkswagen and Hyundai



-- 11. Fuel Capacity by Price Range: What is the average fuel capacity for vehicles in different price ranges?
ALTER TABLE car ADD Price_Category VARCHAR(20);

UPDATE car
SET Price_Category =  CASE
WHEN Price_in_thousands > 70 THEN 'Expensive'
WHEN Price_in_thousands > 35 THEN 'Slightly Costly'
ELSE 'Cheap'
END;

SELECT Price_Category, AVG(Fuel_efficiency) AS Average_Fuel_Efficiency
FROM car
GROUP BY Price_Category
ORDER BY Average_Fuel_Efficiency DESC;
-- Cheap cars (priced under $35,000) have the best fuel efficiency at 24.74, followed by Expensive cars at 21.33 and Slighly Costly
-- cars at 21.12



-- 12. Average Sales by Vehicle Type: What is the average sales volume for each vehicle type?
SELECT Vehicle_type, AVG(Sales_in_thousands) AS Average_Sales
FROM car
GROUP BY Vehicle_type
ORDER BY Average_Sales DESC;
-- Car vehicle types have the biggest average sales of 95,406 which is more than double that of passenger vehicles at 46,781



-- 13. High Resale Value Models: Which vehicle models have the highest resale value compared to their original price?
SELECT Model, Resale_Value - Price_in_thousands AS Net_Price
FROM car
ORDER BY Net_Price DESC;
-- CL has the best resale value with a profit of $18,225.00 followed by Boxter with a slight loss of $179.00 and Wrangler with
-- a slight loss of $985.00



-- 14. Top and Bottom Price Vehicles: What are the most and least expensive vehicles in the dataset?
SELECT MIN(Price_in_thousands), MAX(Price_in_thousands)
FROM car;
-- The most expensive vehicle is $96,990.00. The least expensive car is $10,685.00



-- 15. Popular Vehicle Types: What are the most popular vehicle types in terms of sales?
SELECT Vehicle_type, SUM(Sales_in_thousands) AS Total_Sales
FROM car
GROUP BY Vehicle_type
ORDER BY Total_Sales DESC;
-- Passenger vehicles have the largest share of the total sales at $4,163,476



-- 16. Engine Size and Fuel Efficiency: How does engine size affect fuel efficiency across different models?
SELECT Model, Engine_size, AVG(Fuel_efficiency) AS Average_Fuel_Efficiency
FROM car
GROUP BY Model, Engine_size
ORDER BY Engine_size DESC;
-- Models with engine sizes less than 2 tend to have the best fuel efficiency on average



-- 17. Performance Metrics: What are the key performance metrics (e.g., horsepower, fuel efficiency) for the top-selling models?
SELECT model, SUM(Sales_in_thousands) AS Sales,  AVG(Horsepower) AS Average_Horsepower, AVG(Fuel_efficiency) AS Average_FuelEfficiency
FROM car
GROUP BY model
ORDER BY Sales DESC;

SELECT AVG(Horsepower) AS Average_Horspower, AVG(Fuel_efficiency) AS Average_FuelEfficiency
FROM car;

-- The best selling models have selling models with a much HIGHER horspower than the average of all models.
-- With regard to fuel efficiency, some of the best selling models have better fuel efficiency than average and some have lower
-- fuel efficiency. For example in the top 10 best selling cars, 6 of them have a LOWER fuel efficiency than the average of all the
-- vehicles




-- ADVANCED ANALYSIS QUESTIONS 


-- 1. Seasonal Sales Trends: Are there any seasonal trends in sales if the dataset includes time data?

-- extracting month column
ALTER TABLE car ADD launch_month DATETIME;

ALTER TABLE car
MODIFY COLUMN launch_month VARCHAR(20);

-- filling month column with data
UPDATE car
SET launch_month = MONTHNAME(STR_TO_DATE(Latest_Launch, '%m/%d/%Y'));

-- extracting year column
ALTER TABLE car ADD COLUMN launch_year INTEGER;

-- filling year column with data
UPDATE car
SET launch_year = YEAR(STR_TO_DATE(Latest_Launch, '%m/%d/%Y'));

-- extracting quarter column
ALTER TABLE car ADD COLUMN launch_quarter INTEGER;

-- filling column quarter with data
UPDATE car
SET launch_quarter = QUARTER(STR_TO_DATE(Latest_Launch, '%m/%d/%Y'));

-- answering question based on launch month
SELECT launch_month, AVG(Sales_in_thousands) AS Total_Sales
FROM car
GROUP BY  launch_month
ORDER BY Total_Sales DESC;
-- Cars launched in August have the highest average sales by quite a margin from December which is in 2nd place. There is also a
-- margin comparing December to 3rd place February and subsequent months


-- answering question based on launch year
SELECT launch_year, AVG(Sales_in_thousands) AS Total_Sales
FROM car
GROUP BY  launch_year
ORDER BY Total_Sales DESC;
-- 2012 had the highest total car sales on average, followed closely by the previous year, 2011, and then there is big marging
-- between 2011 and 2008 (3rd place) average car sales

-- answering question based on launch quarter
SELECT launch_quarter, AVG(Sales_in_thousands) AS Total_Sales
FROM car
GROUP BY  launch_quarter
ORDER BY Total_Sales DESC;
-- The 2nd half of the year (3rd and 4th) quarters have the highest average car sales on average.
-- The 2nd quarter had the least car sales on average which shocked me, because I thought there were more car sales during that
-- time of the year



-- 2. Price Segmentation: How do vehicle specifications (e.g., engine size, horsepower) vary across different price segments?
SELECT Price_Category, AVG(Engine_size) AS Average_Engine_Size, AVG(Horsepower) AS Average_Horsepower
FROM car
GROUP BY Price_Category;
-- Vehicles in the cheap category have the smallest average engine size and the smallest average horsepower.
-- Expensive cars have the biggest average horsepower and Slightly Costly cars have the highest average engine size



-- 3. Manufacturer Comparison: Compare average sales, prices, and fuel efficiencies across different manufacturers.
SELECT Manufacturer, AVG(Sales_in_thousands) AS Average_Sales
FROM car
GROUP BY Manufacturer
ORDER BY Average_Sales DESC;
-- Ford has the highest average sales at 184,696 followed by Honda and Jeep. Porsche has the smallest average sales at 4,043
SELECT Manufacturer, AVG(Price_in_thousands) AS Average_Price
FROM car
GROUP BY Manufacturer
ORDER BY Average_Price DESC;
-- Porsche has the highest average price at $62,473 followed by Mercedes-Benz and Lincoln. Hyundai has the lowest average prices
SELECT Manufacturer, AVG(Fuel_efficiency) AS Average_Fuel_Efficiency
FROM car
GROUP BY Manufacturer
ORDER BY Average_Fuel_Efficiency DESC;
-- Saturn has the best fuel efficiency at 32.33 followed by Chevrolet and Hyundai. Jeep has the worst fuel efficiency



-- 4. Market Share: What is the market share of each manufacturer based on sales volume?

SELECT SUM(Sales_in_thousands)
FROM car;
-- Sum of all sales is 6930.255

SELECT Manufacturer, (SUM(Sales_in_thousands)/6930.255)*100 AS Market_Share
FROM car
GROUP BY Manufacturer
ORDER BY Market_Share DESC;
-- Ford has the biggest market share at 26.65%, followed by Dodge at 10.4%, and Toyota at 9.74%
-- Porsche has the smallest market share at 0.18%


