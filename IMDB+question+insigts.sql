USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column hAS null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

/*  MY NOTES:

We can use the following code. It returs columns with text. Copy the text in these columns and paste it
as syntax to find total number of rows in each table of the schema (Note: Remove 'uniON ' from the last line):

SELECT CON cat('SELECT "',table_name,
'" AS tablename,count(*) FROM ',table_name,' UNION  ') AS Query FROM 
 INFORMATION _SCHEMA.TABLES 
WHERE table_schema = 'imdb';

*/

SELECT "director_mapping" AS tablename,count(*) FROM director_mapping UNION  
SELECT "genre" AS tablename,count(*) FROM genre UNION  
SELECT "movie" AS tablename,count(*) FROM movie UNION  
SELECT "names" AS tablename,count(*) FROM names UNION  
SELECT "ratings" AS tablename,count(*) FROM ratings UNION  
SELECT "role_mapping" AS tablename,count(*) FROM role_mapping;
   
-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS id_null,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_id,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS null_year,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS null_date_published,
       Sum(CASE
             WHEN duratiON  IS NULL THEN 1
             ELSE 0
           END) AS null_duratiON ,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS null_country,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS null_worlwide_gross_income,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS null_languages,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS null_production_company
FROM   movie;

/* EXPECTED ANSWER:
Now AS you can see four columns of the movie table hAs null values. Let's look at the at the movies released each year. */

-- Q3. Find the total number of movies released each year? How does the trend look mONth wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the secON d part of the questiON :
+---------------+-------------------+
|	mONth_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year, count(id) number_of_movies
FROM movie
GROUP BY  year;

SELECT month(date_published) AS month_num,
count(id) AS number_of_movies
FROM movie
GROUP BY  month_num
ORDER BY  month_num;

-- OUT OF MY CURIOSITY

SELECT year, month(date_published) AS month_num,
count(id) AS number_of_movies
FROM movie
GROUP BY  year, month_num
ORDER BY  year, month_num;

SELECT g.genre, month(m.date_published) AS month_num, count(m.id)
FROM movie m
inner join genre g
on m.id = g.movie_id
where g.genre = 'DRAMA'
group by g.genre, month_num
order by count(m.id) desc;


/* EXPECTED ANSWER:
The highest number of movies is produced in the month of March. */

/*
MY NOTES:
1. The number of movies produced in 2019 has drastically decreased. We can observe that according to the data provided,
   the movies produced in November and December 2019 are 97 and 16 respectively and that is a small number because
   every other month in these 3 years had more than 130 movies produced.
   This could be an error. However, for this project we will not consider it to be an error.
2. The most number of movies in 3 years, i.e. 800+ movies, have been produced in the monthof January, March, September, October.
   The trend remains the same for each year too. 
3. The highest number of movies were released in March and September.
*/



/* So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT count(id) AS number_of_movies_in_us_or_india
FROM movie
where year = '2019' and country in ('USA' , 'India');

/* MY NOTES: 
USA and India produced 887 in the year 2019. */


/*
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT  genre
FROM genre;

/* So, RSVP Movies plans to make a movie of ON e of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT count(m.id) AS number_of_movies, g.genre
FROM movie m
INNER JOIN  genre g
ON  m.id = g.movie_id
GROUP BY  g.genre
ORDER BY  number_of_movies DESC ;

-- OUT OF MY CURIOSITY

SELECT m.year, count(m.id) AS number_of_movies, g.genre
FROM movie m
INNER JOIN  genre g
ON  m.id = g.movie_id
GROUP BY  m.year, g.genre
ORDER BY  m.year, number_of_movies DESC ;

/* MY NOTES:
 Highest number of movies produced in all 3 years were of genre 'DRAMA' (4285 movies).
 Other top 2 genres are COMEDY (2412 movies) and THRILLER (1484 movies) .
 The trend remains the same for each year too.
 */

/* EXPECTED ANSWER:
 So, based on the insight that you just drew, RSVP Movies should focus ON  the ‘Drama’ genre. */
 

