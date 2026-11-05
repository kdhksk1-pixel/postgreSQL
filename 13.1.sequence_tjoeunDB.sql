/*
 <sequence>
 자동으로 번호 발생기켜주는 역할을 하는 객체
 정수값을 순차적으로 일정값씩 증가시키면서 생성해줌
 
 ex) 회원번호, 사원번호, 게시글 번호,...
 
 1. sequence 생성
    [표현식]
    create sequence 시퀀스명
    [start with 시작숫자]					-> 처음 발생시킬 시작값 지정(기본값1)
    [increment by 증가값]					-> 몇 씩 증가시킬것인지(기본값1)
    [maxvalue 숫자]						-> 최대값 지정(기본값 무지큼)
    [minvalue 숫자]						-> 최소값 지정(기본값1)
    [cycle | no cycle]					-> 값 순환 여부 지정(기본값 no cycle)
    [cache 미리 만들어둘 번호의 개수]			-> 미리 확보할 시퀀스 번호 개수
    
    테이블명: TB_
    뷰명: vm_
    시퀀스: seq_
    트리거명: trg_
*/
create sequence seq_test;

create sequence seq_empno
start with 300
increment by 5
maxvalue 310
no cycle
cache 1;

/*
 2. 시퀀스 사용
    시퀀스명.currval: 현재 시퀀스 값(마지막 성공적으로 수행된 nextval의 값)
    시퀀스명.nextval: 시퀀스값에 일정값을 증가시켜서 발생된 값
                   현재 시퀀스 값에서 increment by 값 만큼 증가된 값
                   - 시퀀스명.currval + increment by 값
*/

select currval('seq_empno');  --nextval한번도 한적이 없어서 보여줄 값이 없음.(오류)
-- currval은 마지막으로 성공한 nextval의 값을 저장해서 보여주는 임시값

select nextval('seq_empno');  -- 300
select currval('seq_empno');  -- 300
select nextval('seq_empno');  -- 305

select nextval('seq_empno');  -- 310

select nextval('seq_empno');  -- maxval 값을 초과하여 오류
select currval('seq_empno');  -- 310

/*
 3. 시퀀스 구조 변경
 
 alter sequence 시퀀스명
 [increment by 증가값]					-> 몇 씩 증가시킬것인지(기본값1)
 [maxvalue 숫자]						-> 최대값 지정(기본값 무지큼)
 [minvalue 숫자]						-> 최소값 지정(기본값1)
 [cycle | no cycle]					-> 값 순환 여부 지정(기본값 no cycle)
 [cache 미리 만들어둘 번호의 개수]			-> 미리 확보할 시퀀스 번호 개수
 [restart with 시작할 숫자]				-> 시작 번호 재설정
*/
alter sequence seq_empno
increment by 10
maxvalue 400;

select nextval('seq_empno');  -- 310 + 10

-- 4. 시퀀스 삭제
drop sequence seq_empno;

---------------------------------------------------------------------------------------------
-- 사원번호를 활용할 시퀀스 생성
create sequence seq_eid
start with 400;

insert into employee (emp_id, emp_name, emp_no, job_code)
values (nextval('seq_eid'), '박수형', '111111-1111111', 'J1');

select * from employee;

insert into employee (emp_id, emp_name, emp_no, job_code)
values (nextval('seq_eid'), '이만수', '222222-2222222', 'J2');

--==============================================================================================================
/*
 <serial>
 - 자동으로 번호를 생성하는 PostgreSQL 자료형
 - 내부적으로 sequence 객체를 자동 생성
 - insert시 번호를 자동으로 증가시켜 부여
*/
-- 회원정보 테이블 생성
create table member(
	mem_no serial primary key,
	mem_name varchar(20) not null,
	phone varchar(20)
);

insert into member(mem_name, phone)
values ('김철수', '010-1234-1234');

select * from member;

insert into member(mem_name, phone)
values ('이영희', '010-1233-2643');

insert into member(mem_name, phone)
values ('박민수', '010-1233-2643');

-- 시퀀스 이름 확인
select pg_get_serial_sequence('member', 'mem_no');

-- serial의 시작값과 증가 간격 변경
alter sequence member_mem_no_seq
restart with 100;

alter sequence member_mem_no_seq
increment by 5;

insert into member(mem_name, phone)
values ('최상민', '010-1233-2643');

insert into member(mem_name, phone)
values ('양수영', '010-1233-2643');

select * from member;