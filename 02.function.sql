/*
 <함수 function>
 전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
 
  - 단일행 함수: N개이 값을 읽어들여 N개의 결과값 반환(매 행마다 함수 실행)
  - 그룹 함수: N개의 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
  
  >> select절에 단행함수와 그룹함수를 함께 사용할 수 없음.
  >> 함수식을 기술할 수 있는 위치: select절, where절, order by절, having절
*/

------------------------------- 단일행 함수 -------------------------------

-- ====================================================================================
--								<문자 처리함수>
-- ====================================================================================
/*
 LENGTH / OCTET_LEGTH => INTEGER로 반환
 
 LENGTH(컬럼명 | '문자열'): 해당 글자 수 반환
 OCTET_LENGTH(컬럼명 | '문자열'): 해당 문자열의 BYTE수 반환
 	- 한글: 1글자당 3byte / 영문, 숫자, 공백: 1글자당 1byte
*/
select length('데이터베이스'), OCTET_LENGTH('데이터베이스');

select length('postgreSQL'), OCTET_LENGTH('postgreSQL');

select emp_name, length(emp_name), OCTET_LENGTH(emp_name), email, length(email), OCTET_LENGTH(email)
from employee;

-----------------------------------------------------------------------------------------------
/*
 * LEFT / RIGHT('문자열', 글자수): 왼쪽/오른쪽 끝에서 부터 지정한 개수만큼 문자열 반환
    > 글자수에 음수를 넣으면 맨 뒤/앞의 글자수 만큼 제외하고 나머지 전부
*/
select left('databasepostgresql', 4);
select right('databasepostgresql', 3);
select right('서울특별시', 3);

select left('DATABASESQL', -3);   -- 맨 뒤의 글자 3개를 제외하고
select right('DATABASEPostgreSQL', -8);   -- 맨 앞의 글자 8개를 제외하고

select right('DATA', 100);    -- 커도 상관없음.
select right('DATA', 0);    -- 빈 문자열 반환

/*
 * POSITION / STRPOS: 문자열로부터 특정 문자의 시작 위치(INDEX)를 찾아서 반환(1부터 시작, 없으면 0)
*/

select position('A' in 'DATABASE');
select strpos('DATABASE', 'A');  -- 결과 동일
select position('A' in reverse('DATABASE'));  -- 결과 3: ESABATAD에서 A의 위치 -> 3

select email, position('_' in email) as "_위치", position('@' in email) as "@위치" from employee;

---------------------------------------------------------------------------------------------------
/*
 * SUBSTR / SUBSTRING: 문자열에서 특정 문자열을 추출
 - SUBSTR('문자열', POSITION, [LENGTH])
 	> POSITION: 문자열을 추출할 시작 위치 INDEX
 	> LENGTH: 추출할 문자 개수(생략 시 맨 끝까지 추출)
 - SUBSTRING('문자열', from POSITION [for LENGTH])
*/

select substr('DATABASESQL', 5);
select substring('DATABASE' from 5);

select substr('DATABASE', 5, 4);
select substring('DATABASE' from 5 for 4);

select substr('DATABASE', 3, 6);
select substring('DATABASE' from 3 for 6);

-- employee테이블에서 주민번호에 성별만 추출하여 주민번호, 사원명, 성별조회
select emp_no as 주민번호, emp_name as 사원명, substr(emp_no, 8, 1) as 성별
from employee;

-- employee 테이블에서 여자 사원들만 사번, 사원명, 성별(1~4중 하나) 조회
select emp_no, emp_name, substr(emp_no , 8, 1)
from employee
where substr(emp_no, 8, 1) in ('2', '4');

-- employee 테이블에서 남자 사원들만 사번, 사원명, 성별(1~4중 하나) 조회
select emp_no, emp_name, substr(emp_no , 8, 1)
from employee
where substr(emp_no, 8, 1) in ('1', '3');

-- employee테이블에서 email의 아이디만 추출하여 사원명, 이메일, 아이디 조회
select emp_name, email, split_part(email, '@', 1) from employee;

select emp_name, email, substr(email, 1, position('@' in email)-1) 아이디 from employee;

-------------------------------------------------------------------------------------------------------------------------------------
/*
 * LPAD / RPAD: 문자열을 조회할 때 길이를 맞춰 통일감있게 조회하고자 할 때
   LPAD/RPAD('문자열', 최종 반환할 문자의 길이, [덧붙이고자하는 문자])
*/
-- 20길이에 맞춰 email을 오른쪽 정렬하고 앞부분은 공백으로 채워서 출력
select emp_name, lpad(email, 25)   -- 덧붙이고자 하는 문자 생략 시 기본값 공백
from employee;

