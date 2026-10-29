/*
 <JOIN>
 두 개 이상의 테이블에서 데이터를 조회하고자 할 떄 사용하는 구문
 조회결과는 하나의 결과물(RESULT SET)로 나옴
 
 - 관계형 데이터베이스는 최소한의 데이터로 각각 테이블에 담고 있어야 함.
   (중복제거를 위해)
 => 관계형 데이터베이스에서 SQL문을 이용하여 테이블 간의 '관계'를 맺는 방법
 
 				[JOIN 용어정리]
 1. 내부조인(INNER JOIN) => JOIN ON / JOIN USING
 	자연조인(NATURAL JOIN) => 동일한 컬럼을 자동 조인
 2. 외부조인(OUTER JOIN)
 		- 왼쪽 외부 조인(LEFT OUTER JOIN / LEFT JOIN)
 		- 오른쪽 외부 조인(RIGHT OUTER JOIN / RIGHT JOIN)
 		- 전체 외부 조인(FULL OUTER JOIN / FULL JOIN)
 3. 비등가 조인(NON-EQUAL JOIN) => JOIN ON(동등 '=' 비교가 아닌 조인)
 4. 자체 조인(SELF JOIN)       => JOIN ON(같은 테이블끼리 조인)
 5. 교차 조인(CROSS JOIN)      => 모든 경우의 수 / 카테시안 곱
*/

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회하고자 한다.
select emp_id, emp_name, dept_code
from employee;

select dept_id, dept_title
from department;

--========================================================================================================================
/*
 1. 등가조인(EQUAL JOIN) / 내부 조인(INNER JOIN)
    연결시키는 컬럼의 값이 "일치하는 행들만" 조인이 되어 조회
*/
---------------------------------------------------------------------------------------------------------------------------
-- 1) 연결할 두 컬럼명이 다른 경우()
--    => 오직 JOIN ON 구문만 사용 가능
--  EMPLOYEE: DEPT_CODE / DEPARTMENT: DEPT_ID
select  emp_id, emp_name, dept_code, dept_title
from employee, department;
-- DEPARTMENT 행당 23명씩 TOTAL 207행이 나옴

select emp_id, emp_name, dept_code, dept_title
from employee
join department on (dept_code = dept_id);

---------------------------------------------------------------------------------------------------------------------------
-- 2) 연결할 두 컬럼명이 같은 경우()
--    JOIN ON 또는 JOIN USING 구문 사용 가능
-- EMPLOYEE: JOB_CODE / JOB: JOB_CODE
select emp_id, emp_name, job_code, job_name
from employee
join job on(job_code = job_code);  -- 오류 발생
-- JOB_CODE가 어느 테이블의 JOB_CODE인지 알지 못해서

-- 해결방법 1) JOIN ON + 테이블을 명시(별칭도 가능)
select emp_id, emp_name, employee.job_code, job_name
from employee
join job on(employee.job_code = job.job_code);

select emp_id, emp_name, e.job_code, job_name
from employee e
join job j on(e.job_code = j.job_code);

-- 해결방법 2) JOIN USING사용(컬럼명이 같을 때만 사용 가능)
select emp_id, emp_name, job_code, job_name
from employee
join job using(job_code);

------------------------------------------------------------------------------------------------------------------------
-- 3) NATURAL JOIN
-- 두 테이블에서 이름 같은 컬럼 자동으로 찾아서 매칭해줌
select emp_id, emp_name, job_code, job_name
from employee
natural join job;

------------------------------------------------------------------------------------------------------------------------
-- 4) 조인과 함께 조건 제시
-- 직급이 대리인 사원의 사번, 이름, 직급명, 급여를 조회

-- JOIN ON 사용
select emp_id, emp_name, job_name, salary
from employee e
join job j on(e.job_code = j.job_code)
where j.job_name = '대리';

-- JOIN USING
select emp_id, emp_name, job_name, salary
from employee
join job using(job_code)
where job_name = '대리';

----------------------------- 연습 문제 -------------------------------------
-- 1. 부서가 인사관리부인 사원들의 사번, 사원명, 부서명, 보너스 조회
select e.emp_id,
		e.emp_name,
		d.dept_title,
		e.bonus
from employee e
join department d on e.dept_code = d.dept_id
where d.dept_title = '인사관리부';
-- 2. department와 location테이블을 참조하여 부서코드, 부서명, 지역코드, 지역명 조회
select d.dept_id 부서코드, 
       d.dept_title 부서명, 
       l.local_code 지역코드, 
       l.local_name 지역명
from department d, location l
where d.location_id = l.local_code;
-- 3. 보너스를 받은 사원들의 사번, 사원명, 보너스, 부서명 조회
select e.emp_id,
		e.emp_name,
		e.bonus,
		d.dept_title
from employee e
join department d ON e.dept_code = d.dept_id
where e.bonus is not null;
-- 4. 부서 총무부가 아닌 사원들의 사원명, 급여, 부서명 조회
select e.emp_name,
		e.salary,
		d.dept_title
