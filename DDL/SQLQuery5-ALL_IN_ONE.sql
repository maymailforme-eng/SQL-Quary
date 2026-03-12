-- SQLQuery5-ALL_IN_ONE

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ÑÎÇÄÀÍÈÅ ÁÄ 

USE master;

CREATE DATABASE PV_522_ALL_IN_ON

ON
(
	NAME		= PV_522_ALL_IN_ON, 
	FILENAME	= 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\PV_522_ALL_IN_ON.mdf',
	SIZE		= 8 MB, 
	MAXSIZE		= 500 MB,
	FILEGROWTH	= 8 MB
)

LOG ON
(
	NAME		= PV_522_ALL_IN_ON_Log,
	FILENAME	= 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\PV_522_ALL_IN_ON.ldf',
	SIZE		= 8 MB,
	MAXSIZE		= 500 MB,
	FILEGROWTH	= 8 MB
);
GO 

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ÑÎÇÄÀÍÈÅ ÒÀÁËÖÈ Â ÁÄ PV_522_ALL_IN_ON

USE PV_522_ALL_IN_ON;


CREATE TABLE Directions
(
	direction_id		SMALLINT		PRIMARY KEY,
	direction_name		NVARCHAR(50)	NOT NULL

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


CREATE TABLE Students
(
	student_id		INT				PRIMARY KEY,
	last_name		NVARCHAR(50)	NOT NULL,
	first_name		NVARCHAR(50)	NOT NULL,
	middle_name		NVARCHAR(50),
	birth_day		DATE,
	[group]			INT				NOT NULL
	CONSTRAINT		FK_Students_Groups FOREIGN KEY REFERENCES Groups(group_id)
);


CREATE TABLE Teachers
(
	teacher_id		INT					PRIMARY KEY,
	last_name		NVARCHAR(50)		NOT NULL,
	first_name		NVARCHAR(50)		NOT NULL,
	middle_name		NVARCHAR(50),
	birth_day		DATE,
	rate			INT
);

CREATE TABLE Disciplines
(
	discipline_id		SMALLINT		PRIMARY KEY,
	discipline_name		NVARCHAR(150)	NOT NULL,
	number_of_lesson	TINYINT			NOT NULL,
);


CREATE TABLE TeachersDisciplinesRelation
(
	teacher				INT, 
	discipline			SMALLINT,
	PRIMARY KEY (teacher, discipline), 
	CONSTRAINT FK_TDR_Teachers FOREIGN KEY (teacher) REFERENCES Teachers(teacher_id),
	CONSTRAINT FK_TDR_Discipline FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id)  
);


CREATE TABLE DisciplinesDirectionRelation
(
	discipline	SMALLINT,
	direction	SMALLINT,
	PRIMARY KEY	(discipline, direction),
	CONSTRAINT  FK_DDR_Discipline	FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id),
	CONSTRAINT  FK_DDR_Direction	FOREIGN KEY (direction) REFERENCES Directions(direction_id)

);


CREATE TABLE Schedule
(
	lesson_id	INT				PRIMARY KEY,
	discipline	SMALLINT		NOT NULL,	
	[group]		INT				NOT NULL, 
	teacher		INT				NOT NULL,

	[date]		date			NOT NULL,
	[time]		time			NOT NULL,
	[subject]	VARCHAR(255)	NOT NULL,
	spent		bit				NOT NULL,


	CONSTRAINT	FK_Schedule_Disciplines FOREIGN KEY (discipline)	REFERENCES Disciplines(discipline_id),
	CONSTRAINT	FK_Schedule_Groups		FOREIGN KEY	([group])		REFERENCES Groups(group_id),
	CONSTRAINT	FK_Schedule_Teachers	FOREIGN KEY (teacher)		REFERENCES Teachers(teacher_id)

);


CREATE TABLE Grades
(
	student			INT			NOT NULL,
	lesson			INT			NOT NULL,
	PRIMARY KEY (student, lesson),
	CONSTRAINT		FK_Grades_Students FOREIGN KEY (student)	REFERENCES Students(student_id),
	CONSTRAINT		FK_Grades_Schedule FOREIGN KEY (lesson)		REFERENCES Schedule(lesson_id),
	grade_1			TINYINT CONSTRAINT CK_Grade_1 CHECK(grade_1 > 0 AND grade_1 <= 12),
	grade_2			TINYINT CONSTRAINT CK_Grade_2 CHECK(grade_1 > 0 AND grade_1 <= 12),

);


CREATE TABLE HomeWorks
(
	[group]			INT				NOT NULL,
	lesson			INT				NOT NULL,
	[data]			VARBINARY(2000) NOT NULL,
	[description]	VARCHAR(255),
	deadline		DATE,

	PRIMARY KEY ([group], lesson),
	CONSTRAINT		FK_HomeWorks_Groups		FOREIGN KEY ([group])	REFERENCES Groups(group_id),
	CONSTRAINT		FK_HomeWorks_Schedule	FOREIGN KEY (lesson)	REFERENCES Schedule(lesson_id)
);


CREATE TABLE HWResults
(
	lesson			INT			NOT NULL,
	[group]			INT			NOT NULL,
	student			INT			NOT NULL,
	[description]	VARCHAR(255),
	[data]			VARBINARY(2000),
	grade			INT,
	comment			VARCHAR(255),

	PRIMARY KEY	(lesson, [group], student),
	CONSTRAINT		FK_HWResults_Schedule		FOREIGN KEY (lesson)	REFERENCES Schedule(lesson_id),
	CONSTRAINT		FK_HWResults_Groups			FOREIGN KEY ([group])	REFERENCES Groups(group_id),
	CONSTRAINT		FK_HWResults_Students		FOREIGN KEY (student)	REFERENCES Students(student_id),

);


CREATE TABLE Exams
(
	student			INT			NOT NULL,
	discipline		SMALLINT	NOT NULL,
	teacher			INT			NOT NULL,
	grade			INT,

	PRIMARY KEY(student, discipline),
	CONSTRAINT		FK_Exams_Students		FOREIGN KEY (student)		REFERENCES Students(student_id),
	CONSTRAINT		FK_Exams_Disciplines	FOREIGN KEY (discipline)	REFERENCES Disciplines(discipline_id),
	CONSTRAINT		FK_Exams_Teachers		FOREIGN KEY (teacher)		REFERENCES Teachers(teacher_id)
);