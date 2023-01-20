-- DAY 2023-01-19

-- 1. Selezionare tutti gli studenti nati nel 1990 
SELECT * FROM students 
WHERE date_of_birth BETWEEN 1990-01-01 
    AND 1991-01-01;

-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT * FROM courses 
WHERE cfu > 10;

-- 3. Selezionare tutti gli studenti che hanno più di 30 anni
SELECT * FROM students 
WHERE YEAR (CURDATE())-YEAR(date_of_birth) > 30;

-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT * FROM courses 
WHERE period LIKE 'I semestre' 
    AND year LIKE 1;

-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
SELECT * FROM exams
WHERE date >= '2020-06-20' 
    AND hour >= '14:00:00';

-- 6. Selezionare tutti i corsi di laurea magistrale (38)
SELECT * FROM `degrees`
WHERE name LIKE '%Magistrale%';

-- 7. Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(id) FROM departments;

-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT * FROM teachers 
WHERE phone IS null;

-- DAY 2023-01-20

-- 1. Contare quanti iscritti ci sono stati ogni anno
SELECT YEAR(enrolment_date) AS "Anno", COUNT(id) AS "iscrizioni_per_anno" FROM students
GROUP BY YEAR(enrolment_date);

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT teachers.office_address, COUNT(office_address) AS "numero_uffici_presidiati" FROM teachers
GROUP BY office_address;

-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT exam_id, AVG(vote) AS "media_voto" FROM exam_student
GROUP BY exam_id;

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT department_id,COUNT(department_id) FROM degrees
GROUP BY department_id;

-- Join
-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT * FROM students
    JOIN degrees
        ON students.id = degrees.department_id 
WHERE degrees.name LIKE "Corso di Laurea in Economia";

-- or More
SELECT students.id, students.degree_id, students.name, students.surname, students.fiscal_code, students.registration_number, degrees.id, degrees.name FROM students
    JOIN degrees
        ON students.id = degrees.department_id 
WHERE degrees.name LIKE "Corso di Laurea in Economia";

-- 2. Selezionare tutti i Corsi di Laurea Magistrale del Dipartimento di Neuroscienze
SELECT * FROM departments
    JOIN degrees
        ON departments.id = degrees.department_id
WHERE departments.name LIKE "Dipartimento di Neuroscienze" AND degrees.level LIKE "magistrale";

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT * FROM teachers
    JOIN course_teacher
        ON teachers.id = course_teacher.teacher_id
    JOIN courses
        ON course_teacher.course_id = courses.id
WHERE teachers.id = 44;

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT students.name, students.surname, degrees.name, degrees.level, departments.id, departments.name FROM students
    JOIN degrees
        ON students.id = degrees.department_id
    JOIN departments
        ON degrees.id = departments.id
ORDER BY students.name, students.surname;

-- DESC

SELECT students.name, students.surname, degrees.name, degrees.level, departments.id, departments.name FROM students
    JOIN degrees
        ON students.id = degrees.department_id
    JOIN departments
        ON degrees.id = departments.id
ORDER BY students.name DESC, students.surname DESC;

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT degrees.id, degrees.name, courses.id, courses.name, courses.period, teachers.id, teachers.name, teachers.surname, teachers.phone, teachers.email FROM degrees
    JOIN courses
        ON degrees.id = courses.degree_id
    JOIN course_teacher 
        ON courses.id = course_teacher.course_id
    JOIN teachers
        ON course_teacher.teacher_id = teachers.id;

-- General
SELECT * FROM degrees
    JOIN courses
        ON degrees.id = courses.degree_id
    JOIN course_teacher 
        ON courses.id = course_teacher.course_id
    JOIN teachers
        ON course_teacher.teacher_id = teachers.id;

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT departments.id, departments.name, teachers.id, teachers.name, teachers.surname FROM departments
    JOIN degrees
        ON departments.id = degrees.department_id
    JOIN courses
        ON degrees.id = courses.degree_id
    JOIN course_teacher
        ON courses.id = course_teacher.course_id
    JOIN teachers
        ON course_teacher.teacher_id = teachers.id
WHERE departments.name LIKE "Dipartimento di Matematica";

-- 7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per superare ciascuno dei suoi esami