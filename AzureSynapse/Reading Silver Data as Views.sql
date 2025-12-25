-- create Ball By Ball view
CREATE OR ALTER VIEW gold.ball_by_ball
AS
    SELECT *
    FROM OPENROWSET(
        BULK 'https://iplanalysis.dfs.core.windows.net/silver/IPL_Ball_By_Ball/*.parquet',
        FORMAT = 'PARQUET'
    ) AS query1;

-- create Match view
CREATE OR ALTER VIEW gold.match
AS
    SELECT *
    FROM OPENROWSET(
        BULK 'https://iplanalysis.dfs.core.windows.net/silver/IPL_Match/*.parquet',
        FORMAT = 'PARQUET'
    ) AS query1;

-- create Player view
CREATE OR ALTER VIEW gold.player
AS
    SELECT *
    FROM OPENROWSET(
        BULK 'https://iplanalysis.dfs.core.windows.net/silver/IPL_Player/*.parquet',
        FORMAT = 'PARQUET'
    ) AS query1;

-- create Player Match view
CREATE OR ALTER VIEW gold.player_match
AS
    SELECT *
    FROM OPENROWSET(
        BULK 'https://iplanalysis.dfs.core.windows.net/silver/IPL_Player_Match/*.parquet',
        FORMAT = 'PARQUET'
    ) AS query1;

-- create Teams view
CREATE OR ALTER VIEW gold.teams
AS
    SELECT *
    FROM OPENROWSET(
        BULK 'https://iplanalysis.dfs.core.windows.net/silver/IPL_Team/*.parquet',
        FORMAT = 'PARQUET'
    ) AS query1;