/*CREATE LOGIN NandaSurendra

WITH PASSWORD = 'MI$T353Instructor'; 

CREATE USER NandaSurendra

FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra; */



if object_id('ReturnerStats') is not null
    drop table ReturnerStats;
if object_id('DefenderStats') is not null
    drop table DefenderStats;
if object_id('RunningBackStats') is not null
    drop table RunningBackStats;
if object_id('QuarterbackStats') is not null
    drop table QuarterbackStats;
if object_id('KickerStats') is not null
    drop table KickerStats;
if object_id('PunterStats') is not null
    drop table PunterStats;
if object_id('GamePrediction') is not null
    drop table GamePrediction;
if object_id('PlayerRoster') is not null
    drop table PlayerRoster;
if object_id('CoachRoster') is not null
    drop table CoachRoster;
if object_id('PlayerStats') is not null
    drop table PlayerStats;
if object_id('Roster') is not null
    drop table Roster;
if object_id('Coach') is not null
    drop table Coach;
if object_id('PlayerPosition') is not null
    drop table PlayerPosition;
if object_id('Position') is not null
    drop table Position;
if object_id('Player') is not null
    drop table Player;
if object_id('WeeklyPredictionResults') is not null
    drop table WeeklyPredictionResults;
if object_id('AppUserTeam') is not null
    drop table AppUserTeam;
if object_id('AppUser') is not null
    drop table AppUser;
if object_id('Game') is not null
    drop table Game;
if object_id('Team') is not null
    drop table Team;
if object_id('Conference') is not null
    drop table Conference;
if object_id('Stadium') is not null
    drop table Stadium;


go

create table Stadium
(
    StadiumId INT NOT NULL IDENTITY(1,1),
    StadiumName VARCHAR(50) NOT NULL,
    StadiumStreetAddress VARCHAR(50) NOT NULL,
    StadiumCity VARCHAR(50) NOT NULL,
    StadiumState CHAR(2) NOT NULL,
    StadiumCapacity INT NOT NULL,
    TypeOfField VARCHAR(20) NOT NULL,
    
    GameId INT NULL,
    constraint PK_Stadium PRIMARY KEY (StadiumId),
    constraint UQ_StadiumName UNIQUE (StadiumName, StadiumCity, StadiumState),
    constraint CK_TypeOfField CHECK (TypeOfField IN ('Grass', 'Artificial Turf'))
);

GO
create table Conference (
    ConferenceId INT NOT NULL IDENTITY(1,1),
    ConferenceName VARCHAR(50) NOT NULL,
    constraint PK_Conference PRIMARY KEY (ConferenceId),
    constraint UQ_Conference UNIQUE (ConferenceName)
);

go

create table Team (
    TeamId INT NOT NULL IDENTITY(1,1),
    UniversityName CHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    StadiumId INT NOT NULL,
    ConferenceId INT NOT NULL,
    constraint PK_Team PRIMARY KEY (TeamId),
    constraint UQ_UniversityName UNIQUE (UniversityName),
    constraint FK_Team_Conference FOREIGN KEY (ConferenceId) REFERENCES Conference(ConferenceId)
);

go

Create table Game (
    GameId INT NOT NULL IDENTITY(1,1),
    GameDate Date NOT NULL, 
    GameTime Time NOT NULL,
    HomeScore INT NULL,
    AwayScore INT NULL,
    HomeTeamId INT NOT NULL,
    AwayTeamId INT NOT NULL,
    WinnerTeamId INT NULL,

    constraint PK_Game PRIMARY KEY (GameId),
    constraint UQ_Game UNIQUE (HomeTeamId, GameDate, GameTime),
    constraint FK_Game_HomeScore FOREIGN KEY (HomeScore) REFERENCES Team(TeamId),
    constraint FK_Game_AwayScore FOREIGN KEY (AwayScore) REFERENCES Team(TeamId)
);

create table AppUser
(
    AppUserId INT NOT NULL IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    AppUserEmail VARCHAR(50) NOT NULL,
    AppUserPassword VARCHAR(50) NOT NULL,
    constraint PK_AppUser PRIMARY KEY (AppUserId),
    constraint UQ_AppUserEmail UNIQUE (AppUserEmail)
);

create table AppUserTeam
(
    AppUserId INT NOT NULL,
    TeamId INT NOT NULL,
    constraint PK_AppUserTeam PRIMARY KEY (AppUserId, TeamId),
    constraint FK_AppUserTeam_AppUser FOREIGN KEY (AppUserId) REFERENCES AppUser(AppUserId),
    constraint FK_AppUserTeam_Team FOREIGN KEY (TeamId) REFERENCES Team(TeamId)
);


go


