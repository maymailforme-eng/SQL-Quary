

USE PV_522_Import;

--SELECT 
--	direction_name AS N'Направление обучения',
--	COUNT(group_id) AS N'Количество групп'
--FROM Groups, Directions
--WHERE direction = direction_id
--GROUP BY direction_name
--ORDER BY N'Количество групп' DESC
--;

INSERT INTO Groups VALUES (11, 'PV_522', 1);

SELECT * FROM Groups; 