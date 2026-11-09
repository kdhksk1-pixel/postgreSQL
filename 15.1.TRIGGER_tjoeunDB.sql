/*
	<TRIGGER>
	특정 테이블에 INSERT, UPDATE, DELETE등의 DML문에 의해 이벤트(변경사항) 발생시 자동으로 실행되는 객체
	자동으로 매번 실행할 내용을 미리 정의해 둘 수 있는 객체
	
	EX)
	회원 탈퇴시 탈퇴 회원 테이블에 자동으로 데이터 보관
	상품 입고시 재고수량 자동 증가
	상품 출고시 재고수량 자동 감소
	신고 횟수가 일정 기준을 넘으면 블랙리스트에 등록
	
	* 트리거 종류
		- 실행 시기에 따른 분류
		  > BEFORE TRIGGER : 명시한 테이블에 이벤트가 발생되기 전에 트리거 실행
		  > AFTER TRIGGER : 명시한 테이블에 이벤트가 발생한 후에 트리거 실행
		  > INSTEAD OF TRIGGER : 원래 작업 대신 트리거 실행(주로 VIEW)
		  
		- 실행 단위에 따른 분류
			> STATEMENT TRIGGER(문장 트리거) : 이벤트가 발생한 SQL문에 하나당 한번 실행
			> ROW TRIGGER(행 트리거) : 영향을 받는 각 행마다 한번 실행
															 (FOR EACH ROW 옵션 기술해야됨)
				 * old와 new											 
					 이벤트				old								new
					----------------------------------------------------------------------------
					insert	사용불가				새로 삽입되는 데이터
					update	변경전 데이터		변경후 데이터
					delete	삭제되는 데이터		사용불가	  
		  
	* 트리거 생성 방식
		1. 트리거 실행 함수 생성
			CREATE [OR REPLACE] FUNCTION 함수명()
			RETURN TRIGGER AS $$
			BEGIN
				실행내용
				RETURN NEW;
			[EXCEPTION]
			END;
			$$ LANGUAGE plpgsql;
			
		2. 트리거 생성
			CREATE [OR REPLACE] TRIGGER 트리거명
			BEFORE|AFTER  INSERT|UPDATE|DELETE ON 테이블명
			[FOR EACH ROW]
			EXECUTE FUNCTION 함수명();		  
		  
	* 트리거 삭제
	  DROP TRIGGER 트리거명 ON 테이블명;		  
*/
-- 1) 트리거 함수 생성
create function FN_TRG_01()
returns trigger as $$
begin
	raise notice '신입사원님 환영합니다!';
	return new;
end;
$$ language PLPGSQL;

-- 2)트리거 바인딩
create trigger TRG_01
after insert on employee
for each row
execute function FN_TRG_01();

insert into employee(emp_id, emp_name, emp_no, job_code, hire_date)
values ('500', '최미소', '111111-1111111', 'J1', current_date);

insert into employee(emp_id, emp_name, emp_no, job_code, hire_date)
values ('501', '페이커', '111112-1111112', 'J2', current_date);

--===========================================================================================================================
-- 1. 회원 탈퇴 시 자동 백업
-- 회원 테이블과 탈퇴회원을 넣을 테이블 생성
create table mem(
	mem_id numeric,
	mem_name varchar(20),
	hire_date date
);

create table mem_out(
	mem_id numeric,
	mem_name varchar(20),
	out_date date
);

insert into mem values(100, '구마유시', '2025-01-20');
insert into mem values(101, '케리아', '2024-11-25');
insert into mem values(102, '페이커', '2023-06-30');

-- 트리거 실행 함수 정의
create function  FM_MEM_DELETE()
returns trigger as $$
begin
	insert into mem_out
	values(old.mem_id, old.mem_name, current_date);

	return old;
end;
$$ language PLPGSQL;

-- 트리거 생성
create trigger TRG_MEM_DELETE
before delete
on mem
for each row
execute function FM_MEM_DELETE();

