-- SELECT Disceplines

USE PV_522_ALL_IN_ON;


-- ///////////////////////////////////////////////////////////////////////////
--  ДОБАВЛЕНИЕ ДАННЫХ В БД 

--INSERT INTO Directions VALUES (1, 'Разработчик ПО');


--INSERT INTO Groups VALUES (1, 'PV_522','2025-02-11', '18:30', 913,  1);


--INSERT INTO Disciplines VALUES	(1, 'Основы информационных технлогий', 24),
--									(2, 'Конфигурирование Windows 10', 32),
--									(3, 'Основы программирования на языке С++', 68),
--									(4, 'Объектно-ориентированное программирование на языке C++', 56),
--									(5, 'UML и паттерны проектирования', 18),
--									(6, 'Платформа Microsoft.NET и язык программирования C#', 34),
--									(7, 'Основы разработки приложений с использованием WindowsForms и WPF', 32),
--									(8, 'Теория баз данных. Программирование MS SQL Server', 24),
--									(9, 'Технолгия доступа к базам данных ADO.NET', 24);



--INSERT INTO Teachers VALUES	(1, 'Мясников', 'Александр', 'Анатольевич', NULL, NULL),
--								(2, 'Свищев',	'Алексей',	'Викторович', NULL, NULL),
--								(3, 'Нуптуллин', 'Арман', NULL, NULL, NULL),
--								(4, 'Ковтун', 'Олег', NULL, NULL, NULL);

								


-- ///////////////////////////////////////////////////////////////////////////
--  ДОБАВЛЕНИЕ ДАННЫХ В  Scheldue



SET DATEFIRST 1; -- первый день - понедельник


DECLARE @DisciplineId SMALLINT; -- защита от несквозной нумерации
SELECT @DisciplineId = MIN(discipline_id)
FROM Disciplines;

DECLARE @DisciplineName NVARCHAR (255);
DECLARE @StartDate DATE;
DECLARE @CurrentDate DATE;
DECLARE @EndDate DATE;
DECLARE @EndWin10Date DATE;
DECLARE @TotalHours TINYINT;
DECLARE @LessonHours TINYINT = 2;
DECLARE @SwitchWeek INT = 0;
DECLARE @LessonId INT = 1;

DECLARE @TimeBegin TIME(7);
DECLARE @TimeBeginFirst TIME(7) = '18:30';
DECLARE @TimeBeginSecond TIME(7) = '20:00';
DECLARE @Inserted BIT; -- флаг о добавлении занаятия



