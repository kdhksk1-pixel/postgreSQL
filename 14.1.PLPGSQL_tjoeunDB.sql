/*
	<PL/pgSQL>
	Procedural Language / PostgreSQL
	: PostgreSQL에서 사용한는 절차적 프로그래밍 언어
	  일반 sql문에 프로그래밍의 기능을 추가한 언어
	  
	* 주요 기능
	  1) 변수선언
	  2) 조건문(IF, CASE)
	  3) 반복문(LOOP, WHILE, FOR)
	  4) 예외처리(EXCEPTION)
	  5) 함수 및 프로시저 작성
	  
	 * PL/pgSQL 기본 구조
	   
	   DO $$   -- DO는 익명 블록을 즉시 실행할 때 사용
	   [DECLARE]
	   		-- 변수 선언 영역
	   BEGIN
	   		-- 실행할 SQL 및 PL/pgSQL 구문
	   [EXCEPTION]
	   		-- 예외 처리 영역			            
	   END;
	   $$
	   
	  * 실행방법 1 : 익명블록(일회성 작업 적합)
	    DO $$
	    BEGIN
	   		-- 실행할 SQL 및 PL/pgSQL 구문		            
	    END $$;
	    
	   * 실행방법 2 : FUNCTION 또는 PROCEDURE생성
	     >> FUNCTION 생성 및 실행
		     CREATE [OR REPLACE] FUNCTION 함수명()
		     RETURN VOID
		     AS $$
		     BEGIN
		     		-- 실행할 SQL 및 PL/pgSQL 구문
		     END;
		     $$ LANGUAGE plpgsql;
		     
		     실행시 : select 함수명();
		     
		   >>  PROCEDURE생성 및 실행(RETURN 불필요)
		      CREATE [OR REPLACE] PROCEDURE 프로시저명()
		      AS $$
		      BEGIN
		     		-- 실행할 SQL 및 PL/pgSQL 구문
			    END;
			    $$ LANGUAGE plpgsql;
			    
			    실행시 : CALL 프로시저명();	                                                                                                                                       		                                                                                                                                       		                                                                                                                                       		                                                                                                                                       	                                                                                                                                       		                                                                                                                                       		                                                                                                                                       		                                                                                                                                       
*/
do $$
begin
	raise notice 'HELLO POSTGRESQL';
end;
$$

/*
	1. DECLARE 선언부
	   변수 및 상수 선언하는 공간(선언과 동시에 초기화도 가능)
	   일반타입 변수, 레퍼런스타입 변수, ROW타입 변수
	   
	   1.1) 일반타입 변수 선언및 초기화
	   		[표현식]
	   		변수명 [CONSTANT] 자료형 [:= 값];  
 */
do $$
declare
	EID numeric;
	ENAME varchar(20);
	PI constant numeric := 3.14;
begin
	EID := 800;
	ENAME := '박영호';
	raise notice 'EID : %', EID;
	raise notice 'ENAME : %', ENAME;
	raise notice 'PI : %', PI;
end;
$$

-- 사용자로 부터 입력받기
-- SETTING 부터 하고 실행하기
do $$
declare
	EID numeric := ${사번};
	ENAME VARCHAR(20) := ${이름};
	PI CONSTANT numeric := 3.14;
begin
	raise notice 'EID : %', EID;
	raise notice 'ENAME : %', ENAME;
	raise notice 'PI : %', PI;
end;
$$;

-----------------------------------------------------------------------------
/*
	1.2) 레퍼런스 타입 변수 선언 및 초기화
			 : 어떤 테이블의 어떤 컬럼의 데이터타입을 참조	하여 그 타입으로 지정
			 
			[표현식]		
			변수명 테이블명.컬럼명%TYPE;
*/

do $$
declare
	EID EMPLOYEE.EMP_ID%type;
	ENAME EMPLOYEE.EMP_NAME%type;
	SAL EMPLOYEE.SALARY%type;
