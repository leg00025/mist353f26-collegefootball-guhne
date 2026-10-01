/*CREATE LOGIN NandaSurendra

WITH PASSWORD = 'MI$T353Instructor'; 

CREATE USER NandaSurendra

FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra; */

if object_id('Stadium') is not null
    drop table Stadium;
if object_id('Team') is not null
    drop table Team;
if object_id('Game') is not null
    drop table Game;

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

create table Team (
    TeamId INT NOT NULL IDENTITY(1,1),
    UniversityName CHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    StadiumId INT NOT NULL,
    constraint PK_Team PRIMARY KEY (TeamId),
    constraint UQ_UniversityName UNIQUE (UniversityName)

);



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