WHILE @DisciplineId IS NOT NULL -- проход по всем дисциплинам
BEGIN
	

	SELECT
		@DisciplineName = discipline_name, --сохраняем имя выбранно дисциплины 
		@TotalHours = number_of_lesson --сохраняем имя общее количество часов для данной дисциплины
	FROM Disciplines
	WHERE discipline_id = @DisciplineId;


	-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- ветка ОИТ
	IF @DisciplineName = N'Основы информационных технлогий' 
		BEGIN
				SET @StartDate = (SELECT [start_date] FROM Groups WHERE group_name = 'PV_522');
				SET @CurrentDate = @StartDate;
				SET @TimeBegin = @TimeBeginFirst;
				

				--главный цикл заполнения
				WHILE @TotalHours > 0
				BEGIN
					SET @Inserted = 0; -- зброс флага 
					
					-- на четной неделе
					IF @SwitchWeek = 0
						BEGIN 
							    IF DATEPART(WEEKDAY, @CurrentDate) IN (2) -- занятия по вторникам
								BEGIN
									INSERT INTO Schedule(lesson_id, discipline, [group], teacher, [date], [time], [subject], spent)
									VALUES 
									(
										@LessonId, @DisciplineId, 
										(SELECT group_id FROM Groups WHERE group_name = 'PV_522'),										
										(SELECT teacher_id FROM Teachers WHERE last_name = N'Свищев'),
										@CurrentDate, @TimeBegin, @DisciplineName, 1
									)
									SET @TotalHours = @TotalHours - @LessonHours;
									SET @LessonId = @LessonId + 1;
									SET @Inserted = 1;
								END;
						END;

					-- на нечетной неделе
					IF @SwitchWeek = 1
						BEGIN 
								IF DATEPART(WEEKDAY, @CurrentDate) IN (2, 4) -- занятия по вторникам и четвергам
								BEGIN
									INSERT INTO Schedule(lesson_id, discipline, [group], teacher, [date], [time], [subject], spent)
									VALUES 
									(
										@LessonId, @DisciplineId, 
										(SELECT group_id FROM Groups WHERE group_name = 'PV_522'),
										(SELECT teacher_id FROM Teachers WHERE last_name = N'Свищев'),
										@CurrentDate, @TimeBegin, @DisciplineName, 1
									)
									SET @TotalHours = @TotalHours - @LessonHours;
									SET @LessonId = @LessonId + 1;
									SET @Inserted = 1;
								END;
						END;
				


				IF @Inserted = 1
				BEGIN
					-- если проставили первую пару
					IF @TimeBegin = @TimeBeginFirst
					BEGIN
						SET @TimeBegin = @TimeBeginSecond; -- переключаем время на вторую пару
					END

					-- если уже проставили вторую пару
					ELSE
					BEGIN
						SET @TimeBegin = @TimeBeginFirst;

						SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate); -- переход к следующему дню 

							
						IF DATEPART(WEEKDAY, @CurrentDate) = 1 -- каждый понедельник переключаем неделю
						BEGIN
							SET @SwitchWeek = 1 - @SwitchWeek;
						END

					END
				END
				ELSE
				BEGIN
				    -- если занятия в этот день не было, просто идем к следующему дню
				    SET @TimeBegin = @TimeBeginFirst;
				    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);

				    IF DATEPART(WEEKDAY, @CurrentDate) = 1
				    BEGIN
				        SET @SwitchWeek = 1 - @SwitchWeek;
				    END
				END




			END;


		SET @EndDate = @CurrentDate;
	END;


	-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- ветка WIN 10
	IF @DisciplineName = N'Конфигурирование Windows 10' 
		BEGIN
			SET @CurrentDate = @EndDate; 
			SET @TimeBegin = @TimeBeginFirst;

				--главный цикл заполнения
				WHILE @TotalHours > 0
				BEGIN
					SET @Inserted = 0; -- зброс флага 
					-- на четной неделе
					IF @SwitchWeek = 0
					BEGIN 
						    IF DATEPART(WEEKDAY, @CurrentDate) IN (2) -- занятия по вторникам
							BEGIN
								INSERT INTO Schedule(lesson_id, discipline, [group], teacher, [date], [time], [subject], spent)
								VALUES 
								(
									@LessonId, @DisciplineId, 
									(SELECT group_id FROM Groups WHERE group_name = 'PV_522'),
									(SELECT teacher_id FROM Teachers WHERE last_name = N'Свищев'),
									@CurrentDate, @TimeBegin, @DisciplineName, 1
								)
								SET @TotalHours = @TotalHours - @LessonHours;
								SET @LessonId = @LessonId + 1;
								SET @Inserted = 1;
							END;
					END;

					-- на нечетной неделе
					IF @SwitchWeek = 1
						BEGIN 
								IF DATEPART(WEEKDAY, @CurrentDate) IN (2, 4) -- занятия по вторникам и четвергам
								BEGIN
									INSERT INTO Schedule(lesson_id, discipline, [group], teacher, [date], [time], [subject], spent)
									VALUES 
									(
										@LessonId, @DisciplineId, 
										(SELECT group_id FROM Groups WHERE group_name = 'PV_522'),
										(SELECT teacher_id FROM Teachers WHERE last_name = N'Свищев'),
										@CurrentDate, @TimeBegin, @DisciplineName, 1
									)
									SET @TotalHours = @TotalHours - @LessonHours;
									SET @LessonId = @LessonId + 1;
									SET @Inserted = 1;
								END


						END;


									
				IF @Inserted = 1
				BEGIN
					-- если проставили первую пару
					IF @TimeBegin = @TimeBeginFirst
					BEGIN
						SET @TimeBegin = @TimeBeginSecond; -- переключаем время на вторую пару
					END

					-- если уже проставили вторую пару
					ELSE
					BEGIN
						SET @TimeBegin = @TimeBeginFirst;

						SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate); -- переход к следующему дню 

							
						IF DATEPART(WEEKDAY, @CurrentDate) = 1 -- каждый понедельник переключаем неделю
						BEGIN
							SET @SwitchWeek = 1 - @SwitchWeek;
						END

					END
				END

				ELSE -- если занятия в этот день не было, просто идем к следующему дню
				BEGIN   
				    SET @TimeBegin = @TimeBeginFirst;
				    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);

				    IF DATEPART(WEEKDAY, @CurrentDate) = 1
				    BEGIN
				        SET @SwitchWeek = 1 - @SwitchWeek;
				    END
				END


			END;
		SET @EndWin10Date = @CurrentDate; -- сохраняем дату окончания WIN 10
	END;

	-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- ветка C++

		IF @DisciplineName = N'Основы программирования на языке С++' 
		BEGIN
				SET @StartDate = (SELECT [start_date] FROM Groups WHERE group_name = 'PV_522');
				SET @CurrentDate = @StartDate;
				SET @TimeBegin = @TimeBeginFirst;
				SET @SwitchWeek = 0;

				--главный цикл заполнения
				WHILE @TotalHours > 0
				BEGIN
					SET @Inserted = 0;
					

					IF @CurrentDate <= @EndWin10Date -- до окончания WIN 10
					BEGIN
					-- на четной неделе
						IF @SwitchWeek = 0
						BEGIN 
							    IF DATEPART(WEEKDAY, @CurrentDate) IN (4, 6) -- занятия по четвергам и субботам
								BEGIN
									INSERT INTO Schedule(lesson_id, discipline, [group], teacher, [date], [time], [subject], spent)
									VALUES 
									(
										@LessonId, @DisciplineId, 
										(SELECT group_id FROM Groups WHERE group_name = 'PV_522'),
										(SELECT teacher_id FROM Teachers WHERE last_name = N'Мясников'),
										@CurrentDate, @TimeBegin, @DisciplineName, 1
									)
									SET @TotalHours = @TotalHours - @LessonHours;
									SET @LessonId = @LessonId + 1;
									SET @Inserted = 1;
								END
						END

						-- на нечетной неделе
						IF @SwitchWeek = 1
						BEGIN 
								IF DATEPART(WEEKDAY, @CurrentDate) IN (6) -- занятия по субботам
								BEGIN
									INSERT INTO Schedule(lesson_id, discipline, [group], teacher, [date], [time], [subject], spent)
									VALUES 
									(
										@LessonId, @DisciplineId, 
										(SELECT group_id FROM Groups WHERE group_name = 'PV_522'),
										(SELECT teacher_id FROM Teachers WHERE last_name = N'Мясников'),
										@CurrentDate, @TimeBegin, @DisciplineName, 1
									)
									SET @TotalHours = @TotalHours - @LessonHours;
									SET @LessonId = @LessonId + 1;
									SET @Inserted = 1;

								END


						END
					END

					ELSE -- после окончания WIN 10
					BEGIN
						IF DATEPART(WEEKDAY, @CurrentDate) IN (2, 4, 6) -- занятия по четвергам и субботам
						BEGIN
							INSERT INTO Schedule(lesson_id, discipline, [group], teacher, [date], [time], [subject], spent)
							VALUES 
							(
								@LessonId, @DisciplineId,
								(SELECT group_id FROM Groups WHERE group_name = 'PV_522'),
								(SELECT teacher_id FROM Teachers WHERE last_name = N'Мясников'),
								@CurrentDate, @TimeBegin, @DisciplineName, 1
							)
							SET @TotalHours = @TotalHours - @LessonHours;
							SET @LessonId = @LessonId + 1;
							SET @Inserted = 1;
						END
					END;

					


									
				IF @Inserted = 1
				BEGIN
					-- если проставили первую пару
					IF @TimeBegin = @TimeBeginFirst
					BEGIN
						SET @TimeBegin = @TimeBeginSecond; -- переключаем время на вторую пару
					END

					-- если уже проставили вторую пару
					ELSE
					BEGIN
						SET @TimeBegin = @TimeBeginFirst;

						SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate); -- переход к следующему дню 

							
						IF DATEPART(WEEKDAY, @CurrentDate) = 1 -- каждый понедельник переключаем неделю
						BEGIN
							SET @SwitchWeek = 1 - @SwitchWeek;
						END

					END
				END

				ELSE -- если занятия в этот день не было, просто идем к следующему дню
				BEGIN   
				    SET @TimeBegin = @TimeBeginFirst;
				    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);

				    IF DATEPART(WEEKDAY, @CurrentDate) = 1
				    BEGIN
				        SET @SwitchWeek = 1 - @SwitchWeek;
				    END
				END

			END;
		SET @EndDate = @CurrentDate; -- дата окончания курса
	END;