select emp_name, lpad(email, 25, '#')
from employee;

select emp_name, rpad(email, 25, '#')
from employee;

-- employee테이블에서 사번, 사원명, 주민번호 출력(주민번호는 123456-1******의 형식으로)
select emp_id, emp_name, rpad(substr(emp_no, 1, 8), 14, '*')
from employee;

select emp_id, emp_name, substr(emp_no, 1, 8) || '******' 주민번호
from employee;
-------------------------------------------------------------------------------------------------------------
/*
 * LTRIM/RTRIM: 문자열에서 특정 문자를 제거하고 반환
 * TRIM: 문자의 앞/뒤 양쪽에 있는 특정 문자들을 제거한 나머지 반환
   
   LTRIM / RTRIM('문자열', [제거하고자 하는 문자])  -> 제거하고자하는 문자를 생략 시 공백 제거
   TRIM([LEADING|TRAILING|BOTH]제거하고자 하는 문자 FROM '문자열')
*/
select ltrim('     TJOEUN     ') || '컴퓨터아카데미';
select rtrim('     TJOEUN     ') || '컴퓨터아카데미';

select ltrim('DATADATABASE', 'DATA');
select ltrim('BACABAADISIRITR', 'ABC');
select ltrim('3724KSJDIF37284', '0123456789');

select rtrim('3724KSJDIF37284', '0123456789');

select trim('     TJOEUN    ') || '컴퓨터아카데이';   -- 기본값 양쪽 제거

-- 방행 지정
select trim(leading 'A' from 'AAAAAABOKDDF1271ADKA');
select trim(trailing 'A' from 'AAASADFSDFSDGTWFFSDFEIOKI');
select trim(both 'A' from 'AAAAAAKWODAAAAAAAA')  -- 기본값

/*
 * LOWER / UPPER / INITCAP: 문자열 대소문자로 변환 및 단어의 앞글자만 대문자로 변환
 * LOWER('문자열')
 */

select lower('DATABASE PostgreSQL');
select upper('DATABASE PostgreSQL');
select initcap('database PostgreSQL');
---------------------------------------------------------------------------------------------------------------------
/*
 * CONCAT: 문자열 두개를 하나로 합친 결과 반환
 * CONCAT('문자열*, '믄자열'/
*/
select concat('SQL', '포스트그레');
select concat('PostgreSQL', '데이터베이스', '02-1234-3456')
select 'SQL' || '포스트그레';
----------------------------------------------------------------------------------------------------------
/*
 * REPLACE: 기존 ㅁ누자열을 새로운 문자열로 변경
 
   [표현법]
   REPLACE('문자열', '기존문자열', '바꿀문자열')
*/
select emp_name, email, replace(email, 'google.com', 'naver.com')
from employee;

-- ====================================================================================
--								<숫자 처리함수>
-- ====================================================================================
/*
 * ABS: 숫자의 절대값을 구해주는 함수
   ABS(NUMBER)
*/
select abs(-19);
select abs(-13.67);

----------------------------------------------------------------------------------------------------------
/*
 * MOD / %: 나머지 값 반환
*/
select mod(10,3);
select 10%3;   -- postgreSQL에서만 사용
----------------------------------------------------------------------------------------------------------
/*
 * ROUND: 반올림한 결과 반환
   [표현법]
   ROUND(NUMBER, [위치])
*/
select round(1234.56);
select round(12.34);

select round(1234.5678, 2);
select round(1234.56, 4);

select round(1277.56, -2);

--------------------------------------------------------------------------------------------------------
/*
 * CEIL: 올림한 결과 반환
 * FLOOR: 내림한 결과 반환
*/
select ceil(123.234);
select ceil(-123.234);

select floor(123.234);
select floor(-123.234);
--------------------------------------------------------------------------------------------------------
/*
 * TRUNC: 버림
   TRUNC(NUMBER, [위치])
*/
select trunc(123.789);
select trunc(123.789, 1);

select trunc(-123.789);
select trunc(125.456, -1);

-- ====================================================================================
--								<날짜 처리함수>
-- ====================================================================================
/*
 * CURRENT_DATE: 시스템 날짜
 * NOW(): 시스템 날짜와 시간
*/
select current_date;
select now();

select emp_name, hire_date, current_date-hire_date 근무일수
from employee;

--------------------------------------------------------------------------------------------------------
/*
 * INTERVAL 'n MONTH': 특정 날짜에 해당 숫자만큼 개월수를 더해 날짜를 리턴
*/
select current_date + interval '1 MONTH' 다음달;
select (current_date + interval '1 MONTH')::DATE 다음달;

