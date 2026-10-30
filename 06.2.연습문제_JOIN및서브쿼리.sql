-- SUBQUERY_연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 이씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회
select e.emp_name 사원명
		,emp_no 주민번호
		,dept_title 부서명
		,job_name 직급명
from employee e
left join department d on e.dept_code = d.dept_id
join job j on e.job_code = j.job_code
where substr(e.emp_no, 1, 2) between '70' and '79'
	and substr(e.emp_no,8, 1) in ('2', '4')
	and e.emp_name like '이%';

-- 2. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
select 
-- 3. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
select e.emp_id 사번, e.emp_name 사원명, j.job_name 직급명
from employee e
join job j on e.job_code = j.job_code
where e.emp_name like '%하%';

-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
select emp_name 사원명, job_name 직급명, dept_id 부서코드, dept_title 부서명
from employees
where dept_code in ('D5', 'D6');
-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회

-- 6. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회

-- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회 

-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
select emp_name 사원명, dept_id 부서명
from employee
join department on (dept_code = dept_id)
where dept_code =(select dept_code
					from employee
					where emp_name = '하정연');
-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회

-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회

-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회

-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	12-1. JOIN과 HAVING 사용                
--	12-2. 인라인 뷰 사용      
--	12-3. WITH 사용

-- 13. 부서명별 급여 합계 조회(NULL도 조회되도록)

-- 14. WITH를 이용하여 급여합과 급여평균 조회