-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ветка Объектно-ориентированное программирование на языке C++

		IF @DisciplineName = N'Объектно-ориентированное программирование на языке C++' 
		BEGIN
			SET @CurrentDate = @EndDate;
			SET @TimeBegin = @TimeBeginFirst;

			--главный цикл заполнения
			WHILE @TotalHours > 0
			BEGIN
				SET @Inserted = 0;

				IF DATEPART(WEEKDAY, @CurrentDate) IN (2, 4, 6) -- занятия по вторникам четвергам и субботам
				BEGIN
					INSERT INTO Schedule(lesson_id, discipline, [group], teacher, [date], [time], [subject], spent)
					VALUES 
					(
						@LessonId, @DisciplineId, 
						(SELECT group_id FROM Groups WHERE group_name = 'PV_522'),
						(SELECT teacher_id FROM Teachers WHERE last_name = N'Мясников'),
						@CurrentDate, @TimeBegin, @DisciplineName, 1
					)
					SET @TotalHours = @TotalHours - @LessonHours;
					SET @LessonId = @LessonId + 1;
				END;



				IF @Inserted = 1
				BEGIN
					-- если проставили первую пару
					IF @TimeBegin = @TimeBeginFirst
					BEGIN
						SET @TimeBegin = @TimeBeginSecond; -- переключаем время на вторую пару
					END

					-- если уже проставили вторую пару
					ELSE
					BEGIN
						SET @TimeBegin = @TimeBeginFirst;

						SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate); -- переход к следующему дню 
					END
				END

				ELSE -- если занятия в этот день не было, просто идем к следующему дню
				BEGIN   
				    SET @TimeBegin = @TimeBeginFirst;
				    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
				END
			
			END;
			SET @EndDate = @CurrentDate; -- дата окончания курса

		END;

	
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- UML и паттерны проектирования
		IF @DisciplineName = N'UML и паттерны проектирования' 
		BEGIN
			SET @CurrentDate = @EndDate;
			SET @TimeBegin = @TimeBeginFirst;

			--главный цикл заполнения
			WHILE @TotalHours > 0
			BEGIN
				SET @Inserted = 0;

				IF DATEPART(WEEKDAY, @CurrentDate) IN (2, 4, 6) -- занятия по вторникам четвергам и субботам
				BEGIN
					INSERT INTO Schedule(lesson_id, discipline, [group], teacher, [date], [time], [subject], spent)
					VALUES 
					(
						@LessonId, @DisciplineId, 
						(SELECT group_id FROM Groups WHERE group_name = 'PV_522'),
						(SELECT teacher_id FROM Teachers WHERE last_name = N'Мясников'),
						@CurrentDate, '18:30', @DisciplineName, 1
					)
					SET @TotalHours = @TotalHours - @LessonHours;
					SET @LessonId = @LessonId + 1;
					SET @Inserted = 1;
				END;
			


				IF @Inserted = 1
				BEGIN
					-- если проставили первую пару
					IF @TimeBegin = @TimeBeginFirst
					BEGIN
						SET @TimeBegin = @TimeBeginSecond; -- переключаем время на вторую пару
					END

					-- если уже проставили вторую пару
					ELSE
					BEGIN
						SET @TimeBegin = @TimeBeginFirst;

						SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate); -- переход к следующему дню 
					END
				END

				ELSE -- если занятия в этот день не было, просто идем к следующему дню
				BEGIN   
				    SET @TimeBegin = @TimeBeginFirst;
				    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
				END
				

			
		END;

		SET @EndDate = @CurrentDate; -- дата окончания курса
	END;