begin
	EID := '300';
	ENAME := '유재석';
	SAL := 3000000;
	raise notice '% % %', EID, ENAME, SAL;
end;
$$


-- 사번이 200번인 사원의 사번, 사원명, 급여를 조회하여 각 변수에 대입
do $$
declare
	EID EMPLOYEE.EMP_ID%type;
	ENAME EMPLOYEE.EMP_NAME%type;
	SAL EMPLOYEE.SALARY%type;
begin
	select EMP_ID, EMP_NAME, SALARY
		into EID, ENAME, SAL
		from EMPLOYEE;
	 -- where EMP_ID = '200';
	 WHERE EMP_ID = ${사번};

	raise notice '사번 : %', EID;
	raise notice '사원명 : %', ENAME;
	raise notice '급여 : %', SAL;
end;
$$

---------------------- 문제
/*
	레퍼런스타입변수로 EID, ENAME, JCODE, SAL, DTITLE을 선언하고
	각 자료형에 EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE(DEPARTMENT)
	
	사용자가 입력한 사번의 사번, 사원명, 직급코드, 급여, 부서명을 출력
 */
do $$
declare
	EID EMPLOYEE.EMP_ID%type;
	ENAME EMPLOYEE.EMP_NAME%type;
	JCODE EMPLOYEE.JOB_CODE%type;
	SAL EMPLOYEE.SALARY%type;
	DTITLE DEPARTMENT.DEPT_TITLE%type;
begin
	select EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
	  into EID, ENAME, JCODE, SAL, DTITLE
	  from EMPLOYEE
	  join DEPARTMENT on (DEPT_CODE = DEPT_ID)
	 where EMP_ID = ${사번};
	 
	 raise notice '%, %, %, %, %', EID, ENAME, JCODE, SAL, DTITLE;
end;
$$

-----------------------------------------------------------------------------
/*
	1.3) ROW 타입 변수 선언
			테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
			
			[표현식]
			변수명 테이블명%ROWTYPE;
*/

do $$
declare
	E EMPLOYEE%ROWTYPE;
begin
	select *
	into E
	from EMPLOYEE
	where EMP_ID = ${사번};
	
	raise notice '사원명 : %', E.EMP_NAME;
	raise notice '급여 : %', E.SALARY;
	-- raise notice '보너스 : %', COALESCE(E.BONUS, '없음');  -- 타입이 안맞아서
	raise notice '보너스 : %', COALESCE(E.BONUS, 0);
end;
$$

-- 값이 제대로 안나옴
do $$
declare
	E EMPLOYEE%ROWTYPE;
begin
	select EMP_NAME, SALARY, BONUS  -- 무조건 *을 사용해야 한다.
	into E
	from EMPLOYEE
	where EMP_ID = ${사번};
	
	raise notice '사원명 : %', E.EMP_NAME;
	raise notice '급여 : %', E.SALARY;
	raise notice '보너스 : %', COALESCE(E.BONUS, 0);
end;
$$

/*
	EMP_ID = 사원명
	EMP_NAME = 급여
	EMP_NO = 보너스
	EMAIL = 안들어감
	....
	SALARY = 안들어감
	BONUS = 안들어감 
*/

-------------------------------------------------------------
-- 2. BEGIN
/*
	<조건문>
	1) IF 조건식 THEN 실행내용 END IF;  (단일 IF문)
*/
-- 사번 입력하면 사번, 이름, 급여, 보너스율(%)출력
-- 단, 보너스를 받지 않는 사원은 보너스율 출력전 '보너스를 받지 않는 사원입니다'출력

do $$
declare
	EID EMPLOYEE.EMP_ID%type;
	ENAME EMPLOYEE.EMP_NAME%type;
	SAL EMPLOYEE.SALARY%type;
	INCENTIVE EMPLOYEE.BONUS%type;
