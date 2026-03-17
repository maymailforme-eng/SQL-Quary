-- SQLQuery1 - SelectDisciplineFromSchedule

USE PV_522_Import;
GO

CREATE PROCEDURE sp_SelectDisciplineFromSchedule @discipline_name AS NVARCHAR(150)
AS
BEGIN
	DECLARE @dicipline AS SMALLINT = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE @discipline_name);

	SELECT 
			[Группа]	= group_name,
			[Дисциплина]	= discipline_name,
			[Препадователь]		= FORMATMESSAGE(N'%s %s %s', last_name, first_name, middle_name),
			[Дата] = [date],
			[День недели]	 = DATENAME(WEEKDAY, [date]),
			[Время] = [time],
			[Статус] = IIF(spent = 1, N'Проведено', N'Запланировано')

	FROM Schedule, Groups, Disciplines, Teachers
	WHERE	[group]		=	group_id
	AND		discipline	=	discipline_id
	AND		teacher		=	teacher_id
	AND		discipline	=	@dicipline;
END