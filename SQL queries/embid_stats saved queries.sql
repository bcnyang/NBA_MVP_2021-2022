-- Selecting everything from the Embid_stats Table
SELECT * FROM embid_stats;

-- COUNTING number of records in table 
SELECT COUNT(*) FROM embid_stats;

-- COUNTING number of games played in season
SELECT COUNT(gs) FROM embid_stats
WHERE gs = 1;

-- COUNTING Number of wins where he played
SELECT COUNT(game_outcome)FROM embid_stats
WHERE gs=1
AND game_outcome ILIKE '%W%';

-- COUNTING lost games where he didn't play
SELECT COUNT(game_outcome)FROM embid_stats
WHERE gs is Null
AND game_outcome ILIKE '%L%';

-- COUNTING lost games where he didn't play by team
SELECT opp, game_date,game_outcome,COUNT(game_outcome)FROM embid_stats
WHERE gs is NULL
AND game_outcome ILIKE '%L%'
GROUP BY opp,game_date,game_outcome
ORDER BY game_date;

--Game outcome against Denver and stats in those games
SELECT game_outcome,mp,fga,fg,three_point_attempts,three_points, trb, ast,pts from embid_stats
WHERE OPP = 'DEN';

-- MAXIMUM POINTS, AST,STEALS,BLOCKS,Minutes played AND  REBOUNDS IN THE SEASON 
SELECT opp, MAX(PTS) AS Max_points, MAX(AST) AS Max_assits, MAX(TRB) AS Max_rebounds,MAX(BLK) AS Max_blk, MAX(STL) AS Max_steals,MAX(MP) AS Max_Minutes_played
FROM embid_stats
WHERE (pts, ast, trb, blk,stl,mp) IS NOT NULL
GROUP BY opp
ORDER BY 2 DESC
LIMIT 5;

-- MINIMUM POINTS, AST,STEALS,BLOCKS,Minutes played  AND  REBOUNDS IN THE SEASON 
SELECT opp, MIN(PTS) AS Min_points, MIN(AST) AS Min_assits, MIN(TRB) AS Min_rebounds,MIN(BLK) AS Min_blk, MIN(STL) AS Min_steals, MIN(MP) AS Min_Minutes_played
FROM embid_stats
GROUP BY opp
ORDER BY 2
LIMIT 5 ;

-- Average  POINTS, AST,STEALS,BLOCKS,Minutes played  AND  REBOUNDS IN THE SEASON
SELECT ROUND(AVG(PTS),2) AS Avg_points, 
ROUND(AVG(AST),2) AS Avg_assits, 
ROUND(AVG(TRB),2) AS Avg_rebounds,
ROUND(AVG(BLK),2) AS Avg_blk, 
ROUND(AVG(STL),2) AS Avg_steals,
ROUND(AVG(MP),2) AS Avg_Minutes_played
FROM embid_stats;

-- Count number of trible doubles in a season 
SELECT COUNT(*) AS Triple_Doubles FROM embid_stats
where ast>= 10
and pts>=10
and trb>=10;

-- Count number of trible doubles grouped  by team
SELECT opp,COUNT(*) AS Triple_Doubles FROM MVP
where ast>= 10
and pts>=10
and trb>=10
GROUP BY opp
ORDER BY COUNT(*);

--COUNT number of Double-Doubles in the season
SELECT  count(*)  AS Double_Doubles FROM embid_stats
where pts>= 10
and trb>=10;

-- COUNT Number of Double-Doubles grouped  by team
SELECT opp,count(*)  AS Double_Doubles FROM embid_stats
where pts>= 10
and trb>=10
GROUP BY opp
ORDER BY COUNT(*);

--Number of freethows attempted vs made
SELECT opp,ft AS total_free_throws_made,
fta AS total_free_throws_attempted,
ROUND(AVG(FT),2) AS Avg_free_throws
FROM embid_stats
WHERE fta IS NOT NULL
AND FT IS NOT NULL
GROUP BY opp,fta,ft;

--Number of 3points attempted vs made attempted vs made
SELECT opp, three_point_attempts AS total_threepoints_attempts,
three_points AS total_three_points_made,
ROUND(AVG (three_points),2) AS Avg_threepoints
FROM embid_stats
WHERE three_point_attempts IS NOT NULL
AND three_points IS NOT NULL
GROUP BY opp,three_point_attempts,three_points;

-- CASE Statement to group Minutes played 
SELECT opp,mp,
CASE 
WHEN mp BETWEEN 10 AND 19 THEN 'Low' 
WHEN mp BETWEEN 20 AND 29 THEN 'Medium' 
WHEN mp BETWEEN 30 AND 39 THEN 'Average'
WHEN mp BETWEEN 40 AND 49 THEN 'High'
ELSE 'Did Not Play'
END 
FROM embid_stats
Order BY mp;



--Finding out what Embids salary was for the year. Had to use LiMIT 1 because the data is specific to embid 82 games
SELECT n.name, n.salary,n.team
from nba_salary n
INNER JOIN  embid_stats e
ON e.team = n.team
where n.name LIKE '%Joel Embiid%'
LIMIT 1;

-- Window Function to find Salary and rank by Center position
SELECT name, team , salary,
RANK() Over(Order by Salary desc ) as RK,
DENSE_RANK() Over(Order by Salary desc) as DRK,
Row_number() Over (Order by Salary desc) as Row_No
FROM nba_salary
WHERE player_position LIKE '%C%'

-- Window Function to find Salary and rank by team
SELECT name, team , salary,
RANK() Over(Order by Salary desc ) as RK,
DENSE_RANK() Over(Order by Salary desc) as DRK,
Row_number() Over (Order by Salary desc) as Row_No
FROM nba_salary
WHERE team = 'Philadelphia 76ers'

-- Finding players with the Most points+rebounds+assist per team
SELECT d.player,d.team, d.PtstrbAst,  MAX(PtstrbAst) OVER(PARTITION BY team, PtstrbAst) AS top_scorer
FROM(
SELECT player, team, (Pts+trb+Ast) AS PtstrbAst 
FROM regular_season) as d 
WHERE team = 'PHI'
ORDER BY team, PtstrbAst DESC





