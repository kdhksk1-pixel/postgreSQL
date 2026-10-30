-- 1. 모든 사원의 사번, 사원명, 부서명을 조회하시오.
--    부서가 배정되지 않은 사원도 포함하고, 사번 오름차순으로 정렬하시오.
select e.emp_id as 사번, e.emp_name as 사원명, d.dept_title as 부서명
from employee e
left join department d on e.dept_code = d.dept_id
order by e.emp_id asc;

-- 2. 모든 사원의 사원명, 직급명을 조회하시오.
--    직급명이 '대리'인 사원만 조회하고 사원명 오름차순으로 정렬하시오.
select e.emp_name as 사원명, j.job_name as 직급명
from employee e
join job j on e.job_code =j.job_code
where j.job_name ='대리'
order by e.emp_name asc;

-- 3. 부서가 배정된 사원의 사원명, 부서명, 급여를 조회하시오.
--    급여가 3000000 이상인 사원만 급여 내림차순으로 정렬하시오.
select e.emp_name as 사원명, d.dept_title as 부서명, e.salary as 급여
from employee e
join department d on e.dept_code = d.dept_id
where e.salary >= 3000000
order by e.salary desc;

-- 4. 모든 부서의 부서명과 소속 사원 수를 조회하시오.
--    사원이 한 명도 없는 부서도 0명으로 출력하고, 부서코드 오름차순으로 정렬하시오.
select d.dept_title as 부서명, count(e.emp_id) as "소속 사원 수"
from department d
left join employee e on d.dept_id = e.dept_code
group by d.dept_id, d.dept_title
order by d.dept_id asc;

-- 5. 사원명, 부서명, 직급명을 조회하시오.
--    부서가 배정되지 않은 사원도 포함하고 사번 오름차순으로 정렬하시오.
select e.emp_name as 사원명, d.dept_title as 부서명, j.job_name as 직급명
from employee e
left join department d on e.dept_code =d.dept_id
join job j on e.job_code =j.job_code
order by e.emp_id asc;

-- 6. 부서가 배정된 사원의 사원명, 부서명, 근무 지역명, 국가명을 조회하시오.
--    사번 오름차순으로 정렬하시오.
select e.emp_name as 사원명, d.dept_title as 부서명, l.local_name as 근무지역명, n.national_name as 국가명
from employee e
join department d on e.dept_code = d.dept_id
join "location" l on d.location_id = l.local_code
join "national" n on l.national_code = n.national_code
order by e.emp_id asc;

-- 7. 관리자 사번이 등록된 사원의 사원명과 관리자명을 조회하시오.
--    해당 관리자 사번을 가진 사원이 EMPLOYEE 테이블에 실제로 존재하는 경우만 출력하시오.
select e.emp_name as 사원명, m.emp_name as 관리자명
from employee e
join employee m on e.manager_id =m.emp_id;
-- 8. 모든 사원의 사원명, 급여, 급여등급을 조회하시오.
--    급여등급은 급여가 최소급여와 최대급여 사이에 있는 경우 매칭하고, 사번 오름차순으로 정렬하시오.
select e.emp_name as 사원명, e.salary as 급여, sg.sal_level as 급여등급
from employee e
join sal_grade sg on e.salary between sg.min_sal and sg.max_sal
order by e.emp_id asc;

-- 9. 부서별 부서명, 평균급여를 조회하시오.
--    소속 사원이 2명 이상인 부서만 조회하고 평균급여 내림차순으로 정렬하시오.
select d.dept_title as 부서명, round(avg(e.salary)) as 평균급여
from employee e
join department d on e.dept_code =d.dept_id
group by d.dept_id, d.dept_title
having count(e.emp_id) >=2
order by 평균급여 desc;

-- 10. 모든 국가의 국가명과 해당 국가에 위치한 부서의 소속 사원 수를 조회하시오.
--     소속 사원이 없는 국가도 0명으로 출력하고, 사원 수 내림차순, 국가명 오름차순으로 정렬하시오.
select n.national_name as 국가명, count(e.emp_id) as "소속 사원 수"
from "national" n
left join "location" l on n.national_code = l.local_code
left join department d on l.local_code =d.location_id
left join employee e on d.dept_id = e.dept_code
group by n.national_code, n.national_name
order by count(e.emp_id) desc, n.national_name asc;