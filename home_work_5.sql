CREATE DATABASE IF NOT EXISTS home_work_5;
USE home_work_5;

DROP TABLE IF EXISTS cars;
CREATE TABLE IF NOT EXISTS cars (
     id INT NOT NULL AUTO_INCREMENT,
     `name` VARCHAR(45),
     cost INT,
     PRIMARY KEY (ID)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/tmp/MOCK_DATA.csv' 
INTO TABLE cars 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT *
FROM cars;

-- 1. Создайте представление, в которое попадут автомобили стоимостью  до 25 000 долларов
DROP VIEW IF EXISTS lowcost;
CREATE VIEW lowcost AS
SELECT id, `name`, cost
FROM cars
WHERE cost < 25000;

SELECT *
FROM lowcost
ORDER BY cost; 

-- 2.	Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) 
ALTER VIEW lowcost AS
SELECT id, `name`, cost
FROM cars
WHERE cost < 30000;

SELECT *
FROM lowcost
ORDER BY cost; 

-- 3. 	Создайте представление, в котором будут только автомобили марки “ПОРШЕ” и “Ауди”
DROP VIEW IF EXISTS some_cars;
CREATE VIEW some_cars AS
SELECT *
FROM cars
WHERE `name`="Porsche" OR `name`="AUDI"
ORDER BY cost;

SELECT *
FROM some_cars;

/* 
4. Добавьте новый столбец под названием «время до следующей станции». Чтобы получить это значение, мы вычитаем время станций для пар смежных 
станций. Мы можем вычислить это значение без использования оконной функции SQL, но это может быть очень сложно. Проще это сделать с помощью 
оконной функции LEAD . Эта функция сравнивает значения из одной строки со следующей строкой, чтобы получить результат. В этом случае функция 
сравнивает значения в столбце «время» для станции со станцией сразу после нее. 
*/

CREATE TABLE IF NOT EXISTS train_schedule (
train_id INT NOT NULL,
station VARCHAR(45),
station_time TIMESTAMP
);

INSERT INTO train_schedule (train_id, station, station_time)
VALUES
     (110, "San Francisco", "10:00:00"),
     (110, "Redwood City", "10:54:00"),
     (110, "Palo Alto", "11:02:00"),
     (110, "San Jose", "12:35:00"),
     (120, "San Francisco", "11:00:00"),
     (120, "Palo Alto", "12:49:00"),
     (120, "San Jose", "13:30:00");
     
SELECT *
FROM train_schedule;     

DROP VIEW IF EXISTS train110;

CREATE VIEW train110 AS
SELECT train_id, 
        station, 
        station_time,
        SUBTIME((LEAD(station_time) OVER(ORDER BY station_time)), station_time) AS "time_interval"
FROM train_schedule
WHERE train_id=110;

SELECT *
FROM train110;

DROP VIEW IF EXISTS train120;

CREATE VIEW train120 AS
SELECT train_id, 
        station, 
        station_time,
        SUBTIME((LEAD(station_time) OVER(ORDER BY station_time)), station_time) AS "time_interval"
FROM train_schedule
WHERE train_id=120;

SELECT * 
FROM train110
WHERE time_interval > "00:00:00" OR time_interval IS NULL
UNION SELECT *
FROM train120
WHERE time_interval > "00:00:00" OR time_interval IS NULL;