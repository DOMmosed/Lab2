-- 1. Выбрать всех студентов старше 18 лет, обучающихся в платных группах.
SELECT s.*
FROM students s
JOIN groups g ON s.group_number = g.group_number
WHERE AGE(CURRENT_DATE, s.birth_date) >= INTERVAL '18 years'
  AND g.group_number LIKE '%Д';

-- 2. Выбрать телефонные номера всех студентов бюджетных групп 1 курса.
SELECT s.phone
FROM students s
JOIN groups g ON s.group_number = g.group_number
WHERE g.group_number NOT LIKE '%Д'
  AND g.group_number LIKE '%-1%';

-- 3. Создать таблицу, содержащую данные 1 запроса с указанием номеров телефонов и адресов.
DROP TABLE IF EXISTS selected_students;
SELECT s.student_id, s.last_name, s.first_name, s.middle_name, s.birth_date, s.address, s.phone, s.group_number
INTO selected_students
FROM students s
JOIN groups g ON s.group_number = g.group_number
WHERE AGE(CURRENT_DATE, s.birth_date) >= INTERVAL '18 years'
  AND g.group_number LIKE '%2';

-- 4. В созданную таблицу добавить студентов, у которых отсутствует номер телефона.
INSERT INTO selected_students (student_id, last_name, first_name, middle_name, birth_date, address, phone, group_number)
SELECT student_id, last_name, first_name, middle_name, birth_date, address, phone, group_number
FROM students
WHERE phone IS NULL OR TRIM(phone) = '';

-- 5. В созданной таблице для всех студентов не из Москвы, добавить к адресу «Московская область».
UPDATE selected_students
SET address = 'Московская область, ' || address
WHERE address NOT LIKE '%Москва%'
  AND address NOT LIKE '%Московская область%'
  AND address IS NOT NULL;

-- 6. Удалить из созданной таблицы записи все записи для студентов, у которых не указан адрес.
DELETE FROM selected_students
WHERE address IS NULL OR TRIM(address) = '';

-- 7. Посчитать количество студентов на каждом курсе.
SELECT 
    SUBSTRING(group_number FROM '-([0-9])') AS course, 
    COUNT(*) AS student_count
FROM students
GROUP BY SUBSTRING(group_number FROM '-([0-9])')
ORDER BY course;