/*But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_details AS (
SELECT movie_id, count(genre) AS number_of_genre
FROM genre
GROUP BY  movie_id
)
SELECT number_of_genre, count(number_of_genre) AS 'number_of_films'
FROM genre_details
GROUP BY  number_of_genre
ORDER BY  number_of_films DESC ;

-- OUT OF MY CURIOSITY

WITH genre_details AS (
SELECT g.movie_id, r.avg_rating, count(g.genre) AS number_of_genre
FROM genre g
inner join ratings r
on g.movie_id = r.movie_id
GROUP BY  movie_id
)
SELECT number_of_genre, count(number_of_genre) as number_of_movies, avg(avg_rating) as avg_rating_of_genre
from genre_details
group by number_of_genre
order by number_of_movies desc;


/* MY NOTES:
Most films belong to only one genre,i.e. 3289 films. 2751 movies belong to 2 genres and  1957 movies belong to 3 genres.
*/

/* EXPECTED ANSWER:
 There are more than three thousand movies which hAS ONly ON e genre ASsociated with them.
So, this figure appears significant. 
*/

/* Now, let's find out the possible duratiON  of RSVP Movies’ next project.*/

-- Q8.What is the average duratiON  of movies in each genre? 
-- (Note: The same movie can belONg to multiple genres.)
/* Output format:

+---------------+-------------------+
| genre			|	AVG_duratiON 	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT AVG(m.duration) AS avg_duration, g.genre
FROM movie m
INNER JOIN  genre g
ON  m.id = g.movie_id
GROUP BY  g.genre
ORDER BY  AVG_duratiON  DESC;

/* MY NOTES:
Average duration according to genres:
DRAMA - 106.77, COMEDY - 102.62, THRILLER - 101.57, ACTION - 112.88
*/

/* EXPECTED ANSWER:  
Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins. */

/* Lets find where the movies of genre 'thriller' ON  the bASis of number of movies. */

-- Q9.What is the rank of the ‘thriller’ genre of movies amONg all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank functiON )


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT g.genre, count(m.id) AS movie_count, 
dense_rank() over(ORDER BY  count(m.id) DESC ) AS genre_rank
FROM movie m
INNER JOIN  genre g
ON  m.id = g.movie_id
GROUP BY  g.genre;

/* MY NOTES:
Thriller movies is in top 3 amON g all genres in terms of number of movies. */

/*  EXPECTED ANSWER: 
Thriller movies is in top 3 amON g all genres in terms of number of movies*/

/* In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table AS well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_AVG_rating|	max_AVG_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


SELECT Round(Min(AVG_rating), 0) AS min_AVG_rating,
       Round(Max(AVG_rating), 0) AS max_AVG_rating,
       Min(total_votes)          AS min_total_votes,
       Max(total_votes)          AS max_total_votes,
       Min(median_rating)        AS min_median_rating,
       Max(median_rating)        AS max_median_rating
FROM   ratings;
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies bASed ON  average rating.*/

-- Q11. Which are the top 10 movies bASed ON  average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		AVG_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT m.title, r.AVG_rating,
dense_rank () over (ORDER BY  AVG_rating DESC ) AS movie_rank
FROM movie m
INNER JOIN 
ratings r
ON  m.id = r.movie_id;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, pleASe check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be FROM these movies?
Summarising the ratings table bASed ON  the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table bASed ON  the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- ORDER BY  is good to have

SELECT median_rating, count(movie_id) AS movie_count
FROM ratings
GROUP BY  median_rating
ORDER BY  movie_count DESC ;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the productiON  house with which RSVP Movies can partner for its next project.*/

-- Q13. Which productiON  house hAS produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|productiON _company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, count(m.id) AS movie_count,
dense_rank () over (ORDER BY  count(m.id) DESC ) AS prod_company_rank
FROM movie m
INNER JOIN  ratings r
ON  m.id = r.movie_id
where AVG_rating > 8 AND m.production_company IS NOT NULL
GROUP BY  m.production_company;

/* MY NOTES:
RSVP Movies can partner with production house 'Dream Warrior Pictures' or 'National Theatre Live' for their next project because these houses
produced the most number of hit movies, i.e. average rating > 8. */

-- OUT OF MY CURIOSITY:

