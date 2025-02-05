/*
What are the highest average salaries for each skill in data analyst roles located in London?
- 
*/

-- removing outliers

WITH SalaryStats AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary_year_avg) AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary_year_avg) AS Q3,
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
        AND job_location LIKE '%UK'
        AND salary_year_avg IS NOT NULL
        AND (job_title ILIKE '%analyst%' OR job_title ILIKE '%analytic%')

)
SELECT 
    sd.skills,
    AVG(jp.salary_year_avg) AS avg_salary
FROM job_postings_fact jp
INNER JOIN skills_job_dim sj ON jp.job_id = sj.job_id
INNER JOIN skills_dim sd ON sj.skill_id = sd.skill_id
CROSS JOIN SalaryStats s
WHERE job_title_short = 'Data Analyst'
    AND job_location LIKE '%UK'
    AND salary_year_avg BETWEEN (s.Q1 - 1.5 * (s.Q3 - s.Q1)) AND (s.Q3 + 1.5 * (s.Q3 - s.Q1)) -- IQR filter
    AND (job_title ILIKE '%analyst%' OR job_title ILIKE '%analytic%')
GROUP BY sd.skills
ORDER BY avg_salary DESC;