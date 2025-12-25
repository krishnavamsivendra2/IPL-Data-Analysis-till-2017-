CREATE MASTER KEY ENCRYPTION BY PASSWORD ='<password>' 

CREATE DATABASE SCOPED CREDENTIAL <credential_name>
WITH IDENTITY = 'identity_name'

CREATE EXTERNAL DATA SOURCE gold_dest
WITH(
    LOCATION = 'https://iplanalysis.dfs.core.windows.net/<gold_container_name>',
    CREDENTIAL = <credential_name>
)

CREATE EXTERNAL FILE FORMAT gold_format
WITH(
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
);

--1 -> gold.top_scoring_batsmen_per_season
CREATE EXTERNAL TABLE gold_ext.top_scoring_batsmen_per_season
WITH (
    LOCATION = 'top_scoring_batsmen_per_season/',
    DATA_SOURCE = gold_dest,
    FILE_FORMAT = gold_format
)
AS
SELECT *
FROM gold.top_scoring_batsmen_per_season;

--2 -> gold.economic_bowler
CREATE EXTERNAL TABLE gold_ext.economic_bowler
WITH (
    LOCATION = 'economic_bowler/',
    DATA_SOURCE = gold_dest,
    FILE_FORMAT = gold_format
)
AS
SELECT *
FROM gold.economic_bowler;

--3 -> gold.result_based_on_toss
CREATE EXTERNAL TABLE gold_ext.result_based_on_toss
WITH (
    LOCATION = 'result_based_on_toss/',
    DATA_SOURCE = gold_dest,
    FILE_FORMAT = gold_format
)
AS
SELECT *
FROM gold.result_based_on_toss;

--4 -> gold.win_percentage_based_on_toss_per_season
CREATE EXTERNAL TABLE gold_ext.win_percentage_based_on_toss_per_season
WITH (
    LOCATION = 'win_percentage_based_on_toss_per_season/',
    DATA_SOURCE = gold_dest,
    FILE_FORMAT = gold_format
)
AS
SELECT *
FROM gold.win_percentage_based_on_toss_per_season;

--5 -> gold.avrg_runs_per_ball_by_player_in_won_matches
CREATE EXTERNAL TABLE gold_ext.avg_runs_per_ball_by_player_in_won_matches
WITH (
    LOCATION = 'avg_runs_per_ball_by_player_in_won_matches/',
    DATA_SOURCE = gold_dest,
    FILE_FORMAT = gold_format
)
AS
SELECT *
FROM gold.avrg_runs_per_ball_by_player_in_won_matches;

--6 -> gold.highest_score_of_a_venue
CREATE EXTERNAL TABLE gold_ext.highest_score_of_a_venue
WITH (
    LOCATION = 'highest_score_of_a_venue/',
    DATA_SOURCE = gold_dest,
    FILE_FORMAT = gold_format
)
AS
SELECT *
FROM gold.highest_score_of_a_venue;

--7 -> gold.dismissal_count
CREATE EXTERNAL TABLE gold_ext.dismissal_count
WITH (
    LOCATION = 'dismissal_count/',
    DATA_SOURCE = gold_dest,
    FILE_FORMAT = gold_format
)
AS
SELECT *
FROM gold.dismissal_count;

--8 -> gold.season_wise_match_wins
CREATE EXTERNAL TABLE gold_ext.season_wise_match_wins
WITH (
    LOCATION = 'season_wise_match_wins/',
    DATA_SOURCE = gold_dest,
    FILE_FORMAT = gold_format
)
AS
SELECT *
FROM gold.season_wise_match_wins;