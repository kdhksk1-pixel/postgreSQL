/*DDL 실습문제
도서관리 프로그램을 만들기 위한 테이블들 만들기
이때, 제약조건에 이름을 부여할 것.
       각 컬럼에 주석달기

1. 출판사들에 대한 데이터를 담기위한 출판사 테이블(TB_PUBLISHER)
   컬럼  :  PUB_NO(출판사번호) NUMBER -- 기본키(PUBLISHER_PK) 
	PUB_NAME(출판사명) VARCHAR2(50) -- NOT NULL(PUBLISHER_NN)
	PHONE(출판사전화번호) VARCHAR2(13) - 제약조건 없음

   - 3개 정도의 샘플 데이터 추가하기


2. 도서들에 대한 데이터를 담기위한 도서 테이블(TB_BOOK)
   컬럼  :  BK_NO (도서번호) NUMBER -- 기본키(BOOK_PK)
	BK_TITLE (도서명) VARCHAR2(50) -- NOT NULL(BOOK_NN_TITLE)
	BK_AUTHOR(저자명) VARCHAR2(20) -- NOT NULL(BOOK_NN_AUTHOR)
	BK_PRICE(가격) NUMBER
	BK_PUB_NO(출판사번호) NUMBER -- 외래키(BOOK_FK) (TB_PUBLISHER 테이블을 참조하도록)
			         이때 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정
   - 5개 정도의 샘플 데이터 추가하기


3. 회원에 대한 데이터를 담기위한 회원 테이블 (TB_MEMBER)
   컬럼명 : MEMBER_NO(회원번호) NUMBER -- 기본키(MEMBER_PK)
   MEMBER_ID(아이디) VARCHAR2(30) -- 중복금지(MEMBER_UQ)
   MEMBER_PWD(비밀번호)  VARCHAR2(30) -- NOT NULL(MEMBER_NN_PWD)
   MEMBER_NAME(회원명) VARCHAR2(20) -- NOT NULL(MEMBER_NN_NAME)
   GENDER(성별)  CHAR(1)-- 'M' 또는 'F'로 입력되도록 제한(MEMBER_CK_GEN)
   ADDRESS(주소) VARCHAR2(70)
   PHONE(연락처) VARCHAR2(13)
   STATUS(탈퇴여부) CHAR(1) - 기본값으로 'N' 으로 지정, 그리고 'Y' 혹은 'N'으로만 입력되도록 제약조건(MEMBER_CK_STA)
   ENROLL_DATE(가입일) DATE -- 기본값으로 SYSDATE, NOT NULL 제약조건(MEMBER_NN_EN)

   - 5개 정도의 샘플 데이터 추가하기


4. 어떤 회원이 어떤 도서를 대여했는지에 대한 대여목록 테이블(TB_RENT)
   컬럼  :  RENT_NO(대여번호) NUMBER -- 기본키(RENT_PK)
	RENT_MEM_NO(대여회원번호) NUMBER -- 외래키(RENT_FK_MEM) TB_MEMBER와 참조하도록
			이때 부모 데이터 삭제시 자식 데이터 값이 NULL이 되도록 옵션 설정
	RENT_BOOK_NO(대여도서번호) NUMBER -- 외래키(RENT_FK_BOOK) TB_BOOK와 참조하도록
			이때 부모 데이터 삭제시 자식 데이터 값이 NULL값이 되도록 옵션 설정
	RENT_DATE(대여일) DATE -- 기본값 SYSDATE

   - 3개 정도 샘플데이터 추가하기*/
--===================================================================================================
create table tb_publisher(
	pub_no numeric constraint publisher_pk primary key,
	pub_name varchar(50) constraint publisher_nn not null,
	phone varchar(13)
)

-- 컬럼 주석 달기
comment on column tb_publisher.pub_no is '출판사번호';
comment on column tb_publisher.pub_name is '출판사명';
comment on column tb_publisher.phone is '출판사전화번호';

-- 샘플 데이터 추가
insert into tb_publisher values
(1, '한빛미디어', '02-111-1111'),
(2, '이지스퍼블리싱', '02-222-2222'),
(3, '위키북스', '02-333-3333');
--===================================================================================================
create table tb_book(
	bk_no numeric constraint book_pk primary key,
	bk_title varchar(50) constraint book_nn_title not null,
	bk_author varchar(20) constraint book_nn_author not null,
	bk_price numeric,
	bk_pub_no numeric constraint book_fk references tb_publisher (pub_no) on delete cascade
);

-- 컬럼 주석 달기
comment on column tb_book.bk_no is '도서번호';
comment on column tb_book.bk_title is '도서명';
comment on column tb_book.bk_author is '저자명';
comment on column tb_book.bk_price is '가격';
comment on column tb_book.bk_pub_no is '출판사번호';

-- 샘플 데이터 추가
insert into tb_book values
(1, '혼자 공부하는 SQL', '우재남', 24000, 1),
(2, 'Do it! 데이터 분석', '김도현', 20000, 2),
(3, '스프링 부트 3', '이동욱', 30000, 3),
(4, '자바의 정석', '남궁성', 20000, 1),
(5, '점프 투 파이썬', '박응용', 18000, 2);
--===================================================================================================
create table tb_member(
	member_no numeric constraint member_pk primary key,
	member_id varchar(30) constraint member_uq unique,
	member_pwd varchar(30) constraint member_nn_pwd not null,
	member_name varchar(20) constraint member_nn_name not null,
	gender char(1) constraint member_ck_gen check(gender in('M', 'F')),
	address varchar(70),
	phone varchar(13),
	status char(1) default 'N' constraint member_ck_sta check(status in('Y', 'N')),
	enroll_date date default current_date constraint member_nn_en not null
);

-- 컬럼 주석 달기
comment on column tb_member.member_no is '회원번호';
comment on column tb_member.member_id is '아이디';
comment on column tb_member.member_pwd is '비밀번호';
comment on column tb_member.member_name is '회원명';
comment on column tb_member.gender is '성별';
comment on column tb_member.address is '주소';
comment on column tb_member.phone is '연락처';
comment on column tb_member.status is '탈퇴여부';
comment on column tb_member.enroll_date is '가입일';

-- 샘플 데이터 추가
insert into tb_member (member_no, member_id, member_pwd, member_name, gender, address, phone) values
(1, 'user01', 'pwd01', '홍길동', 'M', '강남구', '010-1111-2222'),
(2, 'user02', 'pwd02', '김영희', 'F', '서초구', '010-3333-4444'),
(3, 'user03', 'pwd03', '이철수', 'M', '성남시', '010-5555-6666'),
(4, 'user04', 'pwd04', '박민지', 'F', '연수구', '010-7777-8888'),
(5, 'user05', 'pwd05', '최민수', 'M', '해운대구', '010-9999-0000');
--===================================================================================================
create table tb_rent(
	rent_no numeric constraint rent_pk primary key,
	rent_mem_no numeric constraint rent_fk_mem references tb_member(member_no) on delete set null,
	rent_book_no numeric constraint rent_fk_book  references tb_book(bk_no) on delete set null,
	rent_date date default current_date
);

-- 컬럼 주석 달기
comment on column tb_rent.rent_no is '대여번호';
comment on column tb_rent.rent_mem_no is '대여회원번호';
comment on column tb_rent.rent_book_no is '대여도서번호';
comment on column tb_rent.rent_date is '대여일';

-- 샘플 데이터 추가
insert into tb_rent(rent_no, rent_mem_no, rent_book_no) values
(1, 1, 1),
(2, 2, 3),
(3, 4, 5);