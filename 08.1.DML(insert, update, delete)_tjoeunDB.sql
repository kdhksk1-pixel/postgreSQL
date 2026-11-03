/*
 * DML
   insert: 테이블에 데이터 삽입
   update: 테이블의 데이터를 수정
   delete: 테이블의 데이터(행)을 삭제
*/
--====================================================================================
/*
 1. insert
    테이블에 새로운 행을 추가하는 구문
    
    [표현식]
    1) insert into 테이블명 values(값1, 값2, 값3,...);
       테이블의 모든 컬럼에 대한 값을 한 행을 넣고 할 때 사용
       컬럼의 순서를 지켜 values에 값을 나열해야 함.
*/
insert into employee_copy values(300, '더조은', '031103-3123456', 'tjoeun@google.com', '01056748987', 'D3', 'J7', 3500000, 0.1, 208, '2025-08-15', null, default)
--------------------------------------------------------------------------------------------------------------------------
/*
 2) insert into 테이블명(컬럼명1, 컬럼명2,...) values (값1, 값2, ...);
    테이블에 내가 선택한 컬럼에 대한 값만 삽입할 때 사용
    그래도 한 행 단위로 추가됨.
    ** 주의: not null인 컬럼은 반드시 값이 들어감.
    - 기본값이 지정되어 있는 것은 값을 안넣으면(컬럼을 아예 안넣음) 자동으로 기본값이 들어감.
*/
insert into employee_copy (emp_id, emp_name, emp_no, job_code, hire_date)
values (301, '제우스', '051111-4567654', 'J5', current_date)

-- 컬럼을 제시할때 순서와 상관없이 해도됨.
-- 그러나 데이터값은 제시한 컬럼의 순서와 동일해야 됨.
insert into employee_copy (emp_name, hire_date, emp_id, job_code, emp_no)
values ('제우스', current_date , 302, 'J5', '051111-4567654')

-- 오류 not null인 job_code를 안넣어서
insert into employee_copy (emp_id, emp_name, emp_no, job_code, hire_date)
values (302, '황반가', '040111-4567654', current_date)

------------------------------------------------------------------------------------------------------------
/*
 3) insert into 테이블명(서브쿼리);
    values로 값을 직접 명시하는 대신에 서브쿼리로 조회된 결과값을 모두 insert함.
    여러 행도 가능.
*/
-- emp_01 테이블 생성
create table emp_01(
	emp_id varchar(3),
	emp_name varchar(20),
	dept_name varchar(35)
)

-- 전체 사원들의 사번, 이름, 부서명 조회
select emp_id, emp_name, dept_title
from employee
left join department on (dept_code = dept_id)

-- emp_01 테이블에 데이터 삽입
insert into emp_01
select emp_id, emp_name, dept_title
from employee
left join department on (dept_code = dept_id)

------------------------------------------------------------------------------------------------------------------
/*
 4) with절로 두 개 이상의 테이블에 한꺼번에 insert
    with절 안에서 insert, update, delete 같은 데이터 변경 작업도 수행 가능
    이를 CTE(data-modifying)라고 부름.
*/
-- 테이블 2개 생성
create table emp_dept
as select emp_id, emp_name, dept_code, hire_date
	from employee
	where 1=0;

create table emp_manager
as select emp_id, emp_name, manager_id
	from employee
	where 1=0;

-- 부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수사번 조회
select emp_id, emp_name, dept_code, hire_date, manager_id
from employee
where dept_code='D1';

with data_info as (select emp_id, emp_name, dept_code, hire_date, manager_id
					from employee
					where dept_code='D1'),
info1 as (
	insert into emp_dept (emp_id, emp_name, dept_code, hire_date)
	select emp_id, emp_name, dept_code, hire_date
		from data_info
)
/*
 테이블이 더 있으면 아래와 같이 계속 넣어주면 됨.
 info2 as (
	insert into emp_ETC (emp_id, emp_name, manager_id)
	select emp_id, emp_name, manager_id
		from data_info
)*/
insert into emp_manager(emp_id, emp_name, manager_id)
select emp_id, emp_name, manager_id from data_info;