-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Платформа Microsoft.NET и язык программирования C#

		IF @DisciplineName = N'Платформа Microsoft.NET и язык программирования C#' 
		BEGIN
			SET @CurrentDate = @EndDate;
			SET @TimeBegin = @TimeBeginFirst;

			--главный цикл заполнения
			WHILE @TotalHours > 0
			BEGIN
				SET @Inserted = 0;

				IF DATEPART(WEEKDAY, @CurrentDate) IN (2, 4, 6) -- занятия по вторникам четвергам и субботам
				BEGIN
					INSERT INTO Schedule(lesson_id, discipline, [group], teacher, [date], [time], [subject], spent)
					VALUES 
					(
						@LessonId, @DisciplineId, 
						(SELECT group_id FROM Groups WHERE group_name = 'PV_522'),
						(SELECT teacher_id FROM Teachers WHERE last_name = N'Нуптуллин'),
						@CurrentDate, '18:30', @DisciplineName, 1
					)
					SET @TotalHours = @TotalHours - @LessonHours;
					SET @LessonId = @LessonId + 1;
					SET @Inserted = 1;
				END;
			
				IF @Inserted = 1
				BEGIN
					-- если проставили первую пару
					IF @TimeBegin = @TimeBeginFirst
					BEGIN
						SET @TimeBegin = @TimeBeginSecond; -- переключаем время на вторую пару
					END

					-- если уже проставили вторую пару
					ELSE
					BEGIN
						SET @TimeBegin = @TimeBeginFirst;

						SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate); -- переход к следующему дню 
					END
				END

				ELSE -- если занятия в этот день не было, просто идем к следующему дню
				BEGIN   
				    SET @TimeBegin = @TimeBeginFirst;
				    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
				END

			
			END;
		SET @EndDate = @CurrentDate; -- дата окончания курса
	END;


