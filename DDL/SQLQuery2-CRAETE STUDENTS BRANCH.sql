--SQLQuery2-CRAETE STUDENTS BRANCH.sql

USE PV_522_DDL;

CREATE TABLE Directions
(
	direction_id SMALLINT PRIMARY KEY,
	direction_name NVARCHAR(50) NOT NULL

);


CREATE TABLE Groups
(
	group_id		INT				PRIMARY KEY,
	group_name		NVARCHAR(24)	NOT NULL,
	start_date		DATE			NOT NULL,
	start_time		TIME			NOT NULL,
	lerning_days	INT				NOT NULL,
	direction		SMALLINT		NOT NULL
	CONSTRAINT	FK_Groups_Directions FOREIGN KEY REFERENCES Directions(direction_id)



);