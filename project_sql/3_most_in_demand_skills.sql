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
    job_title_short = 'Data Analyst' AND
    job_work_from_home = true
GROUP BY
    skills
ORDER BY
    demand DESC
LIMIT 5;
