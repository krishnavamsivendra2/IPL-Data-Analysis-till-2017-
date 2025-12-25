-- viweing column names in ball_by_ball
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold'
  AND TABLE_NAME = 'ball_by_ball'
ORDER BY ORDINAL_POSITION;

---- Aggregates ball-by-ball data to find total runs scored by each player per season
CREATE OR ALTER VIEW gold.top_scoring_batsmen_per_season AS
SELECT
    p.player_name,
    m.season_year,
    SUM(b.runs_scored) AS total_runs
FROM gold.ball_by_ball b
JOIN gold.match m
    ON b.match_id = m.match_id
JOIN gold.player_match pm
    ON m.match_id = pm.match_id
   AND b.striker = pm.player_id
JOIN gold.player p
    ON p.player_id = pm.player_id
GROUP BY
    p.player_name,
    m.season_year;

-- Analyzes powerplay bowling performance by country based on economy and wickets
--part-A
CREATE OR ALTER VIEW gold.economic_bowler AS
SELECT
    p.country_name,
    p.player_name,
    AVG(b.runs_scored) AS avg_runs_per_ball,
    SUM(CASE WHEN b.bowler_wicket = 1 THEN 1 ELSE 0 END) AS total_wickets
FROM gold.ball_by_ball b
JOIN gold.player_match pm
    ON b.match_id = pm.match_id
   AND b.bowler = pm.player_id
JOIN gold.player p
    ON pm.player_id = p.player_id
WHERE b.over_id <= 6
GROUP BY
    p.country_name,
    p.player_name;

--part-B
SELECT *
FROM gold.economic_bowler
ORDER BY avg_runs_per_ball ASC, total_wickets DESC;

-- Evaluates whether the toss winner won or lost each individual match
--part-A
CREATE OR ALTER VIEW gold.result_based_on_toss AS
SELECT
    m.match_id,
    m.Season_Year,
    m.toss_winner,
    m.toss_name,
    m.match_winner,
    CASE
        WHEN m.toss_winner = m.match_winner THEN 'Won'
        ELSE 'Lost'
    END AS match_outcome
FROM gold.match m
WHERE m.toss_name IS NOT NULL;

--part-B
SELECT *
FROM gold.result_based_on_toss
ORDER BY match_id,Season_Year;



--Win percentage of teams per season, based on toss outcome
--part-A
CREATE OR ALTER VIEW gold.win_percentage_based_on_toss_per_season AS
SELECT
    toss_winner AS team_name,
    season_year,
    CAST(
        100.0 * COUNT(CASE WHEN toss_winner = match_winner THEN 1 END)
        / COUNT(*)
        AS DECIMAL(6,2)
    ) AS win_percentage
FROM gold.match
WHERE toss_winner IS NOT NULL
GROUP BY
    toss_winner,
    season_year;

--part-B
SELECT *
FROM gold.win_percentage_based_on_toss_per_season
ORDER BY
    season_year,
    win_percentage DESC;

-- Calculates average runs scored per ball by players in matches their team won
--part-A
CREATE OR ALTER VIEW gold.avrg_runs_per_ball_by_player_in_won_matches AS
SELECT
    p.player_name,
    AVG(b.runs_scored) AS avg_runs_in_wins,
    COUNT(*) AS balls_faced
FROM gold.ball_by_ball b
JOIN gold.player_match pm
    ON b.match_id = pm.match_id
   AND b.striker = pm.player_id
JOIN gold.player p
    ON pm.player_id = p.player_id
JOIN gold.match m
    ON pm.match_id = m.match_id
WHERE m.match_winner = pm.player_team
GROUP BY
    p.player_name;

--part-B
SELECT * 
FROM gold.avrg_runs_per_ball_by_player_in_won_matches
ORDER BY
    avg_runs_in_wins ASC;

-- Calculates average and highest match scores for each venue
--part-A
CREATE OR ALTER VIEW gold.highest_score_of_a_venue AS
SELECT
    venue_name,
    AVG(total_runs) AS average_score,
    MAX(total_runs) AS highest_score
FROM (
    SELECT
        b.match_id,
        m.venue_name,
        SUM(b.runs_scored + b.extra_runs) AS total_runs
    FROM gold.ball_by_ball b
    JOIN gold.match m
        ON b.match_id = m.match_id
    GROUP BY
        b.match_id,
        m.venue_name
) t
GROUP BY
    venue_name;

--part-B
SELECT *
FROM gold.highest_score_of_a_venue
ORDER BY
    average_score DESC;

-- Counts how often each type of dismissal occurs in IPL matches
--part-A
CREATE OR ALTER VIEW gold.dismissal_count AS
SELECT
    out_type,
    COUNT(*) AS frequency
FROM gold.ball_by_ball
WHERE out_type IS NOT NULL
GROUP BY
    out_type;

--part-B
SELECT * 
FROM gold.dismissal_count
ORDER BY
    frequency DESC;

-- Shows season-wise match wins for Team1 after winning the toss
--part-A
CREATE OR ALTER VIEW gold.season_wise_match_wins AS
SELECT
    team1 AS team_name,
    season_year,
    COUNT(*) AS matches_played,
    SUM(
        CASE 
            WHEN toss_winner = match_winner THEN 1 
            ELSE 0 
        END
    ) AS wins_after_toss
FROM gold.match
WHERE toss_winner = team1
GROUP BY
    team1,
    season_year;

--part-B
SELECT *
FROM gold.season_wise_match_wins
ORDER BY
    season_year,
    wins_after_toss DESC;