create table WeeklyPredictionResults
(
    WPRId INT NOT NULL IDENTITY(1,1),
    StartDate DATE NOT NULL default GETDATE(),
    NumberofCorrectPredictions INT NOT NULL default 0,
    AppUserId INT NOT NULL,
    constraint PK_WeeklyPredictionResults PRIMARY KEY (WPRId),
    constraint FK_WeeklyPredictionResults_AppUser FOREIGN KEY (AppUserId) REFERENCES AppUser(AppUserId)
);

go

Create table Player (
    PlayerId INT NOT NULL IDENTITY(1,1),
    PlayerName VARCHAR(50) NOT NULL,
    PlayerDateofBirth DATE NOT NULL,
    constraint UQ_Player UNIQUE (PlayerName, PlayerDateofBirth),
    constraint PK_Player PRIMARY KEY (PlayerId),
);

go

Create table Position (
    PositionId INT NOT NULL IDENTITY(1,1),
    PositionName VARCHAR(50) NOT NULL,
    constraint PK_Position PRIMARY KEY (PositionId),
    constraint CK_PositionName CHECK (PositionName in ('Quarterback', 'Running Back', 'Returner', 'Defender', 'Kicker', 'Punter'))
);

go

create table PlayerPosition (
    PlayerPositionId INT NOT NULL IDENTITY(1,1),
    PlayerId INT NOT NULL,
    PositionId INT NOT NULL,
    constraint PK_PlayerPosition PRIMARY KEY (PlayerPositionId),
    constraint UQ_PlayerPosition UNIQUE (PlayerId, PositionId),
    constraint FK_PlayerPosition_Player FOREIGN KEY (PlayerId) REFERENCES Player(PlayerId),
    constraint FK_PlayerPosition_Position FOREIGN KEY (PositionId) REFERENCES Position(PositionId)
);

go



create table Coach (
    CoachId INT NOT NULL IDENTITY(1,1),
    CoachName VARCHAR(50) NOT NULL,
    TeamId INT NOT NULL,
    constraint PK_Coach PRIMARY KEY (CoachId),
    constraint UQ_Coach_Team UNIQUE (TeamId),
    constraint FK_Coach_Team FOREIGN KEY (TeamId) REFERENCES Team(TeamId)
);

go

create table Roster (
    RosterId INT NOT NULL IDENTITY(1,1),
    RosterYear INT NOT NULL,
    SeasonWins INT NOT NULL,
    SeasonLosses INT NOT NULL,
    SeasonTies INT NOT NULL,
    TeamId INT NOT NULL,
    constraint PK_Roster PRIMARY KEY (RosterId),
    constraint UQ_Roster UNIQUE (RosterYear, TeamId),
    constraint FK_Roster_Team FOREIGN KEY (TeamId) REFERENCES Team(TeamId)
);

go 

Create table PlayerStats(
    PlayerStatsId INT NOT NULL IDENTITY(1,1),
    PlayerId INT NOT NULL,
    RosterId INT NOT NULL,
    constraint PK_PlayerStats PRIMARY KEY (PlayerStatsId),
    constraint UQ_PlayerStats UNIQUE (PlayerId, RosterId),
    constraint FK_PlayerStats_Player FOREIGN KEY (PlayerId) REFERENCES Player(PlayerId),
    constraint FK_PlayerStats_Roster FOREIGN KEY (RosterId) REFERENCES Roster(RosterId)
);
go

create table CoachRoster (
    CoachRosterId INT NOT NULL IDENTITY(1,1),
    CoachId INT NOT NULL,
    RosterId INT NOT NULL,
    constraint PK_CoachRoster PRIMARY KEY (CoachRosterId),
    constraint UQ_CoachRoster UNIQUE (CoachId, RosterId),
    constraint FK_CoachRoster_Coach FOREIGN KEY (CoachId) REFERENCES Coach(CoachId),
    constraint FK_CoachRoster_Roster FOREIGN KEY (RosterId) REFERENCES Roster(RosterId)
);

go

create table PlayerRoster (
    PlayerRosterId INT NOT NULL IDENTITY(1,1),
    PlayerId INT NOT NULL,
    RosterId INT NOT NULL,
    constraint PK_PlayerRoster PRIMARY KEY (PlayerRosterId),
    constraint UQ_PlayerRoster UNIQUE (PlayerId, RosterId),
    constraint FK_PlayerRoster_Player FOREIGN KEY (PlayerId) REFERENCES Player(PlayerId),
    constraint FK_PlayerRoster_Roster FOREIGN KEY (RosterId) REFERENCES Roster(RosterId)
);

go


