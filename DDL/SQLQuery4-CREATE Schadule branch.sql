--SQLQuery4-CREATE Schadule branch.sql

USE PV_522_DDL;

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
	student		INT		NOT NULL,
	lesson		INT     NOT NULL,
	PRIMARY KEY (student, lesson),
	CONSTRAINT	FK_Grades_Students FOREIGN KEY (student)	REFERENCES Students(student_id),
	CONSTRAINT	FK_Grades_Schedule FOREIGN KEY (lesson)		REFERENCES Schedule(lesson_id),
);


CREATE TABLE HomeWorks
(
	[group]			INT				NOT NULL,
	lesson			INT				NOT NULL,
	[data]			VARBINARY(2000) NOT NULL,
	[description]	VARCHAR(255),
	deadline		DATE,

	PRIMARY KEY ([group], lesson),
	CONSTRAINT FK_HomeWorks_Groups		FOREIGN KEY ([group])	REFERENCES Groups(group_id),
	CONSTRAINT FK_HomeWorks_Schedule	FOREIGN KEY (lesson)	REFERENCES Schedule(lesson_id)
);


CREATE TABLE HWResults
(
	lesson		INT		NOT NULL,
	[group]		INT		NOT NULL,
	student		INT		NOT NULL,
	[description]	VARCHAR(255),
	[data]			VARBINARY(2000),
	grade			INT,
	comment			VARCHAR(255),
	PRIMARY KEY(lesson, [group], student),

	CONSTRAINT	FK_HWResults_Schedule		FOREIGN KEY (lesson)	REFERENCES Schedule(lesson_id),
	CONSTRAINT	FK_HWResults_Groups			FOREIGN KEY ([group])	REFERENCES Groups(group_id),
	CONSTRAINT	FK_HWResults_Students		FOREIGN KEY (student)	REFERENCES Students(student_id),

);


CREATE TABLE Exams
(
	student		INT NOT NULL,
	discipline	SMALLINT NOT NULL,
	teacher		INT NOT NULL,
	grade		INT,

	PRIMARY KEY(student, discipline),
	CONSTRAINT		FK_Exams_Students		FOREIGN KEY (student)		REFERENCES Students(student_id),
	CONSTRAINT		FK_Exams_Disciplines	FOREIGN KEY (discipline)	REFERENCES Disciplines(discipline_id),
	CONSTRAINT		FK_Exams_Teachers		FOREIGN KEY (teacher)		REFERENCES Teachers(teacher_id)
);