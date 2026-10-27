/*
  여러줄 주석: ctrl + shift + /
*/
-- 한줄 주석: ctrl + /

/*
 DML(Data Manipulation Language): 데이터 조작언어
 : 테이블에 값을 검색(select), 삽입(insert), 수정(update), 삭제(delete)하는 구문
 */
--============================================================================================================================
/*
 (') 홑따옴표: 문자열을 감싸주는 기호
 (") 쌍따옴표: 컬럼명 등을 감싸주는 기호
*/

/*
 <select>
   데이터 조회할 때 사용
   
 >> Result set: 행들의 집합
 
 [표현법]
 SELECT 조회하고자하는 컬럼, 컬럼, ...
 FROM 테이블명;
*/

--EMPLOYEE테이블에 있는 모든 컬럼(*) 조회
select *
from EMPLOYEE;

--EMPLOYEE테이블에서 사번, 이름, 급여 조회
select EMP_ID, EMP_NAME, SALARY
from EMPLOYEE;

-- JOB 테이블의 모든 컬럼 조회
select *
from JOB;

----------------------실습 문제 --------------------------------
-- 1. JOB테이블에서 직급명만 조회
select job_name
from JOB;

-- 2. DEPARTMENT테이블에서 모든 컬럼 조회
select * from DEPARTMENT;

-- 3. DEPARTMENT테이블에서 테이블의 부서코드, 부서명 조회
select dept_id, dept_title
from DEPARTMENT;

-- 4. EMPLOYEE 테이블에서 사번, 사원명, 이메일, 전화번호, 입사일, 급여 조회
select emp_id, emp_name, email, phone, hire_date, salary
from EMPLOYEE;

/*
 <컬럼값을 통한 산술연산>
 SELECT절 컬럼명 작성부분에 산술연산 쓸 수 있음.
*/
-- EMPLOYEE 테이블에서 사원명, 사원의 연봉 조회
select emp_name, salary*12
from employee;

-- EMPLOYEE에서 사원명, 보너스, 급여 조회
select emp_name, bonus, salary
from employee;

-- EMPLOYEE에서 사원명, 급여, 보너스, 연봉, 보너스가 포함된 연봉 조회
select emp_name, salary, bonus, salary*12, (bonus*salary+salary)*12
from employee;

-- EMPLOYEE에서 사원명, 입사일, 근무일수
-- DATE 형식끼리 연산 가능: +, -
-- 오늘 날짜 CURRENT_DATE
select emp_name, hire_date, current_date - hire_date
from employee;

--------------------------------------------------------------------------------------------
/*
 <컬럼명에 별칭 지정하기>
 산술연산 시 컬럼명이  ?column?으로 나옴. 이때 별칭을 부여하여 처리
 
 [표현법]
 컬럼명 별칭 / 컬럼명 as 별칭 / 컬럼명 "별칭" / 컬럼명 as "별칭"
 
 * 반드시 별칭에 쌍따옴표("")가 들어가야 할 때
	-> 별칭에 띄어쓰기가 들어 있던지, 특수문자가 포함되어 있는 경우
*/

select emp_name
	, salary
	, bonus
	, salary*12 연봉
	, (bonus*salary+salary)*12 총 소득
from employee;

select emp_name, salary, bonus, salary*12 "연봉(원)", (bonus*salary+salary)*12 as "총 소득"
from employee;
-------------------------------------------------------------------------------------------------
/*
 <리터럴>
 임의로 지정한 문자열(')
 
 select절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터 처럼 조회가능
 조회된 result set의 모든 행에 반복적으로 같이 출력
*/

-- employee에 사번, 사원명, 급여 조회
select emp_id, emp_name, salary, '원' 단위
from employee;
-------------------------------------------------------------------------------------------------
/*
 <연결 연산자: ||>
 여러 컬럼값들을 마치 하나의 컬럼인것처럼, 연결하거나, 컬럼 값과 리터럴을 연결할 수 있음.
 * 숫자를 그냥 결합하면 타입 에러
   숫자형을 문자로 명시적 변환(::text)
*/
-- employee 테이블에서 사번, 이름, 급여를 하나의 컬럼으로 조회
select emp_id || emp_name || salary id_name
from employee;

-- 컬럼값과 리터럴을 연결
select emp_name || '의 월급은' || salary || '원 입니다' salary
from employee;

-------------------------------------------------------------------------------------------------
/*
 <distinct>
 컬럼에 중복된 값들을 한번씩만 표시하고자 할 때
*/
-- employee에서 직급코드 조회
select job_code from employee;

-- 위에서 중복 제거
select distinct job_code from employee;

-- 부서 코드 중복제거
select distinct dept_code from employee;

-- distinct는 select절에 딱 한번만 기술할 수 있음.
-- dept_code, job_code가 쌍으로 되어 있는 값의 중복제거
select distinct dept_code, job_code  from employee;

-------------------------------------------------------------------------------------------------
/*
 <where 절>
 조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만 조회할 때
 where절에 조건식을 씀.
 조건식에는 다양한 연산자들을 사용 가능
 
 [표현법]
 select 컬럼, 컬럼, ...
 from 테이블명
 where 조선식;
 
 * 비교연산자
 >, <, >=, <=   ---> 대소 비교
 =				---> 같은지 비교
 !=, <>			---> 같지 않은지 비교
*/

-- employee에서 부서코드가 'D9'인 사원의 모든 컬럼을 조회
select *
from employee
where dept_code = 'D9';

-- employee에서 부서코드가 'D1'인 사원의 사원명, 급여, 부서코드 조회
select emp_name, salary, dept_code
from employee
where dept_code = 'D1';

-- employee에서 부서코드가 'D1'이 아닌 사원의 사원명, 급여, 부서코드 조회
select emp_name, salary, dept_code
from employee
where dept_code != 'D1';

-- employee에서 급여가 400만원 이상인 사원의 사원명, 급여, 입사일 조회
select emp_name, salary, hire_date
from employee
where salary >= 4000000;

-- employee에서 재직중인 사원들의 사번, 사원명, 입사일, 퇴직여부 조회
select emp_id, emp_name, hire_date, ent_yn
from employee
where ent_yn = 'N';
-- where ent_yn <> 'Y';

----------------------실습 문제 --------------------------------
-- 1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회
select emp_name, salary, hire_date, salary*12
from employee
where salary >= 3000000;
-- 2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회
select emp_name, salary, salary*12 연봉, dept_code
from employee
where salary*12 >= 5000000;
-- 3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사 여부 조회
select emp_id, emp_name, job_code, ent_yn
from employee
where job_code != 'J3';
-------------------------------------------------------------------------------------------------
/*
 <논리 연산자>
 여러개의 조건을 제시하고자 할 때
 
 and(~이면서, 그리고)
 or(~이거나, 또는)
*/

-- 부서 코드가 'D9'이면서 급여가 500만원 이상인 사원의 사원명, 부서코드, 급여 조회
select emp_name, dept_code, salary
from employee
where dept_code = 'D9' and salary >=5000000;