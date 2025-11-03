-- Display DEPARTMENTS table
select * from departments;

-- Display FACULTY table
select * from FACULTY;

-- Display STUDENTS table
select * from STUDENTS;

-- Display COURSES table
select * from COURSES;

-- Display ENROLLMENTS table
select * from ENROLLMENTS;

--PHASE 1: BASIC QUERIES 

--List all Computer Science students
SELECT * FROM STUDENTS WHERE department_id like '%CS%';

--Find courses with capacity > 50
SELECT * FROM COURSES where max_capacity >50;

--Show faculty with Professor designation
SELECT * from FACULTY WHERE designation ='Professor';


--PHASE 2: JOIN OPERATIONS 

--Student enrollments with course names and grades
SELECT 
    s.student_id,
    s.name AS student_name,
    c.course_id,
    c.course_name,
    e.grade
FROM STUDENTS s
JOIN ENROLLMENTS e 
    ON s.student_id = e.student_id
JOIN COURSES c 
    ON e.course_id = c.course_id;

--Courses with faculty names and departments
SELECT f.faculty_id ,
f.name AS faculty_Name,
c.course_name,
c.department_id,
from FACULTY f 
left JOIN COURSES c on f.faculty_id = c.faculty_id;

--All students with their enrollment count
SELECT s.student_id ,
s.name AS student_name,
COUNT(e.enrollment_id ) AS enrollment_count
from STUDENTS s 
JOIN ENROLLMENTS e ON s.student_id   = e.student_id
GROUP BY s.student_id, s.name
order BY enrollment_count desc;


--PHASE 3: AGGREGATE QUERIES 

--Count students by department and gender
SELECT  s.gender  ,
d.department_id ,
s.name AS student_Name,
COUNT(s.student_id  ) AS student_count
FROM STUDENTS s 
JOIN DEPARTMENTS d ON s.department_id = d.department_id 
GROUP BY d.department_id, s.gender 
ORDER BY d.department_id desc;

--Average credits by department
SELECT 
    d.department_name,
    AVG(c.credits) AS average_credits
FROM COURSES c
JOIN DEPARTMENTS d 
    ON c.department_id = d.department_id
GROUP BY d.department_name
ORDER BY d.department_name;

--Courses with high enrollment (> 80% capacity)
SELECT 
    c.course_id,
    c.course_name,
    c.max_capacity ,
    COUNT(e.enrollment_id) AS enrolled_students,
    ROUND((COUNT(e.enrollment_id) * 100.0 / c.max_capacity ),2) AS occupancy_percent
FROM COURSES c
LEFT JOIN ENROLLMENTS e 
    ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity 
HAVING (COUNT(e.enrollment_id) * 100.0 / c.max_capacity ) > 80
ORDER BY occupancy_percent DESC;



PHASE 4: ANALYSIS & INSIGHTS 

--Grade distribution by department
SELECT 
    d.department_name,
    e.grade,
    COUNT(e.enrollment_id) AS student_count
FROM ENROLLMENTS e
JOIN COURSES c 
    ON e.course_id = c.course_id
JOIN DEPARTMENTS d 
    ON c.department_id = d.department_id
GROUP BY d.department_name, e.grade
ORDER BY d.department_name, e.grade;

--Faculty workload analysis
SELECT 
    f.faculty_id,
    f.name AS faculty_name,
    d.department_name,
    COUNT(c.course_id) AS total_courses_taught,
    IFNULL(SUM(c.credits), 0) AS total_credits_taught
FROM FACULTY f
LEFT JOIN COURSES c 
    ON f.faculty_id = c.faculty_id
LEFT JOIN DEPARTMENTS d 
    ON f.department = d.department_id
GROUP BY f.faculty_id, f.name, d.department_name
ORDER BY d.department_name, f.name  desc;

--Department performance summary
SELECT 
    d.department_id,
    d.department_name,
    COUNT(DISTINCT c.course_id) AS total_courses,
    COUNT(DISTINCT e.student_id) AS total_students,
    ROUND(AVG(e.grade), 2) AS avg_grade,
    ROUND(AVG(
        (SELECT COUNT(e2.enrollment_id) * 100.0 / c.max_capacity
         FROM ENROLLMENTS e2
         WHERE e2.course_id = c.course_id)
    ), 2) AS avg_occupancy_percent
FROM DEPARTMENTS d
LEFT JOIN COURSES c 
    ON d.department_id = c.department_id
LEFT JOIN ENROLLMENTS e 
    ON c.course_id = e.course_id
GROUP BY d.department_id, d.department_name
ORDER BY avg_grade DESC;










