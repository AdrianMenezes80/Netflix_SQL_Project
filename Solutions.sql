-- Project Netflix

CREATE 	TABLE netflix
(
	show_id	 VARCHAR (5),
	type	VARCHAR (10),
	title	VARCHAR (150),
	director	VARCHAR (208),
	cast	VARCHAR (1000),
	country	VARCHAR (150),
	date_added	VARCHAR (50)
	release_year	INT,
	rating	duration	VARCHAR (15)
	listed_in	VARCHAR (5)
	description
)


-- 1. Count the Number of Movies vs TV Shows

SELECT type,
	count(*) as total_content
FROM netflix
Group by type;



-- 2. Find the Most Common Rating for Movies and TV Shows

SELECT
	type,
	rating
	
FROM

	(SELECT 
		type,
		rating,
		count(*),
		RANK() OVER (PARTITION BY type ORDER BY count(*) DESC)
		FROM netflix
		GROUP BY 1,2
	)
WHERE rank = 1


-- 3. List All Movies Released in a Specific Year (e.g., 2020)

SELECT *
FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020;


-- 4. Find the Top 5 Countries with the Most Content on Netflix

SELECT
    country,
    COUNT(show_id) AS total_content
FROM (
    SELECT
        show_id,
        TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country
    FROM netflix
) 
GROUP BY
    country
ORDER BY
    total_content DESC
LIMIT 5;



-- 5. Identify the Longest Movie

SELECT *
FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX (duration) FROM netflix)
	

-- 6. Find Content Added in the Last 5 Years


SELECT 
	*
	
FROM netflix
WHERE
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 Years'	


-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT *
FROM (


	SELECT *,
	UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
	FROM netflix
) 

WHERE director_name = 'Rajiv Chilaka';



-- 8. List All TV Shows with More Than 5 Seasons

SELECT 
	*
FROM netflix
WHERE 
	type = 'TV Show'
	AND 
	SPLIT_PART(duration,' ',1):: numeric > 5


-- 9. Count the Number of Content Items in Each Genre

SELECT 
	TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1


-- 10.Find each year and the average numbers of content release in India on netflix.

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
