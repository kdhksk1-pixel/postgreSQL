/*
 <PL/pgSQL>
 Procedural language / PostgreSQL
  : PostgreSQL에서 사용하는 절차적 프로그래밍 언어
    일반 SQL문에 프로그래밍의 기능을 추가한 언어
    
 * 주요 기능
   1) 변수 선언
   2) 조건문(if, case)
   3) 반복문(loop, while, for)
   4) 예외처리(exception)
   5) 함수 및 프로시저 작성
 * PL/pgSQL 기본 구조
 
   DO $$  -- DO는 익명 블록을 즉시 실행할 때 사용
   declare
    -- 변수 선언 영역
   begin
    -- 실행 할 SQL 및 PL/pgSQL 구문
   [exception]
      -- 예외처리 영역
   END $$;
   
 * 실행방법: 익명블록(일회성 작업 적합)
   DO $$
   begin
     -- 실행 할 SQL 및 PL/pgSQL 구문
   END$$;
 
 * 실행방법 2: function 또는 procedure 생성
    >> function 생성 및 실행
    create [or replace] function 함수명()
    return void
    as $$
    begin
      -- 실행할 SQL 및 PL/pgSQL 구문
    END;
    $$ Language plpgsql;
    
    실행시: select 함수명();
    
  >> procedure 생성 및 실행(return 불필요)
  create [or replace] procedure 프로시저명()
  as $$
  begin
     -- 실행할 SQL 및 PL/pgSQL 구문
  END;
  $$ Language plpgsql;
  실행시: call프로시저명();
*/
do $$
begin
	raise notice 'Hello POSTGRESQL';
end;
$$;

/*
 1. declare 선언부
    변수 및 상수 선언하는 공간(선언과 동시에 초기화도 가능)
    일반타입 변수, 래처런스 타입 변수, ROW 타입 변수
    
    1.1) 일반타입 변수 선언 및 초기화
        [표현식]
        변수명 [constant] 자료형 [:=값];
*/
do $$
declare
	EID numeric;
	ENAME varchar(20);
	PI constant numeric := 3.14;
begin
	EID :=800;
	ENAME := '박영호';

	raise notice 'EID:%', EID;
	raise notice 'ENAME: %', ENAME;
	raise notice 'PI:%', PI;
end;
$$

-- 사용자로부터 입력받기
-- setting부터 하고 실행하기
do $$
declare
	EID numeric :=${사번};
	ENAME varchar(20) :=${이름};
	PI constant numeric :=3.14;
begin
	raise notice 'EID:%', EID;
	raise notice 'ENAME: %', ENAME;
	raise notice 'PI:%', PI;
end;
$$;

/*
-- 1.2) 레퍼런스 타입 변수 선언 및 초기화
		: 어떤 테이블의 어떤 컬럼의 데이터타입을 참조하여 그 타입으로 지정
		[표현식]
		변수명 테이블명.컬럼명%type;
*/
do $$
declare
	EID employee.emp_id%type;
	ENAME employee.emp_name%type;
	SAL employee.salary%type;
begin
	EID :='300';
	ENAME :='유재석';
	SAL :=3000000;
	raise notice '% % %', EID, ENAME, SAL;
end;
$$;

-- 사번이 200번인 사원의 사번, 사원명, 급여를 조회하여 각 변수에 대입
do $$
declare
	EID employee.emp_id%type;
	ENAME employee.emp_name%type;
	SAL employee.salary%type;
begin
	select emp_id, emp_name, salary
	into EID, ENAME, SAL
	from employee
	where emp_id='200';
	
	raise notice '사번:%', EID;
	raise notice '사원명: %', ENAME;
	raise notice '급여:%', SAL;
end;
$$;
---------------------- 문제
/*
	레퍼런스타입변수로 EID, ENAME, JCODE, SAL, DTITLE을 선언하고
	각 자료형에 EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE(DEPARTMENT)
	
	사용자가 입력한 사번의 사번, 사원명, 직급코드, 급여, 부서명을 출력
 */
do $$
declare
	EID    employee.emp_id%type;
	ENAME  employee.emp_name%type;
	JCODE  employee.job_code%type;
	SAL    employee.salary%type;
	DTITLE department.dept_title%type;
begin
	select E.emp_id, E.emp_name, E.job_code, E.salary, D.dept_title
	into EID, ENAME, JCODE, SAL, DTITLE
	from employee E
	left join department D on E.dept_code = D.dept_id
	where E.emp_id = ${사번}; 
	
	raise notice '사번: %', EID;
	raise notice '사원명: %', ENAME;
	raise notice '직급코드: %', JCODE;
	raise notice '급여: %', SAL;
	raise notice '부서명: %', DTITLE;
end;
$$;