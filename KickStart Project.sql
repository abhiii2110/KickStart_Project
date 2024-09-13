SELECT * FROM kickstart.`kickstart_project`;

use kickstart;


describe kickstart_project;

-- Basic data exploration
SELECT *
FROM Kickstart_project
LIMIT 5;

-- Count total number of projects
SELECT COUNT(*) AS total_projects
FROM Kickstart_project;

-- Check for NULL values in important columns
SELECT 
    COUNT(*) - COUNT(ID) AS null_ids,
    COUNT(*) - COUNT(name) AS null_names,
    COUNT(*) - COUNT(category) AS null_categories,
    COUNT(*) - COUNT(main_category) AS null_main_categories,
    COUNT(*) - COUNT(goal) AS null_goals,
    COUNT(*) - COUNT(pledged) AS null_pledged,
    COUNT(*) - COUNT(state) AS null_states,
    COUNT(*) - COUNT(launched) AS null_launched_dates
FROM Kickstart_project;

-- Distribution of projects by main_category
SELECT 
    main_category,
    COUNT(*) AS project_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Kickstart_project), 2) AS percentage
FROM Kickstart_project
GROUP BY main_category
ORDER BY project_count DESC;

-- Success rate by main_category
SELECT 
    main_category,
    COUNT(*) AS total_projects,
    SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
    ROUND(SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate
FROM Kickstart_project
GROUP BY main_category
ORDER BY success_rate DESC;

-- Average funding percentage by main_category
SELECT 
    main_category,
    ROUND(AVG(pledged / goal * 100), 2) AS avg_funding_percentage
FROM Kickstart_project
WHERE goal > 0
GROUP BY main_category
ORDER BY avg_funding_percentage DESC;

-- Projects and success rate by launch month
SELECT 
    EXTRACT(MONTH FROM launched) AS launch_month,
    COUNT(*) AS total_projects,
    SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
    ROUND(SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate
FROM Kickstart_project
GROUP BY EXTRACT(MONTH FROM launched)
ORDER BY launch_month;

-- Top 10 most funded projects
SELECT 
    name,
    main_category,
    goal,
    pledged,
    ROUND(pledged / goal * 100, 2) AS funding_percentage
FROM Kickstart_project
ORDER BY pledged DESC
LIMIT 10;

-- Success rate by goal range
SELECT 
    CASE 
        WHEN goal <= 1000 THEN '0-1K'
        WHEN goal <= 10000 THEN '1K-10K'
        WHEN goal <= 100000 THEN '10K-100K'
        ELSE '100K+'
    END AS goal_range,
    COUNT(*) AS total_projects,
    SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
    ROUND(SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate
FROM Kickstart_project
GROUP BY 
    CASE 
        WHEN goal <= 1000 THEN '0-1K'
        WHEN goal <= 10000 THEN '1K-10K'
        WHEN goal <= 100000 THEN '10K-100K'
        ELSE '100K+'
    END
ORDER BY 
    CASE 
        WHEN goal_range = '0-1K' THEN 1
        WHEN goal_range = '1K-10K' THEN 2
        WHEN goal_range = '10K-100K' THEN 3
        ELSE 4
    END;

-- Average number of backers for successful vs failed projects
SELECT 
    state,
    ROUND(AVG(backers), 2) AS avg_backers
FROM Kickstart_project
WHERE state IN ('successful', 'failed')
GROUP BY state;

-- Distribution of projects by country
SELECT 
    country,
    COUNT(*) AS project_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Kickstart_project), 2) AS percentage
FROM Kickstart_project
GROUP BY country
ORDER BY project_count DESC
LIMIT 10;