-- employee에서 사원명, 입사일, 입사 후 정직원된 날짜(6개월 후) 조회
select emp_name, hire_date, (hire_date+interval '6 MONTH')::DATE "정직원된 날짜"
from employee;

---------------------------------------------------------------------------------------------------------------
/*
 * EXTRACT: 특정날짜로부터 년|월|일 값을 추출하여 반환
   EXTRACT(YEAR FROM DATE): 년도만 추출
   EXTRACT(MONTH FROM DATE): 월만 추출
   EXTRACT(DAY FROM DATE): 일만 추출
*/
-- employee에서 사원명, 입사년도, 입사월, 입사일 조회
select emp_name, extract(year from hire_date)::text as 입사년도, extract (month from hire_date) as 입사월, extract (day from hire_date) as 입사일
from employee;

-- ====================================================================================
--								<형 변환 함수>
-- ====================================================================================
/*
 * TO_CHAR: 숫자 또는 날짜를 문자로 변환
  - 특정 형식에 맞게 출력 가능
  TO_CHAR(숫자|날짜, [포맷])
*/
------------------------------- 숫자타입 -> 문자타입
/*
 * 9: 해당 자리의 숫자를 의미
		- 값이 없을 경우 소수점은 공백, 소수점 이하는 0표시
   0: 해당 자리의 숫자를 의미
   		- 값이 없을 경우 0으로 표시
   FM: 해당 자리에 값이 없을 경우 자리차지하지 않음.
*/
select to_char(1234, '99999'), to_char(1234, '00000');
select to_char(123.45, '99999.9999'), to_char(123.45, '00000.0000');
select to_char(0.12, '9.99'), to_char(0.12, '0.00');

select '￦' || to_char(1234, '99,999');

select emp_name, '￦' || to_char(salary, '999,999,999') as 급여, '￦' || to_char(salary*12, '999,999,999') as 연봉
from employee;

select to_char(0.1000, '999,990.999');

select to_char(123.456, 'FM99990.999'), to_char(1234.56, 'FM9990.99'), to_char(0.1000, 'FM9990.999'), to_char(0.1000, 'FM9999.999');

-- postgreSQL에서만 사용
-- FML: L(LOCAL의 설정에 따라 통화 기호 나타냄)
select to_char(1234, 'FML999,999');

select emp_name, '￦' || to_char(salary, 'FML999,999,999') as 급여, '￦' || to_char(salary*12, 'FML999,999,999') as 연봉
from employee;

------------------------------- 날짜 타입 -> 문자 타입
select to_char(now(), 'YYYY') as 년도4자리
	,to_char(now(), 'YY') as 년도2자리
	,to_char(now(), 'MM') as 월
	,to_char(now(), 'day') as 일   --day이면 소문자로 요일, DAY이면 대문자로 요일
	,to_char(now(), 'MI') as 요일
	,to_char(now(), 'HH') as 시
	,to_char(now(), 'MI') as 분
	,to_char(now(), 'MS') as 초;

-- 시간
select to_char(now(), 'AM HH:MI:SS');  -- AM or PM 어떤것들 쓰던 상관 없음.
select to_char(now(), 'HH12:MI:SS');   -- 12시간제. AM or PM없이
select to_char(now(), 'HH24:MI:SS');   -- 24시간제. AM or PM없이

-- 날짜
select to_char(now(), 'YYYY-MM-DD DAY');
select to_char(now(), 'YYYY"년" MM"월" DD"일" DAY');

-- employee에서 사원명, 입사일(형식 25-10-28) 조회
select emp_name as 사원명, to_char(hire_date, 'YY-MM-DD') as 입사일
from employee;

-- employee에서 사원명, 입사년도(4자리), 입사월, 입사일 조회
select emp_name as 사원명
	,extract(YEAR from hire_date) 입사년도
	,extract(MONTH from hire_date) 입사월
	,extract(DAY from hire_date) 입사일
from employee;

------------------------------------------------------------------------------------------------------------------
/*
 * TO_DATE: 문자열을 날짜로 변경
   : 숫자를 바로 넣는 것은 허용하지 않음. 반드시 문자열로 넣어야 됨.
   
   TO_DATE('문자열', '포맷')
*/
select to_date('261028', 'YYMMDD');
select to_date('261028 152850', 'YYMMDD HH24MISS');
		-- TO_DATE() 함수의 특성상 시간정보는 버려짐. 년월일만 출력
select to_date(20261028::TEXT, 'YYYYMMDD');

------------------------------------------------------------------------------------------------------------------
/*
 * TO_TIMESTAMP(): 문자열로 표현된 날짜와 시간을 포맷으로 변환
   TO_TIMESTAMP('문자열', '포맷')
*/
select to_timestamp('2026-10-28 15:12:30', 'YYYY-MM-DD HH24:MI:SS');

