-- CREATE TABLE job_applied (
--     job_id INT,
--     application_sent_date DATE,
--     custom_resume BOOLEAN,
--     resume_file_name VARCHAR(255),
--     cover_letter_sent BOOLEAN,
--     cover_letter_file_name VARCHAR(255),
--     status VARCHAR(50)
-- );

-- SELECT *
-- FROM job_applied;

-- INSERT INTO job_applied(
--     job_id,
--     application_sent_date,
--     custom_resume,
--     resume_file_name,
--     cover_letter_sent,
--     cover_letter_file_name,
--     status
-- )
-- VALUES (
--     1,
--     '2024-02-01',
--     true,
--     'resume_01.pdf',
--     true,
--     'cover_letter_01.pdf',
--     'submitted'
-- );

-- ALTER TABLE job_applied
-- ADD contact VARCHAR(50)

-- UPDATE job_applied
-- SET contact = 'Erlich Bachman'
-- WHERE job_id = 1

-- ALTER TABLE job_applied
-- RENAME COLUMN contact TO contact_name

-- ALTER TABLE job_applied
-- ALTER COLUMN contact_name TYPE TEXT

-- ALTER TABLE job_applied
-- DROP COLUMN contact_name


-- DROP TABLE job_applied

-- SELECT *
-- FROM job_postings_fact
-- LIMIT 100;

SELECT job_posted_date::DATE
FROM job_postings_fact
LIMIT 10;

SELECT 
    EXTRACT(MONTH FROM job_posted_date) AS month,
    COUNT(*) AS number_of_jobs
FROM
    job_postings_fact
GROUP BY
    month
ORDER BY
    number_of_jobs;

SELECT 
    job_id,
    salary_year_avg,
    salary_hour_avg,

    job_schedule_type
FROM
    job_postings_fact
LIMIT 10;

SELECT
    job_schedule_type,
    AVG(salary_year_avg) AS avg_year_salary,
    AVG(salary_hour_avg) AS avg_hour_salary,
    COUNT(job_id)
FROM
    job_postings_fact
WHERE
    job_posted_date::DATE > '2023-06-01'
GROUP BY
    job_schedule_type;


SELECT
    COUNT(*)
FROM
    job_postings_fact
WHERE
    job_posted_date::DATE > '2023-06-01'


CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN salary_year_avg > 250000 THEN 'High'
        WHEN salary_year_avg BEtWEEN 150000 AND 250000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_category
FROM job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
GROUP BY salary_category
ORDER BY salary_category DESC;

WITH company_job_count AS(
    SELECT
        company_id,
        COUNT(job_id) as job_count
    FROM
        job_postings_fact
    GROUP BY
        company_id
    ORDER BY
        company_id
)

SELECT cd.name, cj.job_count
FROM company_job_count cj 
LEFT JOIN
    company_dim cd
ON cj.company_id = cd.company_id
ORDER BY
    cj.job_count DESC


SELECT 
    sd.skills,
    total
FROM (
SELECT 
    skill_id,
    COUNT(*) as total
FROM
    skills_job_dim
GROUP BY
    skill_id
LIMIT 5) AS sj
LEFT JOIN skills_dim sd
ON
    sj.skill_id = sd.skill_id


SELECT
    company_id,
    CASE
        WHEN total_postings < 10 THEN 'Small'
        WHEN total_postings BETWEEN 10 AND 50 THEN 'Medium'
        WHEN total_postings > 50 THEN 'Large'
    END AS size_category
FROM
(SELECT
    company_id,
    COUNT(*) AS total_postings
FROM
    job_postings_fact
GROUP BY
    company_id)

SELECT
    job_location
FROM
    job_postings_fact
WHERE
    job_location = 'Anywhere'


WITH top_5_remote AS (
SELECT
    skill_id,
    COUNT(*) AS total
FROM
    skills_job_dim sj
INNER JOIN
    job_postings_fact jp
ON
    sj.job_id = jp.job_id
WHERE
    job_work_from_home = true AND
    job_title_short = 'Data Analyst'
GROUP BY
    skill_id
ORDER BY
    total DESC
)

SELECT
    sd.skill_id,
    skills AS name,
    total
FROM top_5_remote r
LEFT JOIN
    skills_dim sd
ON 
    r.skill_id = sd.skill_id
ORDER BY
    total DESC
LIMIT 5

-- CTE for first quarter jobs
WITH q1_jobs AS (
SELECT
    *
FROM
    january_jobs

UNION

SELECT
    *
FROM
    february_jobs

UNION

SELECT
    *
FROM
    march_jobs
)

SELECT
    job_id,
    salary_year_avg
FROM q1_jobs
WHERE
    salary_year_avg > 70000