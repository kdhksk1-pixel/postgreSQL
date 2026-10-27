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

------------------------------------------------------------------
/*
 	<리터럴>
 	임의로 지정한 문자열(')
 	
 	select절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터 처럼 조회가능
 	조회된 result set의 모든 행에 반복적으로 같이 출력
 */

-- employee에 사번, 사원명, 급여 조회
select emp_id, emp_name, salary, '원' 단위
from employee;

----------------------------------------------------------------
/*
 	<연결 연산자 : ||>
 	여러 컬럼값들을 마치 하나의 컬럼인것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
 	* 숫자를 그냥 결합하면 타입에러
 	  숫자형을 문자로 명시적 변환(::text)
 */
-- employee에서 사번, 이름, 급여를 하나의 컬럼으로 조회
select emp_id || emp_name || salary as id_name
from employee;

-- 컬럼값과 리터럴을 연결
select emp_name || '의 월급은' || salary || '원 입니다' as salary
from employee;

-----------------------------------------------------------------
/*
  	<DISTINCT> 
  	컬럼에 중복된 값들을 한번씩만 표시하고자 할 때
 */
-- EMPLOYEE에서 직급코드 조회
select JOB_CODE from EMPLOYEE;

-- 위에서 중복 제거
select distinct JOB_CODE from EMPLOYEE;

-- 부서코드도 중복제거
select distinct DEPT_CODE from EMPLOYEE;

-- DISTINCT는 SELECT절에 딱 한번만 기술할 수 있음.
-- DEPT_CODE, JOB_CODE가 쌍으로 되어있는 값의 중복제거
select distinct DEPT_CODE, JOB_CODE from EMPLOYEE;

-----------------------------------------------------------------
/*
 	<WHERE 절>
 	조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만 조회할 때
 	WHERE절에 조건식을 씀
 	조건식에는 다양한 연산자 사용 가능
 	
 	[표현법]
 	SELECT 컬럼, 컬럼, ...
 	FROM 테이블명
 	WHERE 조건식;
 	
 	* 비교연산자
 	>, <, >=, <=    --> 대소 비교
 	=								--> 같은지 비교
 	!=, <>					--> 같지 않은지 비교
*/

-- EMPLOYEE에서 부서코드가 'D9'인 사원의 모든 컬럼 조회
select *
from EMPLOYEE
where DEPT_CODE = 'D9';

-- EMPLOYEE에서 부서코드가 'D1'인 사원의 사원명, 급여, 부서코드 조회
select EMP_NAME, SALARY, DEPT_CODE
from employee
where DEPT_CODE = 'D1';

-- EMPLOYEE에서 부서코드가 'D1'이 아닌 사원의 사원명, 급여, 부서코드 조회
select EMP_NAME, SALARY, DEPT_CODE
from employee
where DEPT_CODE != 'D1';

-- EMPLOYEE에서 급여가 400만원 이상인 사원의 사원명, 급여, 입사일 조회
select EMP_NAME, SALARY, HIRE_DATE
from employee
where SALARY >= 4000000;

-- EMPLOYEE에서 재직중인 사원들의 사번, 사원명, 입사일, 퇴직여부 조회
select EMP_ID, EMP_NAME, HIRE_DATE, ENT_YN
from employee
where ENT_YN = 'N';

---------------------------- 실습문제 ---------------------------
-- 1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회
select emp_name, salary, hire_date, salary*12
from employee
where salary >= 3000000;
-- 2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회
select emp_name, salary, salary*12 연봉, dept_code
from employee
where salary*12 >= 5000000;
-- 3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사여부 조회
select emp_id, emp_name, job_code, ent_yn
from employee
where job_code != 'J3';

 ------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------------------
/*<between and>
 조건식에서 사용되는 구문으로
 ~이상 ~이하인 범위에 대한 조건을 제시할 때 사용되는 연산자
 
 [표현법]
 비교대상컬럼 between 하한값 and 상한값
 */ 

-- 급여가 350만원 이상, 600만원 이하인 사원들의 사원명, 사번, 급여 조회
select emp_name, emp_id, salary
from employee
where salary between 3500000 and 6000000;

-- 입사일이 '1990-01-01~2004-12-31'
select *
from employee
where hire_date between '1990-01-01' and '2004-12-31';

-----------------------------------------------------------------------------------------------
/*
 <like>
 비교하고자 하는 컬럼값이 내가 제시한 특정 패턴에 만족하는 경우
 
 [표현법]
 비교 대상 컬럼 like '특정 패턴'
 : '특정 패턴'에는 와일드카드(%, _)로 쓸 수 있음.
 
 * %: 0글자 이상
 	ex) 비교대상 컬럼 like '문자%' => 비교 대상의 컬럼값이 '문자'로 시작되는 것 조회
 		비교대상 컬럼 like '%문자' => 비교 대상의 컬럼값이 '문자'로 끝나는 것 조회
 		비교대상 컬럼 like '%문자%' => 비교 대상의 컬럼값이 '문자'가 포함되어 있는 것 조회
 		
 * _: 1글자
		ex) 비교대상 컬럼 like '_문자' => 비교대상의 컬럼값이 '문자' 앞에 무조건 한글자가 올 경우 조회
			비교대상 컬럼 like '__문자' => 비교 대상의 컬럼값이 '문자'앞에 무조건 두글자가 올 경우 조회
			비교대상 컬럼 like '_문자_' => 비교 대상의 컬럼값이 '문자'가 무조건 한글자		
*/
-- 사원들 중 성이 전씨인 사원의 사원명, 급여, 입사일 조회
select emp_name, salary, hire_date
from employee
where emp_name like '전%';