SELECT m.production_company, m.title, g.genre
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
INNER JOIN  ratings r
ON  m.id = r.movie_id
where AVG_rating > 8 AND m.production_company IN ('Dream Warrior Pictures' , 'National Theatre Live') 
order by m.production_company;

/* MY NOTES:
'Dream Warrior Pictures' produced one movie in the Drama genre.
'National Theatre Live' produced two movies in the Drama genre. */

/* EXPECTED ANSWER
It's ok if RANK() or DENSE_RANK() is used too
Answer can be Dream Warrior Pictures or NatiONal Theatre Live or both */

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       Count(id) AS movie_count
FROM   genre AS g
       INNER JOIN  ratings AS r
               ON  g.movie_id = r.movie_id
       INNER JOIN  movie AS m
               ON  m.id = r.movie_id
WHERE  country = "usa"
       AND total_votes > 1000
       AND Year(date_published) = 2017
       AND month(date_published) = 3
GROUP  BY genre
ORDER  BY movie_count DESC ;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		AVG_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       AVG_rating,
       genre
FROM   movie AS m
       INNER JOIN  ratings AS r
               ON  r.movie_id = m.id
       INNER JOIN  genre AS g
               ON  g.movie_id = r.movie_id
WHERE  title LIKE "the%"
       AND AVG_rating > 8
GROUP  BY genre
ORDER  BY AVG_rating DESC ;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(id) AS "movie_count_for_median_rating_8"
FROM   movie AS m
       INNER JOIN  ratings AS r
               ON  m.id = r.movie_id
WHERE  median_rating = 8
       AND date_published BETWEEN "2018-04-01" AND "2019-04-01";


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country,
       total_votes
FROM   movie AS m
       INNER JOIN  ratings AS r
               ON  m.id = r.movie_id
WHERE  country IN( "germany", "italy" )
GROUP  BY country; 

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/