begin
	select EMP_ID, EMP_NAME, SALARY, COALESCE(BONUS, 0)
	  into EID, ENAME, SAL, INCENTIVE
	  from EMPLOYEE
	  where EMP_ID = ${사번};
	  
	  raise notice '사번 : %', EID;
	  raise notice '이름 : %', ENAME;
	  raise notice '급여 : %', SAL;
	  
	  IF INCENTIVE = 0
	  	THEN RAISE NOTICE '보너스를 받지 않는 사원입니다';
	  END IF;
	  raise notice '보너스율 : %', INCENTIVE*100 || '%';
end;
$$

-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF; (IF-ELSE문)
do $$
declare
	EID EMPLOYEE.EMP_ID%type;
	ENAME EMPLOYEE.EMP_NAME%type;
	SAL EMPLOYEE.SALARY%type;
	INCENTIVE EMPLOYEE.BONUS%type;
begin
	select EMP_ID, EMP_NAME, SALARY, COALESCE(BONUS, 0)
	  into EID, ENAME, SAL, INCENTIVE
	  from EMPLOYEE
	  where EMP_ID = ${사번};
	  
	  raise notice '사번 : %', EID;
	  raise notice '이름 : %', ENAME;
	  raise notice '급여 : %', SAL;
	  
	  IF INCENTIVE = 0
	  	THEN RAISE NOTICE '보너스를 받지 않는 사원입니다';
	  ELSE
	  	raise notice '보너스율 : %', INCENTIVE*100 || '%';
	  END IF; 
end;
$$

-------------------- 실습문제
/*
	레퍼런스 변수 : EID, ENAME, DTITLE, NCODE
	참조 컬럼 : EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
	일반 변수 : TEAM(소속)
	
	실행 : 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입
				단) NCODE값이 KO일 경우 => TEAM에 '국내팀'
						NCODE값이 KO가 아닐 경우 => TEAM에 '해외팀'
						
  출력 : 사번, 이름, 부서명, 소속 출력						
 */

do $$
declare
	EID EMPLOYEE.EMP_ID%type;
	ENAME EMPLOYEE.EMP_NAME%type;
	DTITLE DEPARTMENT.DEPT_TITLE%type;
	NCODE LOCATION.NATIONAL_CODE%type;
	TEAM VARCHAR(10);
begin
	select EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
	  into EID, ENAME, DTITLE, NCODE
	  from EMPLOYEE
	  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
	  where EMP_ID = ${사번};

	  IF NCODE = 'KO'
	  	THEN TEAM := '국내팀';
	  ELSE
	  	TEAM := '해외팀';
	  END IF;
	  
	  raise notice '사번 : %', EID;
	  raise notice '이름 : %', ENAME;
	  raise notice '부서명 : %', DTITLE;
	  raise notice '소속 : %', TEAM; 
end;
$$


/*
	3) IF-ELSE IF 조건문
	IF 조건식1 THEN 실행내용1;
	ELSIF 조건식2 THEN 실행내용2;
	ELSIF 조건식3 THEN 실행내용3;
	ELSE 실행내용4;
	END IF;
*/
-- 사용자로부터 점수를 입력받아 학점 출력
do $$
declare
	SCORE numeric;
	GRADE VARCHAR(1);
begin
	SCORE := ${점수};

	if SCORE >= 90 then GRADE := 'A';
	elsif SCORE >= 80 then GRADE := 'B';
	elsif SCORE >= 70 then GRADE := 'C';
	elsif SCORE >= 60 then GRADE := 'D';
	else GRADE := 'F';
	end if;
	
	raise notice '당신의 점수는 %점이고, 학점은 %학점입니다', SCORE, GRADE;
end;
$$

------------------ 실습문제
/*
	사용자로부터 입력받은 사번의 사원의 급여를 조회하연 SAL변수에 대입
	500만원 이상이면 '고급'
	300만원 이상이면 '중급'
	300만원 미만이면 '초급'
	출력 : ?사원의 급여 등급은 ?입니다.
 */

