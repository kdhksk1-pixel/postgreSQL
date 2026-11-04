/*
 * alter
   객체를 변경하는 구문
   
   [표현식]
   alter table 테이블명 변경할 내용;
   
   - 변경할 내용
   1) 컬럼 추가 / 수정 / 삭제
   2) 제약조건추가 / 삭제 -> 수정불가(수정하려면 삭제하고 다시 새로 추가)
   3) 컬럼명 / 제약조건명 /
*/
-------------------------------------------------------------------------------------
/*
 1. 컬럼 추가 / 수정 / 삭제
  1.1 컬럼 추가(add)
  
  [표현법]
  add 컬럼명 데이터타입 [default 기본값]
*/
create table dept_cp
as select *
	from department;

-- dept_cp에 cname컬럼 추가
alter table dept_cp add cname varchar(20);

-- laname 컬럼 추가 기본값도 추가
alter table dept_cp add lname varchar(20) default '한국';
-- > 새로운 컬럼이 만들어지고 내가 지정한 기본값으로 채워짐.

/*
 1.2 컬럼 수정: alter column
 
 [표현법]
 - 데이터 타입 수정
   alter column 컬럼명 type 바꾸고자하는 데이터타입
   
 - default 값 수정
   alter column 컬럼명 set default 바꾸고자 하는 기본값
*/
-- dept_cp테이블에서 dept_id의 데이터타입을 char(3)으로 변경
alter table dept_cp alter column dept_id type char(3)

-- 컬럼 값에 문자가 들어있는 경우 컬럼의 데이터타입을 숫자형으로 변경 못함
alter table dept_cp alter column dept_id type numeric

-- 컬럼값에 자료형은 문자이지만 숫자로만 구성된 값이라도 numeric으로 변환 안됨
-- 컬럼값에 자료형은 문자이지만 숫자로만 구성된 값이면 using으로 타입 변환 후에는 자료형 변경 가능
alter table dept_cp add type_CH varchar(20)
update dept_cp set type_CH='30'
alter table dept_cp alter column type_CH type numeric
using type_CH::numeric -- 없으면 오류

-- 컬럼의 값이 내가 변경하고자 하는 자료형의 범위를 넘어서면 오류
alter table dept_cp alter column dept_title type varchar(5)

-- 다중 변경 가능
-- dept_title 컬럼의 타입을 varchar(40)
-- dept_id 컬럼의 타입을 varchar(2)
-- lname 컬럼의 기본값을 '미국'으로 변경
alter table dept_cp
	alter column dept_title type varchar(40),
	alter column dept_id type varchar(2),
	alter column lname set default '미국'
	
insert into dept_cp (location_id) values ('L2')

/*
 1.3 컬럼 삭제
 
 [표현법]
 drop column 컬럼명
*/
create table dept_copy2
as select * from dept_cp

-- dept_copy2에서 dept_id 컬럼 지우기
alter table dept_copy2 drop column dept_id

-- 다중 삭제 가능
alter table dept_copy2
	drop column cname,
	drop column type_ch
	
alter table dept_copy2 drop column lname
alter table dept_copy2 drop column location_id
alter table dept_copy2 drop column dept_title

---------------------------------------------------------------------------------------------------------
/*
 2. 제약 조건 추가 / 삭제
 	2.1. 제약조건 추가
 		alter table 테이블명 변경할 내용
 	
 	2.2. 제약조건 삭제
 		drop constraint 제약조건
 		alter column 컬럼명 drop not null
*/
-- dept_id컬럼에 기본키 (이름 DCOPY_PK)
-- dept_title 컬럼에 unique 추가 이름(DCOPY_UQ)
-- lname에 not null 제약조건 추가
alter table dept_cp 
    add constraint dcopy_pk primary key (dept_id),
    add constraint dcopy_uq unique (dept_title),
    alter column lname set not null
    
delete from dept_cp
where dept_id is null

-- 제약조건 삭제
alter table dept_cp drop constraint dcopy_pk

-- 다중 삭제
alter table dept_cp
	drop constraint dcopy_uq,
	alter column lname drop not null
	
select constraint_name
from information_schema.table_constraints
where table_name='dept_cp'

---------------------------------------------------------------------------------------------
/*
 3. 컬럼명 / 제약조건명 / 테이블명 변경
 	3.1 컬럼명 변경
 	
 	[표현법]
 	rename column 기존컬럼명 to 바꿀 컬럼명
*/
-- dept_cp에서 dept_title를 dept_name으로 변경
alter table dept_cp rename column dept_title to dept_name

/*
 	3.2 제약조건명 변경
 	[표현법]
 	rename constraint 기존 제약 조건명 to 바꿀 제약조건명
*/
-- dept_cp에서 dept_cp_dept_id_not_null제약조건명을 dcopy_lid_nn이름으로 변경
alter table dept_cp rename constraint dept_cp_dept_id_not_null to dcopy_Lid_NN

/*
 	3.3 테이블명 변경
 	[표현법]
 	rename to 바꿀 테이블명
*/
-- dept_cp 테이블명을 dept_test로 변경
alter table dept_cp rename to dept_test

-----------------------------------------------------------------------------------------------------
/*
 4. 테이블 삭제
 drop table 테이블명;
*/
drop table dept_test

-- 외래키가 있는 경우에는 외래키까지 삭제
-- drop table 테이블명 cacade;