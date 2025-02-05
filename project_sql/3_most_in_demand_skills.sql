/*
What are the most in-demand skills for data analyst roles in London?
- Use tables to find the skill names and the demand
- Why? This provides insight into which skills are most valuable to learn and universal across multiple roles.
*/

SELECT 
    skills,
    COUNT(*) as demand
FROM job_postings_fact jp
INNER JOIN
    skills_job_dim sj
ON
    jp.job_id = sj.job_id
INNER JOIN
    skills_dim sd
ON
    sj.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND (job_title ILIKE '%analytic%'     -- avoid non data analysts roles
        OR job_title ILIKE '%analyst%')   -- e.g. Data Architects, Research Engineers
    AND job_location LIKE '%UK'
GROUP BY
    skills
ORDER BY
    demand DESC;