do $$
declare
	EID EMPLOYEE.EMP_ID%type;
	SAL EMPLOYEE.SALARY%type;
	GRADE VARCHAR(10);
begin
	select EMP_ID, SALARY
	  into EID, SAL
	  from EMPLOYEE
	  where EMP_ID = ${사번};
	  
	  IF SAL >= 5000000
	  	THEN GRADE := '고급';
	  ELSIF SAL >= 3000000
	  	THEN GRADE := '중급';
	  ELSE
	  	GRADE := '초급';
	  END IF; 
	  
	  raise notice '%번 사원의 급여 등급은 %입니다', EID, GRADE;
end;
$$

/*
	<CASE 문>
	CASE 비교대상자
		WHEN 비교할값1 THEN 실행내용1
		WHEN 비교할값2 THEN 실행내용2
		WHEN 비교할값3 THEN 실행내용3
		ELSE 실행내용4
	END;
*/

do $$
declare
	E EMPLOYEE%ROWTYPE;
	DNAME VARCHAR(20);
begin
		select *
		into E
		from EMPLOYEE
		where EMP_ID = ${사번};

		DNAME := case E.DEPT_CODE
			when 'D1' then '인사관리부'
			when 'D2' then '회계관리부'
			when 'D3' then '마케팅부'
			when 'D4' then '국내영업부'
			when 'D8' then '기술지원부'
			when 'D9' then '총무부'
			else '해외영업부'
		end;
		
		raise notice '%은 %입니다', E.EMP_NAME, DNAME;
end;
$$;

--=====================================================================
/*
	<반복문>
	
	- LOOP (BASIC LOOP문)
	
		[표현식]
		LOOP
			반복적으로 실행할 구문;
			* 반복을 빠져나갈 구문;
		END LOOP;
		
	  > 반복문을 빠져나오는 조건
	  1) IF 조건식 THEN EXIT; END IF;
	  2) EXIT WHEN 조건식;	
*/
-- 1~5까지 1씩 증가하면서 출력
--    1) IF 조건식으로
do $$
declare
	I numeric := 1;
begin
	loop
		raise notice '%', I;
		I := I+1;

		if I=6 then exit;
		end if;
	end loop;
end;
$$;

--    2) EXIT로
do $$
declare
	I numeric := 1;
begin
	loop
		raise notice '%', I;
		I := I+1;

		exit when I=6;
	end loop;
end;
$$;

------------------------------------------------------------------
/*
	2) FOR LOOP문
	
	 [표현식]
	 FOR 변수 IN [REVERSE] 초기값..최종값
	 LOOP
	 	반복할 실행문;
	 END LOOP;	 
*/

do $$
begin
	for I in 1..10
	loop
		raise notice '%', I;
	end loop;
	
end;
$$;

do $$
begin
	for I in REVERSE 5..1
	loop
		raise notice '%',I;
	end loop;
	
end;
$$;

create table TEST (
	TNO numeric primary key,
	TDATE DATE
);

create sequence SEQ_TNO
increment by 2;

do $$
begin
		for I in 1..100
		loop
			insert into TEST VALUES(NEXTVAL('SEQ_TNO'), CURRENT_DATE);
		end loop;
		
end;
$$;

select * from TEST;

------------------------------------------------------------------
/*
	3) WHILE LOOP문
	
	[표현식]
	WHILE 반복문이 수행될 조건
	LOOP
		반복 실행 구문;
	END LOOP;	
*/	

do $$
declare
	I numeric := 1;
begin
	while I<6
	loop
		raise notice '%',I;
		I := I+1;		
	end loop;
end;
$$;

