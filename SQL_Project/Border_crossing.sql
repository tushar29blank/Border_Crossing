-- Week 1: Basic Queries

-- List all distinct Port Names and their corresponding States.
SELECT DISTINCT Port_Name, State
FROM border_crossings;

-- Count the total number of unique Borders and the total number of entries associated with each Border.
SELECT DISTINCT Border, COUNT(*) AS Total_Entries
FROM border_crossings
GROUP BY Border;

-- Find all ports that have recorded more than 5000 crossings for the Trucks measure type.
SELECT Port_Name
FROM border_crossings
WHERE Measure = 'Trucks'
GROUP BY Port_Name
HAVING SUM(Value) > 5000;

-- Identify the top 3 states with the highest total number of pedestrian crossings.
SELECT State, SUM(Value) AS Total_Pedestrian_Crossings
FROM border_crossings
WHERE Measure = 'Pedestrians'
GROUP BY State
ORDER BY Total_Pedestrian_Crossings DESC
LIMIT 3;

-- For the year 2023, extract the total number of crossings per month, categorized by measure type.
SELECT MONTH(Date) AS Month, Measure, SUM(Value) AS Total_Crossings
FROM border_crossings
WHERE YEAR(Date) = 2023
GROUP BY Month, Measure;

-- Find which measure type is the most frequently recorded for each state.
SELECT State, Measure, COUNT(*) AS Frequency
FROM border_crossings
GROUP BY State, Measure
HAVING Frequency = (
    SELECT MAX(Frequency)
    FROM (
        SELECT State, Measure, COUNT(*) AS Frequency
        FROM border_crossings
        GROUP BY State, Measure
    ) AS Subquery
    WHERE Subquery.State = border_crossings.State
);

-- Generate a summary report showing the total number of crossings for each measure type grouped by border.
SELECT Border, Measure, SUM(Value) AS Total_Crossings
FROM border_crossings
GROUP BY Border, Measure;

-- Week 2: Intermediate Queries with Aggregations

-- Calculate the average number of crossings per month for each measure type in Texas.
SELECT Measure, AVG(Value) AS Average_Crossings
FROM border_crossings
WHERE State = 'Texas'
GROUP BY Measure;

-- Find the port on the US-Canada border with the highest number of crossings, including the measure type and total crossings.
SELECT Port_Name, Measure, SUM(Value) AS Total_Crossings
FROM border_crossings
WHERE Border = 'US-Canada'
GROUP BY Port_Name, Measure
ORDER BY Total_Crossings DESC
LIMIT 1;

-- Calculate the total number of crossings for the "Buses" measure type in each state, ordered by total crossings in descending order.
SELECT State, SUM(Value) AS Total_Bus_Crossings
FROM border_crossings
WHERE Measure = 'Buses'
GROUP BY State
ORDER BY Total_Bus_Crossings DESC;

-- For the US-Mexico border, calculate the average and total number of crossings for each port in the year 2022.
SELECT Port_Name, AVG(Value) AS Average_Crossings, SUM(Value) AS Total_Crossings
FROM border_crossings
WHERE Border = 'US-Mexico' AND YEAR(Date) = 2022
GROUP BY Port_Name;

-- List all ports that reported pedestrians as a crossing measure in 2023 and show their total number of pedestrian crossings.
SELECT Port_Name, SUM(Value) AS Total_Pedestrian_Crossings
FROM border_crossings
WHERE Measure = 'Pedestrians' AND YEAR(Date) = 2023
GROUP BY Port_Name;

-- Extract the total number of crossings in each border for every year available in the dataset.
SELECT Border, YEAR(Date) AS Year, SUM(Value) AS Total_Crossings
FROM border_crossings
GROUP BY Border, Year;

-- Identify the month in 2023 with the highest number of truck crossings. List the month and total truck crossings.
SELECT MONTH(Date) AS Month, SUM(Value) AS Total_Truck_Crossings
FROM border_crossings
WHERE Measure = 'Trucks' AND YEAR(Date) = 2023
GROUP BY MONTH(Date)
ORDER BY Total_Truck_Crossings DESC
LIMIT 1;

