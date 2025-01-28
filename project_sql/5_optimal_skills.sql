
WITH skills_demand AS (
    SELECT 
        sd.skills,
        sd.skill_id,
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
        AND salary_year_avg IS NOT NULL
        AND job_location LIKE '%UK%'
    GROUP BY
        sd.skill_id
), average_salary AS (
    SELECT 
        sj.skill_id,
        ROUND(AVG(salary_year_avg)) AS avg_salary
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
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = true
    GROUP BY
        sj.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand,
    avg_salary
FROM skills_demand
INNER JOIN
    average_salary
ON
    skills_demand.skill_id = average_salary.skill_id
ORDER BY
    demand DESC;


SELECT
    sd.skill_id,
    sd.skills,
    COUNT(*) AS demand,
    ROUND(AVG(salary_year_avg)) AS avg_salary
FROM
    job_postings_fact jp
INNER JOIN skills_job_dim sj ON jp.job_id = sj.job_id
INNER JOIN skills_dim sd ON sj.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY sd.skill_id
HAVING
    COUNT(*) > 10
ORDER BY
    avg_salary DESC,
    demand DESC
LIMIT 25;