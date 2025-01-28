SELECT 
    skills,
    AVG(salary_year_avg) AS value
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
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    value DESC
