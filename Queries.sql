-- Updating the caption of post_id 3 --
UPDATE posts
SET caption = 'My favourite Pizz'
WHERE post_id = 3;

-- Selecting all the posts where user_id is 1
SELECT *
FROM posts
WHERE user_id = 1;

-- Selecting all posts and ordering them by created_at in descending order
SELECT * 
FROM posts
ORDER BY created_at DESC;

-- Counting the number of likes for each post and showing only the posts with more than 2 likes
SELECT Posts.post_id, count(Likes.like_id) as num_likes 
FROM posts 
LEFT JOIN likes ON Posts.post_id = likes.post_id
GROUP BY Posts.post_id
HAVING COUNT(Likes.like_id) > 2;

-- Finding the total number of likes for all posts
SELECT SUM(num_likes) AS total_likes
FROM (
    SELECT COUNT(Likes.like_id) AS num_likes
    FROM Posts
    LEFT JOIN Likes ON Posts.post_id = Likes.post_id
    GROUP BY Posts.post_id
) AS likes_by_post;

-- Find all the users who commented on post_id 1
using sub query
SELECT * FROM users WHERE user_id IN(
SELECT user_id FROM comments WHERE post_id = 1
);

-- Ranking the posts based on the number of likes
SELECT Pospost_id, number_likes, RANK() OVER(ORDER BY number_likes DESC) AS rank
FROM(
	SELECT Posts.post_id, count(Likes.like_id) number_likes FROM Posts as p 
	JOIN Likes ON Posts.post_id = Likes.like_id
	GROUP BY Posts.posts_id
) AS likes_by_post;

-- Finding all the posts and their comments using a Common Table Epression (CTE)
WITH post_comments AS(
	SELECT Posts.post_id, Posts.caption, Comments.comment_text
	FROM Posts
	LEFT JOIN Comments ON Posts.post_id = Comments.post_id
)
SELECT *
FROM post_comments;

-- Categorizing the posts based on the number of likes
SELECT
	post_id,
	CASE
		WHEN num_likes = 0 THEN 'No likes'
		WHEN num_likes < 5 THEN 'Few likes'
		WHEN num_likes <10 THEN 'Some likes'
		ELSE 'Lots of likes'
	END AS like_category
FROM (
	SELECT Posts.post_id, COUNT(Likes.like_id) AS num_likes
	FROM Posts
	LEFT JOIN Likes ON Posts.post_id = Likes.post_id
	GROUP BY Posts.post_id
) AS likes_by_post;


-- Finding all the posts created in the last month
SELECT * 
FROM Posts
WHERE created_at >= CAST(DATE_TRUNC('month', CURRENT_TIMESTAMP - INTERVAL '1 month') AS DATE);