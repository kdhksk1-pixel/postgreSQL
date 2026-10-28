------------------------------- 종합 문제 ----------------------------------
-- 1. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
select emp_name 사원명
	,substr(emp_no, 1, 2) 생년
	,substr(emp_no, 3, 2) 생월
	,substr(emp_no, 5, 2) 생일
from employee;
-- 2. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
select emp_name 사원명, substr(emp_no, 1, 7) || '*******' 주민번호
from employee;
-- 3. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
--   (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
select emp_name 사원명
	,abs(hire_date-current_date) 근무일수1
	,abs(current_date-hire_date) 근무일수2
from employee;
-- 4. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
select *
from employee
where cast(emp_id as integer) % 2 = 1;
-- 5. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
select *
from employee
where extract(year from AGE(current_date, hire_date)) >= 20;
-- 6. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
select emp_name 사원명,
	'\' || to_char(salary, 'FM999,999,999') 급여
from employee;
-- 7. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이 조회
--   (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 
--   나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
SELECT
    emp_name AS 직원명,
    dept_code AS 부서코드,
    SUBSTR(emp_no, 1, 2) || '년' ||
    SUBSTR(emp_no, 3, 2) || '월' ||
    SUBSTR(emp_no, 5, 2) || '일' AS 생년월일,
    EXTRACT(
        YEAR FROM AGE(
            CURRENT_DATE,
            TO_DATE(SUBSTR(emp_no, 1, 6), 'YYMMDD')
        )
    ) AS 나이
FROM employee;
-- 8. EMPLOYEE테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되 D5면 총무부
--   , D6면 기획부, D9면 영업부로 처리(EMP_ID, EMP_NAME, DEPT_CODE, 총무부)
--    (단, 부서코드 오름차순으로 정렬)
SELECT emp_id
     , emp_name
     , dept_code
     , CASE
           WHEN dept_code = 'D5' THEN '총무부'
           WHEN dept_code = 'D6' THEN '기획부'
           WHEN dept_code = 'D9' THEN '영업부'
       END AS 부서명
FROM employee
WHERE dept_code IN ('D5', 'D6', 'D9')
ORDER BY dept_code ASC;
-- 9. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
SELECT SUM((salary + (salary * COALESCE(bonus, 0))) * 12) AS 연봉합계
FROM employee
WHERE dept_code = 'D5';
-- 10. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
--      전체 직원 수, 2001년, 2013년, 2023년, 2024년
SELECT COUNT(*) AS "전체 직원 수",
       COUNT(CASE WHEN EXTRACT(YEAR FROM hire_date) = 2001 THEN 1 END) AS "2001년",
       COUNT(CASE WHEN EXTRACT(YEAR FROM hire_date) = 2013 THEN 1 END) AS "2013년",
       COUNT(CASE WHEN EXTRACT(YEAR FROM hire_date) = 2023 THEN 1 END) AS "2023년",
       COUNT(CASE WHEN EXTRACT(YEAR FROM hire_date) = 2024 THEN 1 END) AS "2024년"
FROM employee;