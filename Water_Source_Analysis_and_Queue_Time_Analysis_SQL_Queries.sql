-- Summarizing the total number of people served by each type of water source and calculating the percentage of total people served.
SELECT 
    type_of_water_source,
    SUM(number_of_people_served) AS total_people_served, 
    ROUND((SUM(number_of_people_served) / (SELECT SUM(number_of_people_served) FROM md_water_services.water_source)) * 100, 0) AS percentage_served
FROM 
    md_water_services.water_source
GROUP BY 
    type_of_water_source 
ORDER BY 
    total_people_served DESC; 

-- Ranking the types of water sources based on the total number of people served.
SELECT 
    type_of_water_source,
    SUM(number_of_people_served) AS total_people_served, 
    RANK() OVER (ORDER BY SUM(number_of_people_served) DESC) AS rank
FROM 
    md_water_services.water_source
GROUP BY 
    type_of_water_source; 

-- Assigning a priority to each source within the same type of water source using ROW_NUMBER().
SELECT 
    source_id, 
    number_of_people_served, 
    type_of_water_source, 
    ROW_NUMBER() OVER (PARTITION BY type_of_water_source ORDER BY number_of_people_served DESC) AS priority
FROM 
    md_water_services.water_source;

-- Extracting the hour of the day and calculating the average queue time for Sundays.
SELECT
    TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day, 
    DAYNAME(time_of_record), 
    CASE
        WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue 
    END AS Sunday
FROM
    md_water_services.visits
WHERE
    time_in_queue != 0; 

-- Analyzing average queue times by hour of day for specific days of the week.
SELECT
    TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,

    -- Sunday
    ROUND(AVG(
        CASE
            WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue 
        END
    ), 0) AS Sunday,

    -- Monday
    ROUND(AVG(
        CASE
            WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue 
        END
    ), 0) AS Monday,

    -- Wednesday
    ROUND(
        AVG(
            CASE
                WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue 
            END
        ), 0) AS Wednesday,

    -- Thursday
    ROUND(
        AVG(
            CASE
                WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue 
            END
        ), 0) AS Thursday

FROM
    md_water_services.visits
WHERE
    time_in_queue != 0 
GROUP BY
    hour_of_day
ORDER BY
    hour_of_day; 