select to_timestamp('20261028 151230', 'YYYYMMDD HH24MISS');

select to_timestamp('2026-10-28 PM 03:14', 'YYYY-MM-DD AM HH:MI');

------------------------------- 문자 타입 -> 숫자 타입
/*
 * TO_NUMBER: 문자열을 숫자로 변환
*/
select to_number('012341234', '9999999999');
select to_number('1,000,000', '999,999,999') + to_number('550000', '999,999,999');

select '1000000'::int+'550000'::int;

-- ====================================================================================
--								<NULL 처리 함수>
-- ====================================================================================
/*
 * COALESCE(컬럼, 해당컬럼값이 NULL일 때 반환할 값)
*/
-- employee에서 사원명, 보너스(NULL이면 0으로 출력)
select emp_name, coalesce (bonus, 0)
from employee;

-- employee에서 사원명, 보너스 포함 연봉 조회
select emp_name, salary*(1+bonus)
from employee;

select emp_name, to_char((salary+salary*coalesce(bonus,0))*12, 'FML999,999,999') 연봉
from employee;

-- employee에서 사원명, 부서코드(NULL이면 '부서 없음'), 입사일 조회
select emp_name, coalesce(dept_code, '부서없음'), hire_date
from employee;

-- ====================================================================================
--								<선택 함수>
-- ====================================================================================
/*
 * CASE WHEN THEN
   ...
   END
   
   ex)
   CASE WHEN 조건식1 THEN 결과값1
   		WHEN 조건식2 THEN 결과값2
   		...
   		ELSE 결과값N
   END
   
   IF-ELSE와 같음.
*/
-- employee에서 급여가 350만원 미만이면 '초급', 350만원 이상 500만원 미안 이면 '중급', 500만원 이상이면 '고급'
select emp_name, salary
,case when salary < 3500000 then '초급' when salary >=3500000 then '중급' else '고급' end as 급수
from employee;

-- ====================================================================================
--								<그룹 함수>
-- ====================================================================================
/*
 * SUM(숫자타입의 컬럼): 컬럼들의 총 합계를 반환
*/
-- employee에서 전사원의 총 급여의 합
select sum(salary) "급여의 합계" from employee;

-- employee에서 남자 사원의 총 급여의 합
select sum(salary)
from employee
where substr(emp_no, 8, 1) in ('1', '3');

-- employee에서 부서코드가 D5인 사원들의 총 연봉의 합
select sum(salary*12)
from employee
where dept_code ='D5';

select to_char(sum(salary*(1+coalesce(bonus,0))*12), 'FML999,999,999') "총 연봉"
from employee
where dept_code='D5';

/*
 * AVG(숫자타입의 컬럼): 평균반환
*/
select avg(salary) from employee;
select round(avg(salary),-1) from employee;

/*
 * MIN / MAX(모든타입의 컬럼): 최소값과 최대값
*/
select min(emp_name), min(salary), min(hire_date) from employee;

select max(emp_name), max(salary), max(hire_date) from employee;

/*
  * COUNT(* | 컬럼 | DISTINCT 컬럼): 행 갯수 반환
  * COUNT(*): 조회된 결과의 모든 행의 개수 반환
  * COUNT(컬럼): 컬럼의 값이 NULL인것을 제외한 행의 개수 반환
  * COUNT(DISTINCT 컬럼): 중복을 제거한 행의 개수 반환
*/
-- employee에서 전체 사원수
select count(*) from employee;

-- 보너스를 받는 사원의 수
select count(bonus) from employee;

-- 부서배치를 받은 사원의 수
select count(dept_code) from employee;

-- 중복제거한 부서의 수
select count(distinct dept_code) from employee;

-- 여성 사원의 수
select count(*)
from employee
where substr(emp_no, 8, 1) in ('2', '4');

-- ====================================================================================
--								<PostgreSQL에서 형 변환>
-- ====================================================================================

-- 숫자 자료형 
::int or integer  => 정수 4byte
::numeric		  => 소수(정수)
::real			  => 실수(4byte)

-- 문자 자료형
::text			  => 길이 제한이 없는 문자열
::varchar		  => 가변 길이 문자열
::varchar(n)	  => 가변 길이 이지만 최대 n글자까지만 넣을 수 있음.
::char(n)		  => 고정 길이(n)

-- 날짜 시간
::date			  => 날짜만 표시
::time			  => 시간만 표시
::timestamp		  => 날짜와 시간 표시
::interval		  => '1 MONTH'::interval

-- 기타 자료형
::boolean		  => 참 거짓
::json			  => json 자료형  '{"AGE":25}'::json