-- List the top 5 ports with the highest crossing activity (all measure types) in 2021, showing the measure type and total crossings for each port.
SELECT Port_Name, Measure, SUM(Value) AS Total_Crossings
FROM border_crossings
WHERE YEAR(Date) = 2021
GROUP BY Port_Name, Measure
ORDER BY Total_Crossings DESC
LIMIT 5;

-- Week 3: Advanced Queries and Research-Like Tasks

-- Calculate the total number of crossings for each year from 2019 to 2023, grouped by border and measure type.
SELECT Border, Measure, YEAR(Date) AS Year, SUM(Value) AS Total_Crossings
FROM border_crossings
WHERE YEAR(Date) BETWEEN 2019 AND 2023
GROUP BY Border, Measure, Year;

-- For Texas, find the most frequently recorded measure types for 2023. Rank the measure types by the number of entries without using `RANK()`.
SELECT Measure, COUNT(*) AS Frequency
FROM border_crossings
WHERE State = 'Texas' AND YEAR(Date) = 2023
GROUP BY Measure
ORDER BY Frequency DESC;

-- Compare the total number of container crossings over the last 3 years for each border.
SELECT Border, YEAR(Date) AS Year, SUM(CASE WHEN Measure = 'Containers' THEN Value ELSE 0 END) AS Total_Container_Crossings
FROM border_crossings
WHERE YEAR(Date) BETWEEN 2021 AND 2023
GROUP BY Border, Year;

-- Identify the busiest month of each year (2020-2023) in terms of pedestrian crossings. Show the year, month, and total pedestrian crossings.
SELECT YEAR(Date) AS Year, MONTH(Date) AS Month, SUM(CASE WHEN Measure = 'Pedestrians' THEN Value ELSE 0 END) AS Total_Pedestrian_Crossings
FROM border_crossings
WHERE YEAR(Date) BETWEEN 2020 AND 2023
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Total_Pedestrian_Crossings DESC;

-- Compare the total number of truck crossings in 2021 and 2022 at the top 5 busiest ports for trucks. Display both years' totals side by side.
SELECT Port_Name, 
       SUM(CASE WHEN YEAR(Date) = 2021 AND Measure = 'Trucks' THEN Value ELSE 0 END) AS Total_Truck_Crossings_2021,
       SUM(CASE WHEN YEAR(Date) = 2022 AND Measure = 'Trucks' THEN Value ELSE 0 END) AS Total_Truck_Crossings_2022
FROM border_crossings
WHERE YEAR(Date) IN (2021, 2022) AND Measure = 'Trucks'
GROUP BY Port_Name
ORDER BY Total_Truck_Crossings_2021 + Total_Truck_Crossings_2022 DESC
LIMIT 5;

-- Find the port with the lowest total crossings on the U.S.-Canada border for any measure type in 2023.
SELECT Port_Name, SUM(Value) AS Total_Crossings
FROM border_crossings
WHERE Border = 'US-Canada' AND YEAR(Date) = 2023
GROUP BY Port_Name
ORDER BY Total_Crossings ASC
LIMIT 1;

-- List the monthly total number of crossings for buses across all states in 2022, sorted in ascending order.
SELECT MONTH(Date) AS Month, SUM(CASE WHEN Measure = 'Buses' THEN Value ELSE 0 END) AS Total_Bus_Crossings
FROM border_crossings
WHERE YEAR(Date) = 2022
GROUP BY MONTH(Date)
ORDER BY Total_Bus_Crossings ASC;

-- Display the sum and average number of crossings for each state, grouped by measure type and year. Only show entries where the average crossings exceed 500.
SELECT State, Measure, YEAR(Date) AS Year, SUM(Value) AS Total_Crossings, AVG(Value) AS Average_Crossings
FROM border_crossings
GROUP BY State, Measure, Year
HAVING AVG(Value) > 500;