--=======================================================================================================
/*
 2. update
    테이블에 기록되어 있는 기존 데이터를 수정하는 구문
    
    [표현식]
    update 테이블명
    set 컬럼명 = 바꿀값,
        컬럼명 = 바꿀값,
        ...
    [where 조건];    --> 주의: 생략하면 전체 모든 행의 데이터가 변경됨
*/
-- 테이블 생성
create table dept_copy
as select * from department;

-- D9 부서의 부서명을 '전략기획팀'으로 수정
update dept_copy
set dept_title = '전략기획팀'
where dept_id='D9';

commit;

-- 복사본 테이블 생성
create table emp_salary
as select emp_id, emp_name, dept_code, salary, bonus
from employee;

-- 지민재 사원의 급여를 200만원으로 변경
update emp_salary
set salary = 2000000
where emp_name = '지민재'

select * from emp_salary

-- 이정하 사원의 급여를 700만원으로 변경 후 보너스를 0.2로 변경
update emp_salary
set salary =7000000,
bonus=0.2
where emp_name ='이정하'

-- 전체 사원의 급여를 10% 인상
update emp_salary
set salary=salary *1.1

-- 박서준의 보너스를 0.5로
update emp_salary
set bonus =0.5
where emp_name ='박서준'

commit;
----------------------------------------------------------------------------------------------
/*
 - update시 서브쿼리 사용 가능
   
   [표현법]
   update 테이블명
   set 컬럼명 = (서브쿼리)
   where 조건;
*/

-- 정훈 사원의 급여와 보너스를 조정연사원의 급여와 보너스값으로 변경
-- 단일 컬럼 서브쿼리
update emp_salary
set salary = (select salary
				from emp_salary
				where emp_name ='조정연'), 
	bonus=(select bonus
				from emp_salary
				where emp_name='조정연')
where emp_name ='정훈'
select * from emp_salary

-- 다중열 서브쿼리
update emp_salary
set (salary, bonus)=(select salary, bonus
						from emp_salary
						where emp_name ='조정연')
where emp_name ='황승현';

-- 전지연, 선우진, 현준혁, 배윤서, 전재민 사원들의 보너스와 급여를 홍지유 사원과 같은 금액으로 변경
update emp_salary
set(salary, bonus) = (select salary, bonus
						from emp_salary
						where emp_name = '홍지유')
where emp_name in('전지연', '선우진', '현준혁', '배윤서', '전재민');

-- asia 지역에 근무하는 사원들의 보너스를 0.6으로 변경
-- asia 지역에서 근무하는 사원
select emp_id
from emp_salary
join department on(dept_code = dept_id)
join "location" on (location_id = local_code)
where local_name like 'ASIA2';

update emp_salary
set bonus=0.6
where emp_id in (select emp_id
					from emp_salary
					join department on(dept_code = dept_id)
					join "location" on (location_id = local_code)
					where local_name like 'ASIA2');
select * from emp_salary;
commit;

----------------------------------------------------------------------------------
-- update시에도 해당 컬럼에 대한 제약조건에 위배되면 안됨.
-- 사번이 200번인 사원의 이름을 null로 변경
update employee
set emp_name=null
where emp_id ='200';

-- primary key 오류
update employee
set emp_id=200
where emp_name ='이정하';

-- 외래키 오류
update employee
set dept_code='D0'
where emp_name ='이정하'

--===============================================================================================
/*
 3. delete
    테이블의 데이터를 행 단위로 삭제하는 구문
    
    [표현식]
    delete from 테이블명
    [where 조건];    -- 조건을 안넣으면 테이블 전체 행이 삭제됨
*/
delete from employee_copy;

rollback

delete from employee_copy
where emp_id ='201'

select * from employee_copy

-- 외래키때문에 삭제 거부됨
delete from department
where dept_id='D1'

/*
 * truncate: 테이블 전체 행을 삭제할 때
   delete보다 수행속도가 빠름
   rollback이 불가
   
   [표현식]
   truncate table 테이블명;
*/
truncate table emp_01;

rollback;
select * from emp_salary;
commit;