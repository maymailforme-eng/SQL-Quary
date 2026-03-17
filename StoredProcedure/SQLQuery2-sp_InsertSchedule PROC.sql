--SQLQuery2-sp_InsertSchedule PROC.sql
USE PV_522_Import;
SET DATEFIRST 1;
GO

ALTER PROCEDURE sp_InsertSchedule
		@group_name					AS	NCHAR(10),
		@discipline_name			AS	NVARCHAR(150),
		@teacher_name				AS	NVARCHAR(50),
		@start_date					AS	DATE
AS
BEGIN
		DECLARE @group				AS	INT		=	(SELECT group_id			FROM Groups			WHERE group_name=@group_name);
		DECLARE @discipline			AS	SMALLINT=	(SELECT discipline_id		FROM Disciplines	WHERE discipline_name LIKE @discipline_name);
		DECLARE @number_of_lessons	AS	TINYINT	=	(SELECT number_of_lessons	FROM Disciplines	WHERE discipline_name LIKE @discipline_name);
		DECLARE @lesson_number		AS	TINYINT	=	0;	
		DECLARE @teacher			AS	SMALLINT=	(SELECT teacher_id			FROM Teachers		WHERE first_name LIKE @teacher_name OR last_name LIKE @teacher_name);
		DECLARE @start_time			AS	TIME(0)	=	(SELECT start_time FROM Groups WHERE group_id = @group);
		DECLARE @date				AS	DATE	=	@start_date;
		DECLARE @time				AS	TIME(0)	=	@start_time;
		
		PRINT @group;
		PRINT @discipline;
		PRINT @number_of_lessons;
		PRINT @teacher;
		PRINT @start_date;
		PRINT @start_time;
		PRINT N'===============================================================';
		
		WHILE @lesson_number < @number_of_lessons
		BEGIN
			SET @time = @start_time;
			
			PRINT FORMATMESSAGE(N'%i, %s %s %s', @lesson_number, CAST(@date AS NVARCHAR(12)), DATENAME(WEEKDAY, @date), CAST(@time AS NVARCHAR(12)));
			EXEC sp_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lesson_number OUTPUT;
			
			PRINT FORMATMESSAGE(N'%i, %s %s %s', @lesson_number, CAST(@date AS NVARCHAR(12)), DATENAME(WEEKDAY, @date), CAST(@time AS NVARCHAR(12)));
			EXEC sp_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lesson_number OUTPUT;
		
			SET @date = DATEADD(DAY, IIF(DATEPART(WEEKDAY, @date)=6, 3 , 2), @date);
		END
END