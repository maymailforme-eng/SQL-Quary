-- SQLQuery - HW - InsertLesson

--ДОБАВИТ ЗАНЯТИЕ если оно еще не добавлено в базу (уникальное)

USE PV_522_Import;
GO

ALTER PROCEDURE sp_InsertLesson 
			@group				AS INT, 
			@discipline			AS SMALLINT, 
			@teacher			AS SMALLINT, 
			@date				AS DATE, 
			@time				AS TIME(0) OUTPUT, 
			@lesson_number		AS TINYINT OUTPUT,
			@switch_week		AS BIT,
			@alteration_mode	AS INT
AS
BEGIN
	IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [date] = @date AND [time] = @time)
	
	AND @date NOT IN
	(	-- даты из нашего расписания; Неподходят для других групп 
		'2025-02-22',	'2025-03-08',	'2025-05-01',	'2025-05-03',
		'2025-05-06',	'2025-05-08',	'2025-06-12',	'2025-07-08',
		'2025-07-10',	'2025-07-12',	'2025-09-02',	'2025-09-04',
		'2025-09-06',	'2025-09-09',	'2025-09-11',	'2025-09-13',
		'2025-11-04',	'2026-01-01',	'2026-01-03',	'2026-01-06',
		'2026-01-08',	'2026-05-02',	'2026-05-05',	'2026-05-07',
		'2026-05-09',	'2026-06-07',	'2026-06-09',	'2026-06-11'
	)

	BEGIN

		IF (@alteration_mode = 1 
		AND(
				(@switch_week = 0 AND DATEPART(WEEKDAY, @date) IN (1,2))
				OR
				(@switch_week = 1 AND DATEPART(WEEKDAY, @date) IN (1,2,3,4))
			))
		OR

		(@alteration_mode = 2
		AND(
				(@switch_week = 0 AND DATEPART(WEEKDAY, @date) IN (5,6))
				OR
				(@switch_week = 1 AND DATEPART(WEEKDAY, @date) IN (3,4,5,6))
			))
		BEGIN
			INSERT Schedule([group], discipline, teacher, [date], [time], spent)
			VALUES	(@group, @discipline, @teacher, @date, @time, IIF(@date < GETDATE(), 1,0));
			SET @time = DATEADD(MINUTE, 95, @time);
			SET @lesson_number += 1;
		END
		
		ELSE IF @alteration_mode = 0 -- в других случаях когда мод не 1 и 2
		BEGIN
			INSERT Schedule([group], discipline, teacher, [date], [time], spent)
			VALUES	(@group, @discipline, @teacher, @date, @time, IIF(@date < GETDATE(), 1,0));
			SET @time = DATEADD(MINUTE, 95, @time);
			SET @lesson_number += 1;
		END
	END
END