------------------------------------------------------------------
/*
	3. 예외처리부
	   : 실행중 발생하는 오류
	   
	   [표현식]
	   EXCEPTION
	   	WHEN 예외명1 THEN 예외처리구문1;
	   	WHEN 예외명2 THEN 예외처리구문2;
	   	WHEN OTHERS THEN 예외처리구문N;
	   	
	   	* 시스템예외
	   	  - NO_DATA_FOUND : SELECT한 결과가 한 행도 없을 경우
	   	  - TOO_MANY_ROWS : SELECT한 결과가 여러행 일때
	   	  - ZERO_DIVIDE : 0으로 나눌때
	   	  - DUP_VAL_ON_INDEX : UNIQUE제약조건에 위배되었을 때
 */
do $$
declare
	result1 numeric;
	INPUT_NUM numeric := ${숫자};
begin
	result1 := 10/INPUT_NUM;
	raise notice '결과 : %', RESULT1;
EXCEPTION
	WHEN DIVISION_BY_ZERO THEN RAISE NOTICE '0으로 나눌 수 없습니다';
end;
$$;

-- UNIQUE 제약조건 위반
do $$
begin
	update EMPLOYEE
	set EMP_ID = ${사번}
	where EMP_NAME = '이정하';
EXCEPTION
	-- WHEN unique_violation THEN RAISE NOTICE '이미 존재하는 사번입니다';
	WHEN others THEN RAISE NOTICE '이미 존재하는 사번입니다';
end;
$$;

-- 사수 211:1명, 200:여러명, 213:없음
do $$
declare
	EID EMPLOYEE.EMP_ID%type;
	ENAME EMPLOYEE.EMP_NAME%type;
begin
	select EMP_ID, EMP_NAME
	into EID, ENAME
	from EMPLOYEE
	where MANAGER_ID = '213';

	raise notice '사번 : %', EID;
	raise notice '이름 : %', ENAME;
end;
$$;

-- 사수 200:여러명, 213:없음
   -- INTO STRICT 딱 한행 아닐때 오류발생 시킴
do $$
declare
	EID EMPLOYEE.EMP_ID%type;
	ENAME EMPLOYEE.EMP_NAME%type;
begin
	select EMP_ID, EMP_NAME
	into STRICT EID, ENAME
	from EMPLOYEE
	where MANAGER_ID = ${사번};

	raise notice '사번 : %', EID;
	raise notice '이름 : %', ENAME;
	
EXCEPTION
	WHEN TOO_MANY_ROWS THEN
		raise notice '너무 많은 행이 조회되었습니다';
	WHEN NO_DATA_FOUND THEN
	  raise notice '조회 결과가 없습니다.';
end;
$$;

-- 연습문제
/*
	1. 사원의 연봉을 구하는 PL/PGSQL블럭 작성, 보너스가 있는 사원은 보너스도 포함하여 계산
	2. 구구단 짝수단 출력
			1) FOR LOOP
			2) WHILE LOOP
*/
do $$
declare
	v_ename employee.emp_name%type;
	v_sal   employee.salary%type;
	v_bonus employee.bonus%type;
	v_annual_sal numeric;
begin
	select emp_name, salary, coalesce(bonus, 0)
		into v_ename, v_sal, v_bonus
		from employee
		where emp_id = ${사번};
		
	v_annual_sal := (v_sal * 12) + (v_sal * 12 * v_bonus);
	
	raise notice '사원명: %', v_ename;
	raise notice '계산된 연봉: %원', v_annual_sal;
end;
$$;

-- 2.1. FOR LOOP)
do $$
begin
	for i in 2..9 
	loop
		if i % 2 = 0 then
			raise notice '=== %단 ===', i;
			
			for j in 1..9 
			loop
				raise notice '% x % = %', i, j, i * j;
			end loop;
		end if;
	end loop;
end;
$$;

-- 2.2. WHILE LOOP)
do $$
declare
	i int := 2;
	j int; 
begin
	while i <= 9 
	loop
		if i % 2 = 0 then
			raise notice '=== %단 ===', i;
			
			j := 1;
			
			while j <= 9 
			loop
				raise notice '% x % = %', i, j, i * j;
				j := j + 1;
			end loop;
		end if;
		
		i := i + 1;
	end loop;
end;
$$;