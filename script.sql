
--“ак как в основной  базе 2 пол€ с кодом  цвета создадим 2 справочника дл€ корректной св€зи по внешнему ключу 
-- —оздаем справочник наименований цветов
CREATE TABLE IF NOT EXISTS dict_colors1
( id integer PRIMARY KEY AUTOINCREMENT,
  name_color varchar(20) UNIQUE NOT NULL
)

-- заполн€ем справочник уникальными данными
INSERT INTO dict_colors1 (name_color)
SELECT DISTINCT  lower(trim(color1))  
FROM animals
WHERE  color1 != "" 
ORDER BY lower(color1) 


CREATE TABLE IF NOT EXISTS dict_colors2
( id integer PRIMARY KEY AUTOINCREMENT,
  name_color varchar(20) UNIQUE NOT NULL
)

-- заполн€ем справочник уникальными данными
INSERT INTO dict_colors2 (name_color)
SELECT DISTINCT  lower(trim(color2))  
FROM animals
WHERE  color2 != "" 
ORDER BY lower(color2) 



-- —оздаем справочник наименований породы
CREATE TABLE IF NOT EXISTS dict_breeds
( id integer PRIMARY KEY AUTOINCREMENT,
  name_breed varchar(40) UNIQUE NOT NULL
)

-- заполн€ем справочник уникальными данными
INSERT INTO dict_breeds (name_breed)
SELECT DISTINCT lower(trim(breed))  
FROM animals
WHERE breed != ""
ORDER BY lower(breed) 


-- —оздаем справочник типов животных
CREATE TABLE IF NOT EXISTS dict_animal_types
( id integer PRIMARY KEY AUTOINCREMENT,
  name_type varchar(30) UNIQUE NOT NULL
)

-- заполн€ем справочник уникальными данными
INSERT INTO dict_animal_types (name_type)
SELECT DISTINCT lower(trim(animal_type))  
FROM animals
WHERE animal_type != ""
ORDER BY lower(animal_type)


-- —оздаем справочник наименований програм дл€ животных
CREATE TABLE IF NOT EXISTS dict_outcome_subtype
( id integer PRIMARY KEY AUTOINCREMENT,
  name_subtype varchar(30) UNIQUE NOT NULL
)

-- заполн€ем справочник уникальными данными
INSERT INTO dict_outcome_subtype (name_subtype)
SELECT DISTINCT lower(trim(outcome_subtype))  
FROM animals
WHERE outcome_subtype != ""
ORDER BY lower(outcome_subtype)


-- —оздаем справочник наименований состо€ни€ животных
CREATE TABLE IF NOT EXISTS dict_outcome_type
( id integer PRIMARY KEY AUTOINCREMENT,
  name_outcome_type varchar(30) UNIQUE NOT NULL
)

-- заполн€ем справочник уникальными данными
INSERT INTO dict_outcome_type (name_outcome_type)
SELECT DISTINCT lower(trim(outcome_type))  
FROM animals
WHERE outcome_type != ""
ORDER BY lower(outcome_type)


-- —оздаем справочник единиц измерени€ возраста животных
CREATE TABLE IF NOT EXISTS dict_age_measurement
( id integer PRIMARY KEY AUTOINCREMENT,
  name_measure varchar(10) UNIQUE NOT NULL
)

-- заполн€ем справочник уникальными данными
INSERT INTO dict_age_measurement (name_measure)
VALUES ('day(s)'), ('week(s)'), ('month(s)'), ('year(s)')  


-- —оздаем таблицу с количеством и типом периода
CREATE TABLE IF NOT EXISTS age_animals
(id integer PRIMARY KEY AUTOINCREMENT,
 age_value integer,
 age_measure_id integer,
 FOREIGN KEY (age_measure_id) REFERENCES dict_age_measurement(id)
)

INSERT INTO age_animals
SELECT animals."index", CAST (age_upon_outcome AS INTEGER), 
	CASE
	    WHEN instr(animals.age_upon_outcome, 'day') > 0
	    	THEN (SELECT id FROM dict_age_measurement WHERE name_measure LIKE '%day%') 
	    WHEN instr(animals.age_upon_outcome, 'week') > 0
	    	THEN (SELECT id FROM dict_age_measurement WHERE name_measure LIKE '%week%')
	    WHEN instr(animals.age_upon_outcome, 'month') > 0
	    	THEN (SELECT id FROM dict_age_measurement WHERE name_measure LIKE '%month%')
	    WHEN instr(animals.age_upon_outcome, 'year') > 0
	    	THEN (SELECT id FROM dict_age_measurement WHERE name_measure LIKE '%year%')
	    ELSE NULL 	
END as upon_outcome_id
FROM animals   


-- ѕроверка св€зи таблиц данных о возрасте животного 
SELECT age_animals.id , age_animals.age_value, dict_age_measurement.name_measure  FROM age_animals
LEFT JOIN dict_age_measurement ON age_animals.age_measure_id  = dict_age_measurement.id  