create table GamePrediction (
    GamePredictionId INT NOT NULL IDENTITY(1,1),
    PredictionDateTime DATETIME2 NOT NULL,
    GameId INT NOT NULL,
    AppUserId INT NOT NULL,
    PredictedTeamId INT NOT NULL,
    constraint PK_GamePrediction PRIMARY KEY (GamePredictionId),
    constraint UQ_GamePrediction UNIQUE (GameId, AppUserId),
    constraint FK_GamePrediction_Game FOREIGN KEY (GameId) REFERENCES Game(GameId),
    constraint FK_GamePrediction_AppUser FOREIGN KEY (AppUserId) REFERENCES AppUser(AppUserId),
    constraint FK_GamePrediction_PredictedTeam FOREIGN KEY (PredictedTeamId) REFERENCES Team(TeamId)
);

go

create table PunterStats (
    PunterStatsId INT NOT NULL IDENTITY(1,1),
    PlayerStatsId INT NOT NULL,
    Punts INT NOT NULL,
    Yards INT NOT NULL,
    Long INT NOT NULL,
    constraint PK_PunterStats PRIMARY KEY (PunterStatsId),
    constraint UQ_PunterStats UNIQUE (PlayerStatsId),
    constraint FK_PunterStats_PlayerStats FOREIGN KEY (PlayerStatsId) REFERENCES PlayerStats(PlayerStatsId),
);

go

create table KickerStats (
    KickerStatsId INT NOT NULL IDENTITY(1,1),
    PlayerStatsId INT NOT NULL,
    FieldGoalMade INT NOT NULL,
    FieldGoalAttempt INT NOT NULL,
    LongestFieldGoal INT NOT NULL,
    ExtraPointMade INT NOT NULL,
    ExtraPointAttempted INT NOT NULL,
    constraint PK_KickerStats PRIMARY KEY (KickerStatsId),
    constraint UQ_KickerStats UNIQUE (PlayerStatsId),
    constraint FK_KickerStats_PlayerStats FOREIGN KEY (PlayerStatsId) REFERENCES PlayerStats(PlayerStatsId)
);

go


create table QuarterbackStats (
    QuarterbackStatsId INT NOT NULL IDENTITY(1,1),
    PlayerStatsId INT NOT NULL,
    Completions INT NOT NULL,
    Attempts INT NOT NULL,
    QBYards INT NOT NULL,
    PassingTouchdowns INT NOT NULL,
    Interceptions INT NOT NULL,
    constraint PK_QuarterbackStats PRIMARY KEY (QuarterbackStatsId),
    constraint UQ_QuarterbackStats UNIQUE (PlayerStatsId),
    constraint FK_QuarterbackStats_PlayerStats FOREIGN KEY (PlayerStatsId) REFERENCES PlayerStats(PlayerStatsId)
);

go

create table RunningBackStats (
    RunningBackStatsId INT NOT NULL IDENTITY(1,1),
    PlayerStatsId INT NOT NULL,
    RBCarries INT NOT NULL,
    RBYards INT NOT NULL,
    RBTouchdowns INT NOT NULL,
    RBReceptions INT NOT NULL,
    RBFumbles INT NOT NULL,
    constraint PK_RunningBackStats PRIMARY KEY (RunningBackStatsId),
    constraint UQ_RunningBackStats UNIQUE (PlayerStatsId),
    constraint FK_RunningBackStats_PlayerStats FOREIGN KEY (PlayerStatsId) REFERENCES PlayerStats(PlayerStatsId)
);

go

create table DefenderStats (
    DefenderStatsId INT NOT NULL IDENTITY(1,1),
    PlayerStatsId INT NOT NULL,
    Tackles INT NOT NULL,
    Sacks INT NOT NULL,
    Interceptions INT NOT NULL,
    DefensiveTD INT NOT NULL,
    constraint PK_DefenderStats PRIMARY KEY (DefenderStatsId),
    constraint UQ_DefenderStats UNIQUE (PlayerStatsId),
    constraint FK_DefenderStats_PlayerStats FOREIGN KEY (PlayerStatsId) REFERENCES PlayerStats(PlayerStatsId)
);

go

create table ReturnerStats (
    ReturnerStatsId INT NOT NULL IDENTITY(1,1),
    PlayerStatsId INT NOT NULL,
    PuntReturnAttempt INT NOT NULL,
    PuntReturnYards INT NOT NULL,
    PuntReturnTouchdowns INT NOT NULL,
    PuntReturnLong INT NOT NULL,
    KickReturnAttempt INT NOT NULL,
    KickReturnYards INT NOT NULL,
    KickReturnTouchdowns INT NOT NULL,
    KickReturnLong INT NOT NULL,
    constraint PK_ReturnerStats PRIMARY KEY (ReturnerStatsId),
    constraint UQ_ReturnerStats UNIQUE (PlayerStatsId),
    constraint FK_ReturnerStats_PlayerStats FOREIGN KEY (PlayerStatsId) REFERENCES PlayerStats(PlayerStatsId)
);



