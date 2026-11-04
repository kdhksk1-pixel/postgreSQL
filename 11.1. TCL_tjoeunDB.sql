/*
 <TCL: TRANSACTION CONTROL LANGUAGE>
 트랜젝션 제어 언어
 
 * 트랜젝션
    - 데이터 베이스의 논리적 연산 단위
    - 여러 SQL작업을 하나의 작업 단위로 묶어서 처리
      > 트랜젝션이 존재하면 새로운 SQL 작업을 해당 트랜젝션에 포함.
      > 트랜젝션이 존재하지 않으면 새로운 트랜젝션을 시작
      > COMMIT 할때까지 변경사항을 관리
  * 트랜젝션의 대상이 되는 SQL: (DML) INSERT, UPDATE, DELETE
                        (DDL) CREATE, ALTER, DROP, TRUNCATE
  - COMMIT: 트랜젝션 종료 처리 후 확정
  - ROLLBACK: 현재 트랜젝션의 변경사항을 취소
  - SAVEPOINT: 현재 트랜젝션 내부의 중간 저장점을 만듬.
  - BEGIN: 트랜젝션의 시작
*/
select * from emp_01;

-- emp_id가 222번 사원 삭제
delete from emp_01
where emp_id='222';

-- emp_id가 217번 사원 삭제
delete from emp_01
where emp_id='217';

-- 트랜젝션 취소
rollback;

---------------------------------------------------------------------------------------------------------------
-- emp_id가 200번 사원 삭제
delete from emp_01
where emp_id ='200';

select * from emp_01;

-- 행 삽입
insert into emp_01
values(800, '홍길동', '총무부');

commit;

rollback;

-------------------------------------------------------------------------------------------------------
-- 217, 216, 214 사원 삭제
delete from emp_01
where emp_id in('217', '216', '214');

-- 임시 저장 지점 만들기
savepoint sp1;

-- 801번 사원 추가
insert into emp_01 values (802, '이세종', '인사관리부');

select * from emp_01;

commit;

------------------------------------------------------------------------------------
BEGIN;

--delete from emp_dept where emp_id ='217';
insert into emp_dept values('200', '이미소', 'D2', '2004-01-20');

select * from emp_dept;

savepoint sp;

insert into emp_dept values('300', '이미소', 'D2', '2004-01-20');

select * from emp_dept;


rollback to sp;
rollback transaction to sp;

select * from emp_dept;

commit;

-----------------------------------------------------------------------------------------------
--
begin;


delete from emp_01 where emp_id='800';
select * from emp_01;
savepoint sp1;

insert into emp_01(emp_id) values('900');
rollback to sp1;