delete  from mem where mem_id = 100;

--===============================================================================================================================================
--2. 상품 입고 및 출고가 되면 재고 수량 자동 변경
-- 상품테이블(재고수량), 입고테이블, 출고테이블
create table TB_PRODUCT(
	pcode numeric primary key,
	pname varchar(30) not null,
	brand varchar(30) not null,
	stock_quant numeric default 0
);
-- 상품번호 시퀀스
create sequence SEQ_PCODE
start with 200
increment by 5;

-- 테이터 추가
insert into tb_product values(nextval('SEQ_PCODE'), '갤럭시 26', '삼성', default);
insert into tb_product values(nextval('SEQ_PCODE'), '아이폰 듀오', '애플', 10);
insert into tb_product values(nextval('SEQ_PCODE'), '갤럭시 폴드8', 'LG', 20);

select * from tb_product;

-- 2. 상품 입고 테이블
create table tb_prostock(
	tcode numeric primary key,
	pcode numeric references tb_product,
	tdate date,
	stock_count numeric not null,
	stock_price numeric not null
);

-- 시퀀스
create sequence SEQ_tCODE;

-- 3. 판매테이블
create table tb_prosale(
	scode numeric primary key,
	pcode numeric references tb_product,
	sdate date,
	sale_count numeric not null,
	sale_price numeric not null
);

-- 시퀀스
create sequence SEQ_sCODE;
--drop table tb_product cascade;

-- 200번 상품이 오늘날짜로 10개 입고
insert into tb_prostock
values(nextval('seq_tcode'), 200, current_date, 10, 2000000);

update tb_product
set stock_quant = stock_quant+10
where pcode =200;

-- 입고 테이블(tb_product)에 입고 되었을 때 트리거 정의
-- 함수 정의
create function fn_trg_stock()
returns trigger as $$
begin
	update tb_product
		set stock_quant = stock_quant+new.stock_count
	where pcode = new.pcode;
	return new;
end;
$$ language PLPGSQL;
--drop function if exists fn_trg_stock() cascade;

-- 트리거 생성
create trigger trg_stock
after insert on tb_prostock
for each row
execute function fn_trg_stock();

insert into tb_prostock
values(nextval('seq_tcode'), 230, current_date, 5, 1500000);

insert into tb_prostock
values(nextval('seq_tcode'), 235, current_date, 100, 2500000);

-- 입고 테이블(tb_prosale)에 입고 되었을 때 트리거 정의(tb_product에 update)
-- 함수 정의
create or replace function FN_TRG_SALE_AFTER()
returns trigger as $$
begin
	update TB_PRODUCT
		set STOCK_QUANT = STOCK_QUANT - new.sale_count
	where PCODE = new.PCODE;
	return new;
end;
$$ language PLPGSQL;

-- 트리거 정의
create trigger TRG_SALE
after insert on TB_PROSALE
for each row
execute function FN_TRG_SALE_AFTER();

insert into tb_prosale
values (nextval('seq_scode'), 200, current_date, 5, 2500000);

-- 출고 시 재고 수량이 부족할 경우 출고가 안되게
-- EXCEPTION
create function FN_TRG_SALE_BEFORE()
returns trigger as $$
declare
	scount numeric;     -- 기존의 재고 수량 넣을 변수
begin
	select stock_quant
	into strict scount
	from TB_PRODUCT
	where pcode = new.pcode;

	if (scount >= new.sale_count) then
		update TB_PRODUCT
			set stock_quant = stock_quant - new.sale_count
		where pcode = new.pcode
		return new;
	else
		raise exception '재고수량이 부족합니다';
	end if;
end;
$$ language PLPGSQL;

create trigger TRG_SALE_EX
before insert on TB_PROSALE
for each row
execute function FN_TRG_SALE_BEFORE();

insert into tb_prosale values(nextval('seq_scode'), 200, current_date, 10, 2500000);