-- 사원들 이름 중에 '하'가 포함되어 있는 사원의 사번, 사원명, 전화번호 조회
select emp_id, emp_name, phone
from employee
where emp_name like '%하%';

-- 사원들 중 이름의 가운데 '하'가 들어있는 사원의 사번, 사원명, 이메일 조회
select emp_id, emp_name, email
from employee
where emp_name like '_하_';

-- 사원의 전화번호의 3번째 자리가 1인 사원의 사번, 사원명, 전화번호, 이메일 조회
select emp_id, emp_name, phone, email
from employee
where phone like '__1%';

-- 이메일 중 _(언더바)앞에 글자가 3글자인 사원들의 이름, 이메일 조회
select emp_id, emp_name, email
from employee
where email like '___%';
 -- 와일드카드로 사용되는 문자와 컬럼값에 들어있는 문자가 동일하기 때문에 조회 불가
 -- >> 어떤 것이 와일드카드이고 데이터값인지 구분해줘야 함.
 -- >> 데이터값으로 취급하고자 하는 값 앞에 나만의 와일드 카드(아무거나 숫자, 문자, 특수기호)를 넣어줌.
 -- 	나만의 와일드 카드를 escape에 등록

select emp_id, emp_name, email
from employee
where email like '___$_%' escape '$';

-- 위의 사원을 제외한 사원들 조회
select emp_id, emp_name, email
from employee
where not email like '___$_%' escape '$';

---------------------------- 실습문제 ---------------------------
-- 1. employee에서 이름이 '연'으로 끝나는 사원들의 사번, 사원명, 입사일 조회
select emp_id, emp_name, hire_date
from employee
where emp_name like '%연';
-- 2. employee에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
select emp_name, phone
from employee
where not phone like '%010%';
-- 3. employee에서 이름에 '하'가 포함되어 있고 급여가 240만원 이상인 사원의 사번, 사원명, 급여 조회
select emp_id, emp_name, salary
from employee
where emp_name like '%하%' and salary >= 2400000;
-- 4. department에서 해외영업부인 부서들의 부서코드, 부서명 조회
select dept_id, dept_title
from department
where dept_title like '해외영업%';
-----------------------------------------------------------------------------------------------
/*
 <is null / is not null>
  컬럼값에 null이 있을 경우 null 값 비교에 이용하는 연산자
*/
-- employee에서 보너스를 받지 않는 사원들의 사번, 이름, 급여, 보너스 조회
select emp_id, emp_name, salary, bonus
from employee
where bonus is null;

-- employee에서 보너스를 받는 사원들의 사번, 이름, 급여, 보너스 조회
select emp_id, emp_name, salary, bonus
from employee
where bonus is not null;

-- employee에서 사수가 없는 사원의 사원명, 부서코드, 사수 조회
select emp_name, dept_code, manager_id
from employee
where manager_id is null;

-- employee에서 부서배치를 받지 않았지만 보너스는 받는 사원들의 이름, 보너스, 부서 코드 조회
select emp_name, bonus, dept_code
from employee
where dept_code is null and bonus is not null;
-----------------------------------------------------------------------------------------------
/*
 <in / not in>
 in: 컬럼값이 내가 제시한 목록 중에 일치하는 값이 있는 것만 조회
 not in: 컬럼값이 내가 제시한 목록 중에 일치하는 값을 제외한 나머지 조회
 
 [표현법]
 비교대상컬럼 in ('값1', '값2', '값3', ...)
*/
-- employee에서 부서코드가 D6이거나 D8이거나 D5인 사원의 이름, 부서코드, 급여 조회
select emp_name, dept_code, salary
from employee
where dept_code in ('D6', 'D8', 'D5');

-- employee에서 위의 사원을 제외한 사원들
select emp_name, dept_code, salary
from employee
where dept_code not in ('D6', 'D8', 'D5');
-----------------------------------------------------------------------------------------------
/*
 <연산자 우선순위>
 1. ()
 2. 산술 연산자
 3. 연결 연산자
 4. 비교 연산자
 5. is null / like '패턴' / in
 6. between and
 7. not(논리연산자)
 8. and(논리연산자)
 9. or(논리연산자)
*/
-- 직급코드가 J7이거나 J2인 사원들 중 급여가 200만원 이상인 사원들의 모든 컬럼 조회
select *
from employee
where job_code ='J7' or job_code ='J2' and salary  >= 2000000;