from employee e
join department d on  e.dept_code = d.dept_id
where d.dept_title != '총무부';

--------------------------------------------------------------------------
/*
 2. 외부 조인 / 포괄 조인
   두 테이블간의 join시 일치하지 않는 행도 포함시켜 조회
   단, 어느 테이블을 기준으로 할지 left / right / full 중 하나를 지정
*/

-- 사원명, 부서명, 급여, 연봉
select emp_name, dept_title, salary, salary*12 연봉
from employee
join department on (dept_code = dept_id)
order by 2;
-- 부서배치가 안된 사원 정보 x
-- 부서에 배정된 사원 없는 부서도 조회 x

-- 1) left [outer] join
select emp_name, dept_code, dept_title, salary, salary*12 연봉
from employee
left join department on (dept_code = dept_id);

-- 2) right [outer] join
select emp_name, dept_code, dept_title, salary, salary*12 연봉
from employee
right join department on (dept_code =dept_id);

-- 3) full [outer] join
select emp_name, dept_code, dept_title, salary, salary*12 연봉
from employee
full join department on (dept_code = dept_id);

--============================================================================
/*
 3. 비등가 조인
    매칭 시킬 컬럼의 조건을 작성 시 '='을 사용하지 않는 join문
    => join on으로만 가능
*/

-- sal_grade 테이블 조인(sal_level컬럼)
select emp_name, salary
from employee;

-- 사원명, 급여, 급여레벨 조회
select emp_name, salary, sal_level
from employee
join sal_grade on(salary >= min_sal and salary <= max_sal);

select emp_name, salary, sal_level
from employee
join sal_grade on(salary between min_sal and max_sal);

--===============================================================================
/*
 4. 자체 조인
   같은 테이블을 다시 조회
*/
-- 사수가 있는 사원만 조회
select emp_id, emp_name, manager_id
from employee
where manager_id is not null;

-- 사수가 있는 사원의 사번, 이름, 부서코드와 사수의 사번, 이름, 부서코드 조회
select e.emp_id, e.emp_name, e.dept_code, m.emp_id, m.emp_name, m.dept_code
from employee e, employee m
where e.manager_id = m.emp_id;

-- > 전체 사원(정보는 위와 같음)의 사수 조회
select e.emp_id, e.emp_name,e.dept_code, m.emp_id 사수사번, m.emp_name 사수이름, m.dept_code 사수부서코드 
from employee e
left join employee m on (e.manager_id =m.emp_id);

--======================================================================================
/*
 <다중 join>
   2개 이상의 테이블을 가지고 join할 때
*/
-- employee테이블의 전 사원들의 사번, 사원명, 부서명, 직급명 조회

-- 서로 매칭
/*
  employee		dept_code		job_code
  department	dept_id
  job							job_code
 */

select emp_id, emp_name, dept_title, job_name
from employee
left join department on (dept_code=dept_id)
join job using(job_code);

-- 사번, 사원명, 부서명, 지역명 조회
/*
 employee		dept_code
 department		dept_id		location_id
 location					local_code
*/
-- 21 명 조회
select emp_id, emp_name, dept_title, local_name
from employee
join department on(dept_code=dept_id)
join location on(location_id =local_code);

--
select emp_id, emp_name, dept_title, local_name
from employee
left join department on(dept_code=dept_id)
left join location on(location_id =local_code);  -- 부서가 없는 사원 2명 제외

------------------------------ 실습 문제 ----------------------------------
-- 1. 사번, 사원명, 부서명, 지역명, 국가명 조회
-- (employee, department, loaction, national)
select e.emp_id 사번, e.emp_name 사원명, d.dept_title 부서명, l.local_name 지역명, n.national_name 국가명
from employee e
join department d on e.dept_code = d.dept_id
join "location" l on d.location_id =l.local_code
join "national" n on l.national_code =n.national_code;

-- 2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회
/*-- (모든 테이블)
select e.emp_id 사번,
e.emp_name 사원명,
d.dept_title 부서명,
j.job_name 직급명,
l.local_name 지역명,
n.national_name 국가명,
s.sal_level 급여등급
from employee e
join department d on e.dept_code =d.dept_id
join job j on e.job_code = j.job_code
join sal_grade s on e.sal_level=s.sal_level
join "location" l on d.location_id = l.local_code
join "national" n on l.local_code=n.national_code;*/

select e.emp_id 사번,
       e.emp_name 사원명,
       d.dept_title 부서명,
       j.job_name 직급명,
       l.local_name 지역명,
       n.national_name 국가명,
       s.sal_level 급여등급
from employee e
join department d ON e.dept_code = d.dept_id
join job j ON e.job_code = j.job_code
join sal_grade s ON e.sal_level = s.sal_level
join "location" l ON d.location_id = l.local_code
join "national" n ON l.national_code = n.national_code;