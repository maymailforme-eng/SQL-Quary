-- SQLQuery2 - InsertLesson

USE PV_522_Import;
GO

CREATE PROCEDURE sp_InsertLesson 
			@group AS INT, 
			@discipline AS SMALLINT, 
			@teacher AS SMALLINT, 
			@date AS DATE, 
			@time AS TIME(0) OUTPUT, 
			@lesson_number AS TINYINT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [date] = @date AND [time] = @time)
		INSERT Schedule([group], discipline, teacher, [date], [time], spent)
		VALUES	(@group, @discipline, @teacher, @date, @time, IIF(@date < GETDATE(), 1,0));
	SET @time = DATEADD(MINUTE, 95, @time);
	SET @lesson_number += 1;
END
