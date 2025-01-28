/*
Question: What are the highest-paying data analyst jobs?
- Identify the top 10 highest paying Data Analyst roles that are remote
- Focus on job postings with specified salaries (ignore nulls)
- Why? Focus on top-paying opportunities for Data Analysts, offering insights into employment
*/

SELECT
    job_id,
    c.name AS company_name,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM    
    job_postings_fact jp
LEFT JOIN
    company_dim c
ON
    jp.company_id = c.company_id
WHERE  
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;