-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ВСЕ ОСТАВШИЕСЯ ДИСЦИПЛИНЫ ПОСЛЕ С#



IF @DisciplineName IN
(
    N'Основы разработки приложений с использованием WindowsForms и WPF',
    N'Теория баз данных. Программирование MS SQL Server',
    N'Технолгия доступа к базам данных ADO.NET'
)
BEGIN

	SET @CurrentDate = @EndDate;
	SET @TimeBegin = @TimeBeginFirst;
		--главный цикл заполнения
		WHILE @TotalHours > 0
		BEGIN
			SET @Inserted = 0;

			IF DATEPART(WEEKDAY, @CurrentDate) IN (2, 4, 6) -- занятия по вторникам четвергам и субботам
			BEGIN
				INSERT INTO Schedule(lesson_id, discipline, [group], teacher, [date], [time], [subject], spent)
				VALUES 
				(
					@LessonId, @DisciplineId, 
					(SELECT group_id FROM Groups WHERE group_name = 'PV_522'),
					(SELECT teacher_id FROM Teachers WHERE last_name = N'Ковтун'),
					@CurrentDate, '18:30', @DisciplineName, 1
				)
				SET @TotalHours = @TotalHours - @LessonHours;
				SET @LessonId = @LessonId + 1;
				SET @Inserted = 1;
			END;
		

			IF @Inserted = 1
			BEGIN
				IF @TimeBegin = @TimeBeginFirst -- если проставили первую пару
				BEGIN
					SET @TimeBegin = @TimeBeginSecond; -- переключаем время на вторую пару
				END

				-- если уже проставили вторую пару
				ELSE
				BEGIN
					SET @TimeBegin = @TimeBeginFirst;

					SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate); -- переход к следующему дню 
				END
			END

			ELSE -- если занятия в этот день не было, просто идем к следующему дню
			BEGIN   
			    SET @TimeBegin = @TimeBeginFirst;
			    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
			END

		
		END;
	SET @EndDate = @CurrentDate; -- дата окончания курса
END;












	SELECT @DisciplineId = MIN(discipline_id) -- переходим к следующей дисциплине c защитой от пропусков номеров
	FROM Disciplines
	WHERE discipline_id > @DisciplineId;




	

END;


-- ///////////////////////////////////////////////////////////////////////////
--Для выбранного преподавателя вывести все дисциплины, которые он может вести;




-- ///////////////////////////////////////////////////////////////////////////
-- Для выбранной дисциплины выбрать всех преподавателей, которые могут ее вести;



-- ///////////////////////////////////////////////////////////////////////////
--*Для выбранного преподавателя подсчитать количество дисциплин, которые он может вести;
;

-- ///////////////////////////////////////////////////////////////////////////
--*Для выбранной дисциплины подсчитать количество преподвателей, которые могут ее вести;
