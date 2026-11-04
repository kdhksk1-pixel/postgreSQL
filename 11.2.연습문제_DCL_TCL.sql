/*
문제 1.
다음 조건에 맞는 로그인 Role을 생성
- Role 이름: practice_dcl_user
- 비밀번호: test1234
- 로그인 가능하도록 설정
*/
create user practice_dcl_user with password 'test1234';

-- 문제 2. practice_dcl_user에게 tjoeun 데이터베이스에 접속할 수 있는 CONNECT 권한을 부여
grant connect on database tjoeun to practice_dcl_user;

-- 문제 3. practice_dcl_user에게 public 스키마를 사용할 수 있는 USAGE 권한을 부여
grant usage on schema public to practice_dcl_user;

-- 문제 4. practice_dcl_user에게 EMPLOYEE 테이블을 조회할 수 있는 SELECT 권한만 부여하세요.
grant select on table employee to practice_dcl_user;
/*
문제 5.
다음 작업을 순서대로 수행
1) practice_dcl_user에게 EMPLOYEE 테이블의 INSERT, UPDATE, DELETE 권한을 부여
2) 부여한 권한 중 INSERT 권한만 회수
3) practice_dcl_user가 EMPLOYEE 테이블에 보유한 권한을 확인하는 SELECT문을 작성
*/
--5.1)
grant insert, update, delete on table employee to practice_dcl_user;

--5.2)
revoke insert on table employee from practice_dcl_user;

--5.3)
select privilege_type
	from information_schema.role_table_grants
	where grantee = 'practice_dcl_user'
		and table_name='employee';


-- ===========================================================================
-- 현재 접속 세션에서만 사용 접속을 종료하면 자동 삭제되는 테이블을 생성 후 문제풀기
CREATE TEMP TABLE practice_emp AS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE;
-- ===========================================================================
/*
문제 6. 다음 작업을 수행하기
1) 트랜잭션을 시작
2) 사번이 200인 사원의 급여를 1000000 증가시키기
3) 변경된 급여를 SELECT로 확인
4) ROLLBACK으로 변경사항을 취소
5) 다시 조회하여 원래 급여로 돌아왔는지 확인
*/
begin;
update practice_emp set salary = salary+1000000 where emp_id='200';
select * from practice_emp where emp_id='200';
rollback;
select * from practice_emp where emp_id = '200';

/*
문제 7. 다음 작업을 순서대로 수행하기.
1) 트랜잭션을 시작
2) 사번이 201인 사원의 급여를 500000 증가시키기
3) COMMIT으로 변경사항을 확정
4) 다시 조회하여 변경된 급여가 유지되는지 확인
*/



/*
문제 8. 다음 작업을 순서대로 수행
1) 트랜잭션을 시작
2) 사번이 202인 사원의 급여를 300000 증가시키기
3) SAVEPOINT SP1을 생성
4) 사번이 203인 사원의 급여를 400000 증가
5) ROLLBACK TO SP1을 실행
6) 사번 202와 203의 급여를 각각 조회
7) COMMIT하기

※ SP1 이전의 변경은 유지되고, SP1 이후의 변경은 취소되어야 함
*/



/*
문제 9. 다음 작업을 순서대로 수행
1) 트랜잭션을 시작하기
2) 사번 204의 급여를 100000 증가시키기
3) SAVEPOINT SP_A를 생성하기
4) 사번 205의 급여를 200000 증가시키기
5) SAVEPOINT SP_B를 생성하기.
6) 사번 206의 급여를 300000 증가시키기
7) ROLLBACK TO SP_A를 실행하기
8) 사번 204, 205, 206의 급여를 조회하기
9) COMMIT하기.

※ SP_A 이전 변경만 남고, SP_A 이후 변경은 모두 취소되어야 함
*/



/*
문제 10. 다음 작업을 순서대로 수행
1) 트랜잭션을 시작하기
2) 임시 테이블에 다음 데이터를 INSERT하기
   - 사번: 900
   - 이름: 연습사원
   - 부서코드: D1
   - 급여: 2500000
3) 사번이 200인 사원을 DELETE하기
4) SELECT로 사번 900과 200의 존재 여부를 확인하기.
5) ROLLBACK으로 모든 변경사항을 취소하기
6) 다시 조회하여 사번 900은 없고, 사번 200은 복구되었는지 확인하기
*/

-- 문제 11. 문제1~5까지 주었던 모든 권한 삭제