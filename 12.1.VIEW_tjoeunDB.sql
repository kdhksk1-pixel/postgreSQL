/*
 <view>
 : select문을 저장해 두는 데이터베이스 객체
 
 - 자주 사용하는 복잡하고 긴 select문을 view로 만들어
   매번 긴 쿼리를 작성하기 않아도 편하게 조회할 수 있음
 - 실제 데이터를 별도로 저장하는게 아니라 저장된 select문을
   통행 데이터를 조회하는 가상 테이블
 - 원본 테이블의 데이터가 변경되면 view 조회 결과에도 반영됨.
*/
-- 한국에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
select emp_id, emp_name, dept_title, salary, national_name
	from employee
	join department on (dept_code = dept_id)
	join "location" on (location_id = local_code)
	join "national" using (national_code)
where national_name = '한국';

-- 러시아에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
select emp_id, emp_name, dept_title, salary, national_name
	from employee
	join department on (dept_code = dept_id)
	join "location" on (location_id = local_code)
	join "national" using (national_code)
where national_name = '러시아';

-- 일본에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
select emp_id, emp_name, dept_title, salary, national_name
	from employee
	join department on (dept_code = dept_id)
	join "location" on (location_id = local_code)
	join "national" using (national_code)
where national_name = '일본';

-----------------------------------------------------------------
/*
 1. view 생성 방법
 
 [표현식]
 create view 뷰명
 as 서브쿼리;
*/
create view vm_employee
as select emp_id, emp_name, dept_title, salary, national_name
	from employee
	join department on (dept_code = dept_id)
	join "location" on (location_id = local_code)
	join "national" using(national_code);

select * from vm_employee;

select * from vm_employee
	where national_name = '한국';

select * from vm_employee
	where national_name = '러시아';

select * from vm_employee
	where national_name = '중국';

----------------------------------------------------------------------
/*
 * 뷰 컬럼에 별칭
   서브쿼리의 select절에 함수식이나 산술연산식이 기술되었다면 되도록 별칭을 부여하는게 편함.
*/
-- 전 사원의 사번, 이름, 직급명, 성별(남/여), 근무년수를 조회할 수 있는 뷰(vm_emp_job) 생성
create view vm_emp_job
as select emp_id, emp_name, job_name,
	case when substr(emp_no, 8, 1) in ('1', '3') then '남'
		when substr(emp_no, 8, 1) in ('2', '4') then '여'
	end,
	extract(year from current_date) - extract(year from hire_date)
from employee
join job using(job_code);

select "case" from vm_emp_job;
select "?column?" from vm_emp_job;

drop view vm_emp_job;
--drop view vm_job;

create view vm_emp_job
as select emp_id, emp_name, job_name,
	case when substr(emp_no, 8, 1) in ('1', '3') then '남'
		when substr(emp_no, 8, 1) in ('2', '4') then '여'
	end as 성별,
	extract (year from current_date) - extract(year from hire_date) as 근무년수
from employee
join job using(job_code);

select * from vm_emp_job;

select * from vm_emp_job where 성별 = '여';

select * from vm_emp_job where 근무년수 >= 20;

-----------------------------------------------------------------------------
/*
 - AGE()함수: 두 날짜 사이의 차이를 연도, 월, 일 단위로 계산해 주는 함수
   AGE(현재날짜, 과거 날짜)
*/

select age(current_date , date '2020-05-10');

select emp_id, emp_name, job_name,
	case when substr(emp_no, 8, 1) in ('1', '3') then '남'
		when substr(emp_no, 8, 1) in ('2', '4') then '여'
	end as 성별,
	extract(year from age(current_date, hire_date)) as 근무년수
from employee
join job using(job_code);
-----------------------------------------------------------------------------
/*
 * view 삭제
   drop view 뷰명
*/
drop view vm_emp_job;

-----------------------------------------------------------------------------
-- 생성된 뷰를 통해 insert, update, delete 가능

create view vm_job
as select job_code, job_name
	from job;

-- 뷰를 통한 insert
insert into vm_job values('J8', '인턴');

select * from vm_job;
select * from job;

--뷰를 통한 update
update vm_job
set job_name = '알바'
	where job_code = 'J8';

-- 뷰를 통한 delete
delete from vm_job where job_code = 'J8';

/*
 - DML 명령어로 조작이 불가능한 경우
   1) 뷰에 정의되어 있지 않은 컬럼 조작하고자 할 때
   2) 뷰에 정의되어 있지 않은 컬럼 중에 원본 테이블상에 noy null 제약조건이 지정되어 있는 경우 insert불가
   3) 산술식 또는 함수식으로 정의 되어 있는 경우
   4) 그룹 함수나 group by 절에 포함되어 있는 경우
   5) distinct 구문이 포함되어 있는 경우
   6) join을 이용하여 여러 테이블을 연결 시켜놓은 경우
*/
-- 뷰 생성
create view vm_job2
as select job_code
	from job;

select * from vm_job2;
select * from job;

-- 1) 뷰에 정의되어 있지 않은 컬럼을 조작하려고 할 때 오류
-- insert
insert into vm_job2 (job_code, job_name) values ('J8', '인턴');

-- update
update vm_job2
set job_name = '인턴'
where job_code = 'J7';

-- delete
delete from vm_job2
where job_name='대리';

-- 2) 뷰에 정의되어 있지 않은 컬럼 중에서 원본테이블상에 not null제약조건이 지정되어 있는 경우
create view vm_job3
as select job_name
	from job;

select * from vm_job3;
select * from job;

-- insert
insert into vm_job3 values ('인턴');

begin;
-- update(성공)