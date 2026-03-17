--SQLQuery0-CHECK.sql
USE PV_522_Import;

SET DATEFIRST 1;


DELETE FROM Schedule --WHERE discipline = (SELECT discipline_id FROM Disciplines WHERE discipline_name=N'HTML/CSS')

--EXEC sp_InsertSchedule N'PV_522', N'%Win%C++', N'????', N'2025-12-09'
--EXEC sp_InsertSchedule N'PV_522', N'%Win%C#', N'????', N'2025-12-30'
--EXEC	sp_InsertSchedule N'PV_522', N'HTML/CSS', N'????', N'2026-06-02'
EXEC	sp_SelectSchedule;
--EXECUTE sp_SelectSchedule;

--EXEC	sp_SelectDisciplineFromSchedule N'%ADO.NET%'
