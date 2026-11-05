-- 문제 1. 시작값 700, 증가값 3, 최댓값 715, NO CYCLE, CACHE 2인
-- SEQ_LOGIN_LOG 시퀀스를 생성하고 NEXTVAL을 2회 실행한 뒤 CURRVAL을 조회
create sequence seq_login_log
	start with 700
	increment by 3
	maxvalue 715
	no cycle
	cache 2;
select nextval('seq_login_log');
select nextval('seq_login_log');

select currval('seq_login_log');


-- 문제 2. LOGIN_HISTORY 테이블을 생성하고
-- SEQ_LOGIN_LOG의 NEXTVAL과 CURRENT_DATE를 사용하여
-- 사원번호 200, 201, 202의 로그인 기록을 각각 INSERT한 뒤 전체 조회
create table login_history(
	login_no numeric,
	emp_id varchar(20),
	login_date date
);

insert into login_history(login_no, emp_id, login_date)
values 
	(nextval('seq_login_log'), '200', current_date),
	(nextval('seq_login_log'), '201', current_date),
	(nextval('seq_login_log'), '202', current_date);

select * from login_history;

-- 문제 3. SEQ_LOGIN_LOG의 증가값을 4로 변경한 뒤 NEXTVAL을 조회
-- 이어서 RESTART WITH 900, MAXVALUE 950으로 변경하고 NEXTVAL을 조회
alter sequence seq_login_log increment by 4;
select nextval('seq_login_log');

alter sequence SEQ_LOGIN_LOG restart with 900 maxvalue 950;
select nextval('seq_login_log');

-- 문제 4. VISIT_RECORD 테이블을 생성하고
-- VISIT_NO를 SERIAL PRIMARY KEY로 지정
-- 방문자명과 방문일을 입력하여 2건 INSERT한 뒤
-- PG_GET_SERIAL_SEQUENCE로 시퀀스 이름을 확인하고 전체 데이터 조회
create table visit_record(
	visit_no serial primary key,
	visitor_name varchar(50),
	visit_date date
);

insert into visit_record (visitor_name, visit_date) values ('페이커', current_date);
insert into visit_record (visitor_name, visit_date) values ('구마유시', current_date);

select pg_get_serial_sequence('visit_record', 'visit_no');
select * from visit_record;


-- 문제 5. SEQ_TEMP_ORDER 시퀀스를 생성하고 NEXTVAL을 1회 실행
-- 이후 해당 시퀀스를 삭제
create sequence seq_temp_order;
select nextval('seq_temp_order');
drop sequence seq_temp_order;

-- 문제 6. DO 블록에서 EMPLOYEE의 EMP_ID%TYPE, EMP_NAME%TYPE,
-- SALARY%TYPE을 참조하는 변수를 선언
-- 사번이 '209'인 사원의 사번, 이름, 급여를 SELECT INTO로 조회하고
-- RAISE NOTICE로 세 값을 출력
do $$
declare
	V_EID employee.emp_id%type;
	V_ENAME employee.emp_name%type;
	V_SAL employee.salary%type;
begin
	select emp_id, emp_name, salary
	into V_EID, V_ENAME, V_SAL
	from employee
	where emp_id='209';

	raise notice '사번: %, 이름: %, 급여: %', V_EID, V_ENAME, V_SAL;
end;
$$;



-- 문제 7. DO 블록에서 EMPLOYEE%ROWTYPE 변수를 선언
-- 사번이 '212'인 사원의 전체 행을 조회하여 변수에 저장하고
-- 사원명, 직급코드, 입사일, 퇴직여부를 RAISE NOTICE로 출력
do $$
declare
	V_EMP EMPLOYEE%ROWTYPE;
begin
	select *
	into V_EMP
	from employee
	where emp_id='212';
	
	raise notice '사원명: %, 직급코드: %, 입사일: %, 퇴직여부: %',
		V_EMP.EMP_NAME, V_EMP.JOB_CODE, V_EMP.HIRE_DATE, V_EMP.ENT_YN;
end;
$$;

-- 문제 8. DO 블록에서 사번이 '205'인 사원의 급여와 급여등급을 조회
-- SAL_GRADE의 MIN_SAL, MAX_SAL 범위를 이용하여 급여등급(SAL_LEVEL)을 찾고
-- 급여와 급여등급을 RAISE NOTICE로 출력
do $$
declare
	V_SAL employee.salary%type;
	V_SAL_LEVEL sal_grade.sal_level%type;
begin
	select e.salary, s.sal_level
	into V_SAL, V_SAL_LEVEL
	from employee e
	join sal_grade s on e.salary between s.min_sal and s.max_sal
	where e.emp_id ='205';

	raise notice '급여: %, 급여등급: %', V_SAL, V_SAL_LEVEL;
end;
$$;


-- 문제 9. DO 블록에서 사번이 '207'인 사원의 직급코드와 직급명을 조회
-- CASE문을 사용하여 직급코드가 J1 또는 J2이면 '임원급',
-- J3 또는 J4이면 '관리자급', J5이면 '중간관리자급',
-- 그 외에는 '일반직원'으로 구분
-- 사원명, 직급명, 직급분류를 RAISE NOTICE로 출력
do $$
declare
	V_ENAME employee.emp_name%type;
	V_JCODE employee.job_code%type;
	V_JNAME job.job_name%type;
	V_CLASS varchar(30);
begin
	select e.emp_name, e.job_code, j.job_name
	into V_ENAME, V_JCODE, V_JNAME
	from employee e
	join job j on e.job_code = j.job_code
	where e.emp_id = '207';
case
	when V_JCODE in ('J1', 'J2') then V_CLASS :='임원급';
	when V_JCODE in ('J3', 'J4') then V_CLASS :='관리자급';
	when V_JCODE = 'J5' then V_CLASS :='중간관리자급';
	else V_JCODE := '일반직원';
end case;

raise notice '사원명: %, 직급명: %, 직급분류: %', V_ENAME, V_JNAME, V_CLASS;
end;
$$;

-- 문제 10. DO 블록에서 FOR LOOP를 사용하여 1부터 5까지 반복
-- 각 숫자에 3을 곱한 결과를 RAISE NOTICE로 출력
-- 단, 결과가 9인 경우에는 '9는 건너뜁니다'를 출력하고
-- 곱셈 결과는 출력하지 않도록 IF 조건문을 사용
do $$
declare
	V_RESULT integer;
begin
	for i in 1..5 loop
		V_RESULT := i*3;

		if V_RESULT = 9 then
		raise notice '9는 건너뜁니다';
		continue;
	end if;
	raise notice '결과: %', V_RESULT;
	end loop;
end;
$$;