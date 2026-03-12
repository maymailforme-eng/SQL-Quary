
USE PV_522_DDL;

CREATE TABLE Students
(
	student_id INT PRIMARY KEY,
	last_name NVARCHAR(50) NOT NULL,
	first_name NVARCHAR(50) NOT NULL,
	middle_name NVARCHAR(50),
	birth_day DATE,
	[group] INT NOT NULL
	CONSTRAINT	FK_Students_Groups FOREIGN KEY REFERENCES Groups(group_id)
);

CREATE TABLE Teachers
(
	teacher_id INT PRIMARY KEY,
	last_name NVARCHAR(50) NOT NULL,
	first_name NVARCHAR(50) NOT NULL,
	middle_name NVARCHAR(50),
	birth_day DATE,
	rate INT
);

--SELECT TABLE_NAME
--FROM PV_522_DDL.INFORMATION_SCHEMA.TABLES
--WHERE TABLE_TYPE = 'BASE TABLE';