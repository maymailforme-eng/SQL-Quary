
--SQLQuery-HW-CHECK.sql

USE PV_522_Import;
SET LANGUAGE Russian;
SET DATEFIRST 1;

--DELETE FROM Schedule --WHERE discipline = (SELECT discipline_id FROM Disciplines WHERE discipline_name=N'HTML/CSS')

DELETE FROM Schedule;

EXEC sp_InsertSchedule N'PV_522', N'Процедурное программирование на языке C++', N'Ковтун', N'2025-02-13', 1, 2
EXEC sp_InsertSchedule N'PV_522', N'Администрирование Windows', N'Ковтун', N'2025-02-11', 0, 1;


EXEC	sp_SelectSchedule;


