CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);
INSERT INTO departments (department_name)
VALUES
('HR'),
('IT'),
('Finance'),
('Marketing'),
('Sales');
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100),
    gender VARCHAR(25),
    salary NUMERIC(10,2),
    hire_date DATE,
    department_id INTEGER REFERENCES departments(department_id)
);
INSERT INTO employees
(employee_name, gender, salary, hire_date, department_id)
VALUES
('Anu', 'Female', 35000, '2022-01-15', 1),
('Rahul', 'Male', 45000, '2021-05-10', 2),
('Aisha', 'Female', 30000, '2023-03-20', 1),
('Adil', 'Male', 55000, '2020-07-12', 3),
('Sara', 'Female', 40000, '2022-09-05', 4),
('Arjun', 'Male', 60000, '2019-02-18', 2),
('Meera', 'Female', 28000, '2024-01-10', 5),
('Fathima', 'Female', 50000, '2021-11-25', 3),
('Nikhil', 'Male', 32000, '2023-06-14', 4),
('Diya', 'Female', 42000, '2022-12-01', 5);
CREATE TABLE attendance (
    attendance_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(employee_id),
    attendance_date DATE,
    status VARCHAR(20) CHECK (
        status IN ('Present', 'Absent', 'Leave')
    )
);
INSERT INTO attendance
(employee_id, attendance_date, status)
VALUES
(1, '2026-11-01', 'Present'),
(1, '2026-11-02', 'Present'),
(1, '2026-11-03', 'Absent'),
(2, '2026-11-01', 'Present'),
(2, '2026-11-02', 'Absent'),
(2, '2026-11-03', 'Present'),
(3, '2026-11-01', 'Leave'),
(3, '2026-11-02', 'Present'),
(4, '2026-11-01', 'Present'),
(4, '2026-11-02', 'Present');
CREATE TABLE performance (
    performance_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(employee_id),
    review_date DATE,
    rating INTEGER CHECK (rating IN (1, 2, 3, 4, 5))
);
INSERT INTO attendance
(employee_id, attendance_date, status)
VALUES
(1, '2026-11-01', 'Present'),
(1, '2026-11-02', 'Present'),
(1, '2026-11-03', 'Absent'),
(2, '2026-11-01', 'Present'),
(2, '2026-11-02', 'Absent'),
(2, '2026-11-03', 'Present'),
(3, '2026-11-01', 'Leave'),
(3, '2026-11-02', 'Present'),
(4, '2026-11-01', 'Present'),
(4, '2026-11-02', 'Present');


-- Question 1: Total number of employees
SELECT COUNT(*) AS total_employees
FROM employees;


-- Question 2: Employee count by department
SELECT department_name, COUNT(E.employee_name) AS emp_count
FROM departments AS D
INNER JOIN employees AS E
ON D.department_id = E.department_id
GROUP BY D.department_name;


-- Question 3: Average salary by department
SELECT D.department_name, AVG(E.salary) AS avg_salary
FROM departments AS D
INNER JOIN employees AS E
ON D.department_id = E.department_id
GROUP BY D.department_name;


-- Question 4: Highest-paid employee
SELECT employee_name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);


-- Question 5: Lowest-paid employee
SELECT employee_name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);


-- Question 6: Total salary expenditure
SELECT SUM(salary) AS total_salary
FROM employees;


-- Question 7: Employee count by gender
SELECT COUNT(employee_name) AS count_emp_by_gender, gender
FROM employees
GROUP BY gender;


-- Question 8: Employees hired by year
SELECT COUNT(employee_name) AS join_date_count,
EXTRACT(YEAR FROM hire_date) AS join_year
FROM employees
GROUP BY join_year
ORDER BY join_year ASC;


-- Question 9: Employees earning above average salary
SELECT employee_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);


-- Question 10: Employees hired after 1 January 2023
SELECT employee_name, hire_date
FROM employees
WHERE hire_date > '2023-01-01';


-- Question 11: Employees with more than 5 years of experience
SELECT employee_name,
AGE(CURRENT_DATE, hire_date) AS experience
FROM employees
WHERE AGE(CURRENT_DATE, hire_date) > INTERVAL '5 years';

--Question 12:Departments with average salary above company average
WITH department_avg_table as (
	SELECT 
		department_id,
		AVG(salary) as department_average
	from employees
	GROUP BY department_id
)
Select d.department_name
from departments as d
INNER JOIN department_avg_table as e on e.department_id = d.department_id
WHERE e.department_average > (SELECT avg(salary) from employees);

--Question 13: Average performance rating by department
SELECT D.department_name,AVG(P.rating) FROM departments AS D
INNER JOIN employees AS E ON D.department_id=E.department_id
INNER JOIN performance AS P ON E.employee_id =P.employee_id GROUP BY D.department_id;

--Question 14: Department with the highest salary expenditure
SELECT D.department_name,SUM(E.salary) AS total_salary FROM departments AS D
INNER JOIN employees AS E ON D.department_id=E.department_id
GROUP BY department_name ORDER BY  total_salary DESC LIMIT 1;

--Question 15: Salary classification
SELECT employee_name,salary,
CASE 
WHEN salary >50000 THEN 'High Salary'
WHEN salary >35000 THEN 'Medium Salary'
ELSE  'Low Salary'
end AS SALARY_CATAGORY from employees ;


---- VIEWS
--View 1: Employee Department View
CREATE VIEW employee_department_view AS
SELECT departments.department_name,  employees.employee_name ,employees.gender , employees.salary ,employees.hire_date
FROM departments  INNER JOIN employees ON departments.department_id = employees.department_id ;

SELECT * FROM employee_department_view;

---View 2 – Department Salary Analysis
CREATE VIEW department_salary_view AS
SELECT D.department_name,COUNT(E.employee_name)AS Employee_Count,	AVG(E.salary) AS Average_Salary	, SUM(E.salary)AS Total_Salary
FROM departments AS D INNER JOIN employees AS E ON D.department_id=E.department_id
GROUP BY department_name;

SELECT * FROM department_salary_view;
 



