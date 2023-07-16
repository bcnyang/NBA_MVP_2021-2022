-- Selecting everything from the MVP Table
SELECT * FROM MVP

-- COUNTING number of records in table 
SELECT COUNT(*) FROM MVP

-- COUNTING number of games played in season
SELECT COUNT(gs) FROM MVP
WHERE gs = 1




-- COUNTING Number of wins where he played
SELECT  COUNT(game_outcome) As wins FROM MVP
WHERE gs=1
AND game_outcome ILIKE '%W%'

-- COUNTING Number of l's where he played 
SELECT  COUNT(game_outcome) As losses FROM MVP
WHERE gs=1
AND game_outcome ILIKE '%L%'


-- COUNTING lost games where he didn't play
SELECT  COUNT(game_outcome)FROM MVP
WHERE gs is NULL
AND game_outcome ILIKE '%L%'

-- COUNTING lost games where he didn't play by team
SELECT opp, game_date,COUNT(game_outcome)FROM MVP
WHERE gs is NULL
AND game_outcome ILIKE '%L%'
GROUP BY opp,game_date
ORDER BY game_date;

--Game outcome against Philadelphia and stats in those games
SELECT game_outcome,game_date,mp,fga,fg,three_point_attempts,three_points, trb, ast,pts from MVP
WHERE OPP = 'PHI';


-- MAXIMUM POINTS, AST,STEALS,BLOCKS  AND  REBOUNDS IN THE SEASON 
SELECT opp,MAX(PTS) AS Max_points, MAX(AST) AS Max_assits, MAX(TRB) AS Max_rebounds,MAX(BLK) AS Max_blk, MAX(STL) AS Max_steals,MAX(MP) AS Max_Minutes_played
FROM MVP
GROUP BY opp
ORDER BY 2 DESC
LIMIT 5;



-- MINIMUM POINTS, AST,STEALS,BLOCKS,Minutes played  AND  REBOUNDS IN THE SEASON 
SELECT opp,MIN(PTS) AS Min_points, MIN(AST) AS Min_assits, MIN(TRB) AS Min_rebounds,MIN(BLK) AS Min_blk, MIN(STL) AS Min_steals,MIN(MP) AS Min_Minutes_played
FROM MVP
GROUP BY opp
ORDER BY 2 DESC
LIMIT 5;

-- Average  POINTS, AST,STEALS,BLOCKS,Minutes played  AND  REBOUNDS IN THE SEASON
SELECT ROUND(AVG(PTS),2) AS Avg_points, 
ROUND(AVG(AST),2) AS Avg_assits, 
ROUND(AVG(TRB),2) AS Avg_rebounds,
ROUND(AVG(BLK),2) AS Avg_blk, 
ROUND(AVG(STL),2) AS Avg_steals,
ROUND(AVG(MP),2) AS Avg_Minutes_played
FROM MVP
--GROUP BY opp;

-- Count number of trible doubles in a season 
SELECT COUNT(*) AS Triple_Doubles FROM MVP
where ast>= 10
and pts>=10
and trb>=10

-- Count number of trible doubles grouped  by team
SELECT opp,COUNT(*) AS Triple_Doubles FROM MVP
where ast>= 10
and pts>=10
and trb>=10
GROUP BY opp
ORDER BY COUNT(*);


--COUNT number of Double-Doubles in the season
SELECT count(*)  AS Double_Doubles FROM MVP
where pts>= 10
and trb>=10

-- COUNT Number of Double-Doubles grouped  by team
SELECT opp,count(*)  AS Double_Doubles FROM MVP
where pts>= 10
and trb>=10
GROUP BY opp
ORDER BY COUNT(*);


--Number of freethows attempted vs made
SELECT opp,fta AS total_free_throws_attempted,
ft AS total_free_throws_made,
ROUND(AVG(FT),2) AS Avg_free_throws
from mvp
where fta != 0
AND ft !=0
GROUP BY opp,fta,ft

--Number of 3points attempted vs made attempted vs made
SELECT opp, three_point_attempts AS total_threepoints_attempts,
three_points AS total_three_points_made,
ROUND(AVG (three_points),2) AS Avg_threepoints
FROM mvp
where three_point_attempts !=0
AND three_points !=0
GROUP BY opp,three_point_attempts,three_points ;

-- CASE Statement to group Minutes played 
SELECT opp,mp AS minutes_played,
CASE 
WHEN mp BETWEEN 10 AND 19 THEN 'Low' 
WHEN mp BETWEEN 20 AND 29 THEN 'Medium' 
WHEN mp BETWEEN 30 AND 39 THEN 'Average'
WHEN mp BETWEEN 40 AND 49 THEN 'High'
ELSE 'Did Not Play'
END 
FROM MVP
GROUP BY opp,mp
Order BY mp

--Finding out what Jokic salary was for the year. Had to use LiMIT 1 because the data is specific to Jokic 82 games
SELECT n.name, n.salary,n.team
from nba_salary n
JOIN  mvp m 
ON m.team = n.team
where N.name LIKE '%Nikola Jokic%'
LIMIT 1

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
WHERE team = 'Denver Nuggets'

-- Finding players with the Most points+rebounds+assist in the season
SELECT d.player,d.team, d.PtstrbAst,  MAX(PtstrbAst) OVER(PARTITION BY  PtstrbAst) AS top_scorer
FROM(
SELECT player, team, (Pts+trb+Ast) AS PtstrbAst 
FROM regular_season) as d 
--WHERE team = 'DEN'
ORDER BY PtstrbAst DESC 

   
SELECT player, team, PtstrbAst, RANK() OVER(ORDER  BY PtstrbAst )
FROM(
    SELECT d.player,d.team, d.PtstrbAst,  MAX(PtstrbAst) OVER(PARTITION BY  PtstrbAst) AS top_scorer
    FROM(
          SELECT player, team, (Pts+trb+Ast) AS PtstrbAst 
             FROM regular_season) as d ) AS rk
              --WHERE team = 'DEN'
              ORDER BY PtstrbAst  DESC



