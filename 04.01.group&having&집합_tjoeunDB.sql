/*
 <group by절>
 그룹기준을 제시할 수 있는 구문(그룹기준별로 여러 그룹으로 묶을 수 있음)
 여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/

select sum(salary)
from employee;

-- 각 부서별 총 급여합
select dept_code, sum(salary)
from employee
group by dept_code;

-- 각 부서별 사원 수
select dept_code, count(*)
from employee
group by dept_code;

-- 각 부서별 급여의 합과 사원 수
select dept_code, sum(salary), count(*)
from employee
group by dept_code
order by dept_code;

-- 직급별 인원수와 급여의 합
select job_code, count(*), sum(salary)
from employee
group by job_code;

-- 각 직급별 총 사원수, 보너스를 받는 사원 수, 급여합, 급여평균, 최저급여, 최고급여
select job_code
	,count(*) as 총사원수
	,count(bonus) as "보너스를 받는 사원 수"
	,sum(salary) as 급여합
	,round(avg(salary), -1) as 급여평균
	,min(salary) as 최저급여
	,max(salary) as 최고급여
from employee
group by job_code
order by 1;

-- 남성, 여성별 사원수
select case when substr(emp_no, 8, 1) in('1', '3') then '남'
						when substr(emp_no, 8, 1) in('2', '4') then '여'
				end as 성별
				, count(*)
from employee
group by case when substr(emp_no, 8, 1) in ('1' ,'3') then '남'
						when substr(emp_no, 8, 1) in('2', '4') then '여'
				end;



select case when substr(emp_no, 8, 1) in ('1', '3') then '남'
						when substr(emp_no, 8, 1) in ('2', '4') then '여'
				end as 성별
				, count(*) as 사원수
from employee
group by 성별
order by 성별;

-- group by 절에 여러 컬럼 기술 가능
select dept_code, job_code, count(*), sum(salary)
from employee
group by dept_code, job_code;

-- 입사년도별 급여의 합계
select extract(year from hire_date) as 입사년도
			, sum(salary) as 급여합계
from employee
group by 입사년도
order by 1;

select to_char(hire_date, 'YYYY') as 입사년도
			, sum(salary) as 급여합계
from employee
group by 입사년도
order by 1;

-------------------------------------------------------------------------------
/*
 <having 절>
 그룹에 대한 조건을 제시할 때 사용
*/
-- 각 부서별 급여 평균 조회
select dept_code, avg(salary)
from employee
group by dept_code;

-- 각 부서별 평균급여가 300만원 이상인 부서들만 조회
/*
select dept_code, avg(salary)
from employee
where avg(salary) >= 3000000  -- 그룹에 대한 조건은 where절 안됨
group by dept_code;
*/

select dept_code, round(avg(salary))
from employee
group by dept_code
having avg(salary) >= 3000000;

/*
 	<실행 순서>
 	from
 	where
 	group by(select에서 별칭을 사용할 수 있도록 예외를 둠)
 	having
 	select
 	distinct
 	order by
*/

--------------------------------- 실습문제 ---------------------------------
-- 1. 직급별 급여합(조건: 직급별 급여의 합이 100만원 이상인 직급만 조회), 직급코드, 급여합 조회
select job_code, sum(salary)
from employee
group by job_code
having sum(salary) >= 10000000
order by 1;

-- 2. 부서별 보너스를 받는 사원이 없는 부서만 부서코드 조회
select dept_code, count(bonus)
from employee
group by dept_code;

select dept_code
from employee
group by dept_code
having count(bonus) = 0;

----------------------------------------------------------------------------
/*
 <집계함수>
 그룹별 산출된 결과 값에 중간집계를 계산해 주는 함수
 
 rollup, cube
 => group by절에 기술하는 함수
 
 - rollup(컬럼1, 컬럼2): 컬럼1을 가지고 중간집계를 내는 함수
 - cube(컬럼1, 컬럼2): 컬럼1을 가지고 중간집계내고, 컬럼2를 가지고도 중간집계를 냄
*/
-- 각 직급별 급여합
select job_code, sum(salary)
from employee
group by job_code;

select job_code, sum(salary)
from employee
group by cube(job_code);
-- 그룹기준이 하나의 컬럼일 때는 rollup, cube 차이가 없음

select dept_code, job_code, sum(salary)
from employee
group by dept_code, job_code;

-- rollup(컬럼1, 컬럼2): 컬럼 1만 중간집계
select dept_code, job_code, sum(salary)
from employee
group by rollup(dept_code, job_code)
order by dept_code, job_code nulls last;

-- cube(컬럼1, 컬럼2): 컬럼1 중간집계, 컬럼2 중간집계
select dept_code, job_code, sum(salary)
from employee
group by cube(dept_code, job_code)
order by dept_code, job_code nulls last;

----------------------------------------------------------------------------
/*
 <집합 연산자>
 여러 개의 쿼리문을 가지고 하나의 쿼리문을 만드는 연산자
 
 - union: 합집합(or)
 - intersect: 교집합(and)
 - union all: 합집합 + 교집합
 - except: 차집합
*/
--------------------------------- 1. UNION
-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원의 사번, 사원명, 부서코드, 급여 조회
-- 부서코드가 D5인 사원
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5';  --- 6명
-- 급여가 300만원 초과
select emp_id, emp_name, dept_code, salary
from employee
where salary >= 3000000;  --- 8개

-- union
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5'
union
select emp_id, emp_name, dept_code, salary
from employee
where salary >= 3000000;

-- or의 결과ㅗ아 동일
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5' or salary >= 3000000;

--------------------------------- 2. INTERSECT
-- 부서코드가 D5이면서 급여가 300만원 초과인 사원들 조회
select emp_id, dept_code, salary
from employee
where dept_code = 'D5'
intersect
select emp_id, emp_name, dept_code, salary
from employee
where salary >= 3000000;

-- and로도 가능
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5' and salary >= 3000000;

-- 집합연산자 사용 시 유의사항
select emp_id, emp_name, dept_code, salary
from employee
where dept_code ='D5'
intersect
select emp_id, emp_name, dept_code, salary
from employee
where salary >= 3000000;
-- 각 쿼리문의 select절에 작성되는 컬럼의 개수는 동일해야 함.

select emp_id, emp_name, dept_code, salary
from employee
where dept_code ='D5'
intersect
select emp_id, emp_name, dept_code, bonus
from employee
where salary >= 3000000;
-- 컬럼의 개수뿐 아니라 각 컬럼마다 동인한 타입이 기술되어야 한다
-- 타입과 개수가 동일해도 같은 컬럼이 아니면 오류나지 않지만 결과 set이 안나옴.

--------------------------------- 3. UNION ALL
-- 부서코드가 D5이면서 급여가 300만원 초과인 사원들 모두(겹치는 데이터 포함) 조회
select emp_id, emp_name, dept_code, salary
from employee
where dept_code ='D5'
union all
select emp_id, emp_name, dept_code, salary
from employee
where salary >= 3000000
order by 1;

--------------------------------- 4. EXCEPT
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5'
except
select emp_id, emp_name, dept_code, salary
from employee
where salary >= 3000000
order by 1;

select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5' and salary <= 3000000;