-- —оздаем основную таблицу
CREATE TABLE IF NOT EXISTS animals_normal
( id integer PRIMARY KEY AUTOINCREMENT,
  animal_id varchar(10) NOT NULL,
  animal_type text,
  animal_type_id integer,
  name varchar(20),
  breed_id integer,
  one_color text,
  two_color text,
  one_color_id integer,
  two_color_id integer,
  date_of_birth data,
  outcome_subtype text,
  outcome_subtype_id integer,
  outcome_type text,
  outcome_type_id integer,
  outcome_month integer,
  outcome_year integer,
  FOREIGN KEY (id) REFERENCES age_animals(id) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (breed_id) REFERENCES dict_breeds(id) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (one_color_id) REFERENCES dict_colors1(id) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (two_color_id) REFERENCES dict_colors2(id) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (animal_type_id) REFERENCES dict_animal_types(id) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (outcome_subtype_id) REFERENCES dict_outcome_subtype(id) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (outcome_type_id) REFERENCES dict_outcome_type(id) ON DELETE SET NULL ON UPDATE CASCADE
)

-- «аполн€ем нормализованную таблицу  данными из основной таблицы
INSERT INTO animals_normal (id, animal_id, name, date_of_birth, outcome_month, outcome_year, breed_id, one_color, two_color, animal_type, outcome_subtype, outcome_type)
SELECT animals."index", animal_id, name, date(date_of_birth), outcome_month, outcome_year, dict_breeds.id, animals.color1, animals.color2, animals.animal_type, animals.outcome_subtype, animals.outcome_type      
FROM animals, dict_breeds
WHERE animals.breed = dict_breeds.name_breed   

--ќбновление кода цвета 1
UPDATE animals_normal
SET one_color_id = (SELECT dict_colors1.id  FROM dict_colors1 WHERE lower(trim(animals_normal.one_color)) = lower(trim(dict_colors1.name_color)))
WHERE animals_normal.one_color_id IS NULL 

--ќбновление кода цвета 2
UPDATE animals_normal
SET two_color_id  = (SELECT dict_colors2.id  FROM dict_colors2 WHERE lower(trim(animals_normal.two_color)) = lower(trim(dict_colors2.name_color)))
WHERE animals_normal.two_color_id  IS NULL 

--ќбновление кода типа животного
UPDATE animals_normal
SET animal_type_id = (SELECT dict_animal_types.id  FROM dict_animal_types WHERE lower(trim(animals_normal.animal_type)) = lower(trim(dict_animal_types.name_type)))
WHERE animals_normal.animal_type_id  IS NULL 

--ќбновление кода программ дл€ животных
UPDATE animals_normal
SET outcome_subtype_id = (SELECT dict_outcome_subtype.id FROM dict_outcome_subtype WHERE lower(trim(animals_normal.outcome_subtype)) = lower(trim(dict_outcome_subtype.name_subtype)))
WHERE animals_normal.outcome_subtype_id  IS NULL 

--ќбновление кода состо€ни€ животных
UPDATE animals_normal
SET outcome_type_id = (SELECT dict_outcome_type.id FROM dict_outcome_type WHERE lower(trim(animals_normal.outcome_type)) = lower(trim(dict_outcome_type.name_outcome_type)))
WHERE animals_normal.outcome_type_id IS NULL 

--”дал€ем лишние пол€
ALTER TABLE animals_normal
DROP COLUMN one_color

ALTER TABLE animals_normal
DROP COLUMN two_color  

ALTER TABLE animals_normal
DROP COLUMN animal_type  

ALTER TABLE animals_normal
DROP COLUMN outcome_subtype  

ALTER TABLE animals_normal
DROP COLUMN outcome_type


-- ѕровер€ем количество записей обеих таблицах
SELECT count(animal_id)  
FROM animals

SELECT count(animal_id)  
FROM animals_normal



-- ¬ыборка из основной таблицы всех данных и по внешним ключам  
SELECT animals_normal.id, dict_animal_types.name_type,
animals_normal.name, dict_breeds.name_breed, dict_colors1.name_color  as color_1,
dict_colors2.name_color  as color_2,
dict_outcome_subtype.name_subtype,
dict_outcome_type.name_outcome_type,
animals_normal.date_of_birth, animals_normal.outcome_month, animals_normal.outcome_year,  
age_animals.age_value, dict_age_measurement.name_measure
FROM animals_normal
LEFT JOIN age_animals ON animals_normal.id = age_animals.id
LEFT JOIN dict_age_measurement ON age_animals.age_measure_id  = dict_age_measurement.id
LEFT JOIN dict_breeds ON animals_normal.breed_id  = dict_breeds.id
LEFT JOIN dict_animal_types ON animals_normal.animal_type_id  = dict_animal_types.id
LEFT JOIN dict_colors1 ON animals_normal.one_color_id = dict_colors1.id 
LEFT JOIN dict_colors2 ON animals_normal.two_color_id = dict_colors2.id
LEFT JOIN dict_outcome_subtype ON animals_normal.outcome_subtype_id  = dict_outcome_subtype.id
LEFT JOIN dict_outcome_type ON animals_normal.outcome_type_id = dict_outcome_type.id 

