/*
Question What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
    helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_10 AS (
SELECT
    job_id,
    c.name AS company_name,
    job_title,
    job_location,
    salary_year_avg
FROM    
    job_postings_fact jp
LEFT JOIN
    company_dim c
ON
    jp.company_id = c.company_id
WHERE  
    job_title_short = 'Data Analyst' AND
    job_location LIKE '%London%' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
)

SELECT
    t.*,
    s.skills
FROM top_10 t
INNER JOIN
    skills_job_dim sj 
ON
    t.job_id = sj.job_id
INNER JOIN
    skills_dim s
ON
    sj.skill_id = s.skill_id
ORDER BY
    salary_year_avg DESC;