-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT Sum(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   names; 


/* There are no Null value in the column 'name'.
The director is the most important person  in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top3Genre_with_AVGRatingAbove8 AS 
(SELECT g.genre, count(g.movie_id) AS movie_count1
FROM genre g
INNER JOIN  ratings r
ON  g.movie_id = r.movie_id
where r.AVG_rating > 8
GROUP BY  g.genre
ORDER BY  movie_count1 DESC 
limit 3)
SELECT n.name, count(d.movie_id) AS movie_count
FROM names n
INNER JOIN  director_mapping d
ON  n.id = d.name_id
INNER JOIN  genre g
ON  d.movie_id = g.movie_id
INNER JOIN  ratings r
ON  g.movie_id = r.movie_id
where g.genre in 
( SELECT genre 
FROM top3Genre_with_AVGRatingAbove8)
and r.AVG_rating > 8
GROUP BY  n.name
ORDER BY  movie_count DESC
limit 3 ;



/*MY NOTES:
1. The top three genres that have the most number of movies with an average rating > 8 are 'DRAMA', 'ACTION', 'COMEDY'.
2. the top three directors are 'JAMES MANGOLD', 'JOE RUSSO', 'ANTHONY RUSSO' (in the top three genres whose movies have an average rating > 8)
*/


/* James Mangold can be hired AS the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name AS actor_name, count(rm.movie_id) AS movie_count
FROM names n
INNER JOIN  role_mapping rm
ON  n.id = rm.name_id
INNER JOIN  ratings r
ON  rm.movie_id = r.movie_id
where rm.category = 'ACTOR'
AND r.median_rating >=8
GROUP BY  actor_name
ORDER BY  movie_count DESC
LIMIT 2;

-- OUT OF MY CURIOSITY

SELECT n.name AS actor_name, count(rm.movie_id) AS movie_count
FROM names n
INNER JOIN  role_mapping rm
ON  n.id = rm.name_id
INNER JOIN  ratings r
ON  rm.movie_id = r.movie_id
INNER JOIN genre g
on r.movie_id = g.movie_id
where rm.category = 'ACTOR'
AND r.median_rating >=8
AND g.genre = 'DRAMA'
GROUP BY  actor_name
ORDER BY  movie_count DESC;



/*MY NOTES:
The top two actors whose movies have a median rating >= 8 are 'Mammootty' and 'Mohanlal'.
Mammootty is also among the top actors in drama genre.  */

/* EXPECTED ANSWER:  
Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. */ 


/*RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three productiON  houses in the world.*/

-- Q21. Which are the top three productiON  houses bASed ON  the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|productiON _company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, sum(r.total_votes) AS vote_count,
dense_rank () over (ORDER BY  sum(r.total_votes) DESC ) AS prod_comp_rank
FROM movie m
INNER JOIN  ratings r
ON  m.id = r.movie_id
GROUP BY  m.production_company
limit 3;

/* MY NOTES:
'Marvel Studios', 'Twentieth Century Fox', 'Warner Bros.' are the top three productiON houses bASed ON
the number of votes received by the movies they have produced. */

/* EXPECTED ANSWER:
Yes Marvel Studios rules the movie world.
So, these are the top three productiON  houses bASed ON  the number of votes received by the movies they have produced. */



/* Since RSVP Movies is bASed out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regiONal feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies releASed in India bASed ON  their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at leASt five Indian movies. 
-- (Hint: You should use the weighted average bASed ON  votes. If the ratings clASh, then the total number of votes should act AS the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_AVG_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
n.name AS actor_name,
count(rm.movie_id) AS movie_count,
sum(r.total_votes) AS total_votes,
(Sum(r.AVG_rating*r.total_votes)/Sum(r.total_votes)) AS actor_AVG_rating,
dense_rank () over w AS actor_rank
FROM names n
INNER JOIN  role_mapping rm
ON  n.id=rm.name_id
INNER JOIN  movie m
ON  rm.movie_id = m.id
INNER JOIN  ratings r
ON  m.id = r.movie_id
where rm.category = 'ACTOR' 
and m.country = 'INDIA'
GROUP BY  actor_name
having movie_count >=5
window w AS (ORDER BY  (Sum(r.AVG_rating*r.total_votes)/Sum(r.total_votes)) DESC , (count(rm.movie_id)) DESC );

-- MY NOTES: Top Indian actor is Vijay Sethupathi

-- EXPECTED ANSWER: Top actor is Vijay Sethupathi

-- OUT OF MY CURIOSITY:

SELECT n.name, m.languages
FROM names n
INNER JOIN role_mapping rm
on n.id = rm.name_id
INNER JOIN movie m
ON rm.movie_id = m.id
WHERE rm.category = 'ACTOR'
and n.name = 'Vijay Sethupathi';

SELECT
n.name AS actress_name,
count(rm.movie_id) AS movie_count,
sum(r.total_votes) AS total_votes,
(Sum(r.AVG_rating*r.total_votes)/Sum(r.total_votes)) AS actor_AVG_rating,
dense_rank () over w AS actress_rank
FROM names n
INNER JOIN  role_mapping rm
ON  n.id=rm.name_id
INNER JOIN  movie m
ON  rm.movie_id = m.id
INNER JOIN  ratings r
ON  m.id = r.movie_id
where rm.category = 'ACTRESS' 
and m.country = 'INDIA'
GROUP BY  actress_name
having movie_count >=5
window w AS (ORDER BY  (Sum(r.AVG_rating*r.total_votes)/Sum(r.total_votes)) DESC , (count(rm.movie_id)) DESC );

SELECT n.name, m.languages
FROM names n
INNER JOIN role_mapping rm
on n.id = rm.name_id
INNER JOIN movie m
ON rm.movie_id = m.id
WHERE rm.category = 'ACTRESS'
and n.name = 'Taapsee Pannu';

/* MY NOTES: Vijay Sethupathi is the top actor and has been an actor mostly in Tamil films.  
'Taapsee Pannu' is the top actress and has been an actress mostly in Hindi and Telugu films.*/


-- Q23.Find out the top five actresses in Hindi movies releASed in India bASed ON  their average ratings? 
-- Note: The actresses should have acted in at leASt three Indian movies. 
-- (Hint: You should use the weighted average bASed ON  votes. If the ratings clASh, then the total number of votes should act AS the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_AVG_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
n.name AS actress_name,
sum(r.total_votes) AS total_votes,
count(rm.movie_id) AS movie_count,
(Sum(r.AVG_rating*r.total_votes)/Sum(r.total_votes)) AS actress_AVG_rating,
dense_rank () over w AS actress_rank
FROM names n
INNER JOIN  role_mapping rm
ON  n.id=rm.name_id
INNER JOIN  movie m
ON  rm.movie_id = m.id
INNER JOIN  ratings r
ON  m.id = r.movie_id
where rm.category = 'ACTRESS' 
and m.country = 'INDIA'
and m.languages = 'HINDI'
GROUP BY  actress_name
having movie_count >= 3
window w AS (ORDER BY  (Sum(r.AVG_rating*r.total_votes)/Sum(r.total_votes)) DESC , (count(rm.movie_id)) DESC );

-- MY NOTES: Taapsee Pannu tops with average rating 7.74.

-- EXPECTED ANSWER: Taapsee Pannu tops with average rating 7.74. 

-- Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. SELECT thriller movies AS per AVG rating and clASsify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: ON e-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title AS movie_title, r.AVG_rating,
CASE
         WHEN AVG_rating < 5 THEN 'Flop movies'
         WHEN AVG_rating BETWEEN 5 AND 7 THEN 'ON e-time-watch movies'
         WHEN AVG_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         ELSE 'Superhit movies'
       END clASsificatiON 
FROM movie m
INNER JOIN  ratings r
ON  m.id = r.movie_id
INNER JOIN  genre g
ON  r.movie_id = g.movie_id
where genre = 'THRILLER'
ORDER BY  AVG_rating DESC ;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tASks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duratiON ? 
-- (Note: You need to show the output table in the questiON .) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	AVG_duratiON 	|running_total_duratiON |moving_AVG_duratiON   |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH duration_details AS (
SELECT g.genre, 
AVG(m.duration) AS avg_duration,
sum(m.duration) AS running_total_duration
FROM genre g
INNER JOIN  movie m
ON  g.movie_id = m.id
GROUP BY  g.genre
ORDER BY  g.genre)
SELECT *,
AVG(AVG_duration) OVER (ROWS UNBOUNDED preceding) AS moving_average_duration 
FROM duration_details ;


-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres bASed ON  most number of movies

/* MY NOTES:
'worlwide_gross_income' column in 'movie' table has values in dollars and INR. The values are also of the type varchar.
Thus, we use views to ensure that the values for worlwide_gross_income are of the type integer and INR values are converted to dollars. 
*/

CREATE view rupee_details AS (
SELECT g.genre, m.year, m.title AS movie_name,
(cASt(((SUBSTRING_INDEX(m.worlwide_gross_income, ' ' , -1))/82) AS unsigned)) AS worlwide_gross_income_in_rupees
FROM genre g
INNER JOIN  movie m
ON  g.movie_id = m.id
where m.worlwide_gross_income like 'INR%');

CREATE view dollar_details AS (
SELECT g.genre, m.year, m.title AS movie_name,
(cASt(SUBSTRING_INDEX(m.worlwide_gross_income, ' ' , -1) AS unsigned)) AS worlwide_gross_income_in_dollars
FROM genre g
INNER JOIN  movie m
ON  g.movie_id = m.id
where m.worlwide_gross_income like '\$%');

create view clean_table AS (
(SELECT * FROM dollar_details)
UNION 
(SELECT * FROM rupee_details)
);

WITH required_table_details AS (
SELECT *, 
dense_rank () over (partitiON  by genre, year ORDER BY  worlwide_gross_income_in_dollars DESC ) AS Movie_Rank
FROM clean_table)
SELECT * FROM required_table_details
where Movie_Rank <= 5
and genre in (
SELECT genre FROM 
( SELECT g.genre, count(m.id) AS number_of_movies
FROM movie m
INNER JOIN  genre g
ON  m.id = g.movie_id
GROUP BY  g.genre
ORDER BY  number_of_movies DESC 
limit 3) AS genre_details)
ORDER BY  genre, year, movie_rank ASC ;

-- OUT OF MY CURIOSITY

SELECT genre, sum(worlwide_gross_income_in_dollars) as worlwide_gross_income_in_dollars
FROM clean_table
group by genre
order by worlwide_gross_income_in_dollars desc
limit 5;

/* My Notes: Adventure, Action and Drama have the highest worldwide gross income */

-- Finally, let’s find out the names of the top two productiON  houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two productiON  houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|productiON _company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, count(m.id) AS movie_count,
dense_rank () over (ORDER BY  count(m.id) DESC ) AS prod_company_rank
FROM movie m
INNER JOIN  ratings r
ON  m.id = r.movie_id
where production_company is  not null AND m.languages like '%\,%' AND r.median_rating>=8
GROUP BY  m.production_company
limit 2;

/* MY NOTES: Top two productiON  houses that have produced the highest number of hits (median rating >= 8)
 among multilingual movies are ‘Star Cinema’ and ‘Twentieth Century Fox’. */

-- Multilingual is the important piece in the above questiON . It wAS created using POSITION (',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than ONe language


-- Q28. Who are the top 3 actresses bASed ON  number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_AVG_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT n.name AS actress_name, sum(r.total_votes) AS total_votes,
count(rm.movie_id) AS movie_count, AVG(r.AVG_rating) AS actress_AVG_rating,
dense_rank () over (ORDER BY count(rm.movie_id) DESC, AVG(r.AVG_rating) DESC ) AS actress_rank
FROM names n
INNER JOIN  role_mapping rm
ON  n.id = rm.name_id
INNER JOIN  ratings r
ON  rm.movie_id = r.movie_id
INNER JOIN  genre g
ON  r.movie_id = g.movie_id
where rm.category = 'ACTRESS' AND r.AVG_rating > 8 AND genre = 'DRAMA'
GROUP BY  actress_name;

-- OUT OF MY CURIOSITY

SELECT n.name AS actress_name, sum(r.total_votes) AS total_votes,
count(rm.movie_id) AS movie_count, AVG(r.AVG_rating) AS actress_AVG_rating,
dense_rank () over (ORDER BY count(rm.movie_id) DESC, AVG(r.AVG_rating) DESC ) AS actress_rank
FROM names n
INNER JOIN  role_mapping rm
ON  n.id = rm.name_id
INNER JOIN  ratings r
ON  rm.movie_id = r.movie_id
where rm.category = 'ACTRESS' AND r.AVG_rating > 8
GROUP BY  actress_name;


/* MY NOTES : Susan Brown, Amanda Lawrence, Denise Gough are the top 3 actresses
based on number of Super Hit movies (average rating >8) (overall and) in  drama genre */


/* Q29. Get the following details for top 9 directors (bASed ON  number of movies)
Director id
Name
Number of movies
Average inter movie duratiON  in days
Average movie ratings
Total votes
Min rating
Max rating
total movie duratiONs

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	AVG_inter_movie_days |	AVG_rating	| total_votes  | min_rating	| max_rating | total_duratiON  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH table_1 AS (
SELECT d.name_id AS director_id, n.name AS director_name, d.movie_id, m.date_published, r.AVG_rating,
datediff (lead(date_published, 1) over (partitiON  by d.name_id ORDER BY  date_published), m.date_published) AS days_difference,
r.total_votes,
min(r.AVG_rating) over (partitiON  by d.name_id) AS min_rating,
max(AVG_rating) over (partitiON  by d.name_id) AS max_rating,
m.duratiON 
FROM  names n
INNER JOIN  director_mapping d
ON  n.id = d.name_id
INNER JOIN  movie m
ON  d.movie_id = m.id
INNER JOIN  ratings r
ON  m.id = r.movie_id
ORDER BY  director_id, date_published
)
 SELECT director_id, director_name, count(movie_id) AS number_of_movies,
 AVG(days_difference) AS AVG_inter_movie_days, AVG(AVG_rating) AS AVG_rating, sum(total_votes) AS total_votes,
 AVG(min_rating) AS min_rating, AVG(max_rating) AS max_rating, sum(duratiON ) AS total_duratiON 
FROM  table_1
GROUP BY  director_id
ORDER BY  number_of_movies  DESC, AVG_rating  DESC
limit 9;
