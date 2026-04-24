-- =====================================================
-- Bike Sharing Analysis
-- Author: Valentina Menendez Conde
-- Description: SQL queries for data cleaning, transformation,
-- and analysis of Cyclistic bike-share data
-- =====================================================


-- =====================================================
-- 1. MONTHLY USAGE & USER TYPE DISTRIBUTION
-- Objective: Analyze total trips and percentage by user type
-- =====================================================

WITH all_trips AS (
  SELECT '2025-12' AS month, member_casual FROM `proyecto-1-486415.Cyclism.202512`
  UNION ALL
  SELECT '2025-11', member_casual FROM `proyecto-1-486415.Cyclism.202511`
  UNION ALL
  SELECT '2026-01', member_casual FROM `proyecto-1-486415.Cyclism.202601`
  UNION ALL
  SELECT '2026-02', member_casual FROM `proyecto-1-486415.Cyclism.202602`
  UNION ALL
  SELECT '2026-03', member_casual FROM `proyecto-1-486415.Cyclism.202603`
)

SELECT 
  month,
  member_casual,
  COUNT(*) AS total_trips,
  ROUND(
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY month),
    2
  ) AS percentage
FROM all_trips
GROUP BY month, member_casual
ORDER BY month;


-- =====================================================
-- 2. RIDE DURATION ANALYSIS
-- Objective: Compare min, max, and average trip duration
-- =====================================================

WITH all_trips AS (
  SELECT member_casual, TIMESTAMP_DIFF(ended_at, started_at, SECOND) AS trip_duration
  FROM `proyecto-1-486415.Cyclism.202511`
  UNION ALL
  SELECT member_casual, TIMESTAMP_DIFF(ended_at, started_at, SECOND)
  FROM `proyecto-1-486415.Cyclism.202512`
  UNION ALL
  SELECT member_casual, TIMESTAMP_DIFF(ended_at, started_at, SECOND)
  FROM `proyecto-1-486415.Cyclism.202601`
  UNION ALL
  SELECT member_casual, TIMESTAMP_DIFF(ended_at, started_at, SECOND)
  FROM `proyecto-1-486415.Cyclism.202602`
  UNION ALL
  SELECT member_casual, TIMESTAMP_DIFF(ended_at, started_at, SECOND)
  FROM `proyecto-1-486415.Cyclism.202603`
)

SELECT 
  member_casual,
  ROUND(MIN(trip_duration) / 60, 2) AS min_duration_min,
  ROUND(MAX(trip_duration) / 60, 2) AS max_duration_min,
  ROUND(AVG(trip_duration) / 60, 2) AS avg_duration_min
FROM all_trips
WHERE trip_duration > 0
GROUP BY member_casual
ORDER BY member_casual;


-- =====================================================
-- 3. WEEKDAY VS WEEKEND USAGE
-- Objective: Identify behavioral patterns by day of week
-- =====================================================

WITH all_trips AS (
  SELECT member_casual, started_at FROM `proyecto-1-486415.Cyclism.202511`
  UNION ALL
  SELECT member_casual, started_at FROM `proyecto-1-486415.Cyclism.202512`
  UNION ALL
  SELECT member_casual, started_at FROM `proyecto-1-486415.Cyclism.202601`
  UNION ALL
  SELECT member_casual, started_at FROM `proyecto-1-486415.Cyclism.202602`
  UNION ALL
  SELECT member_casual, started_at FROM `proyecto-1-486415.Cyclism.202603`
)

SELECT 
  EXTRACT(DAYOFWEEK FROM started_at) AS day_num,
  FORMAT_DATE('%A', DATE(started_at)) AS day_of_week,
  member_casual,
  COUNT(*) AS total_trips
FROM all_trips
GROUP BY day_num, day_of_week, member_casual
ORDER BY day_num;


-- =====================================================
-- 4. TOP START STATIONS (ALL USERS)
-- Objective: Identify most used stations overall
-- =====================================================

WITH all_trips AS (
  SELECT start_station_id, start_station_name FROM `proyecto-1-486415.Cyclism.202511`
  UNION ALL
  SELECT start_station_id, start_station_name FROM `proyecto-1-486415.Cyclism.202512`
  UNION ALL
  SELECT start_station_id, start_station_name FROM `proyecto-1-486415.Cyclism.202601`
  UNION ALL
  SELECT start_station_id, start_station_name FROM `proyecto-1-486415.Cyclism.202602`
  UNION ALL
  SELECT start_station_id, start_station_name FROM `proyecto-1-486415.Cyclism.202603`
)

SELECT 
  start_station_id,
  start_station_name,
  COUNT(*) AS trips
FROM all_trips
WHERE start_station_id IS NOT NULL
GROUP BY start_station_id, start_station_name
ORDER BY trips DESC
LIMIT 10;


-- =====================================================
-- 5. TOP START STATIONS (CASUAL USERS)
-- Objective: Identify preferred stations for casual riders
-- =====================================================

WITH all_trips AS (
  SELECT member_casual, start_station_name FROM `proyecto-1-486415.Cyclism.202511`
  UNION ALL
  SELECT member_casual, start_station_name FROM `proyecto-1-486415.Cyclism.202512`
  UNION ALL
  SELECT member_casual, start_station_name FROM `proyecto-1-486415.Cyclism.202601`
  UNION ALL
  SELECT member_casual, start_station_name FROM `proyecto-1-486415.Cyclism.202602`
  UNION ALL
  SELECT member_casual, start_station_name FROM `proyecto-1-486415.Cyclism.202603`
)

SELECT 
  start_station_name,
  COUNT(*) AS trips
FROM all_trips
WHERE member_casual = 'casual'
  AND start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY trips DESC
LIMIT 10;
