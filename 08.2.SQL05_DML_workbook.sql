create table tb_category(
	name varchar(10),
	use_yn char(1) default 'Y'
)

create table tb_class_type(
	no varchar(5) primary key,
	name varchar(10)
)

alter table tb_category add primary key (name)

alter table tb_class_type alter column name set not null

alter table tb_class_type alter column no type varchar(10)
alter table tb_class_type alter column name type varchar(20)

alter table tb_class_type rename column no to class_type_no
alter table tb_class_type rename column name to class_type_name

alter table tb_category rename column name to category_name

alter table tb_category rename constraint tb_category_pkey to pk_category_name
alter table tb_class_type rename constraint tb_class_type_pkey to pk_class_type_no

-- 임시 tb_department 테이블 생성 (외래키 연결을 받을 category 컬럼 포함)
CREATE TABLE tb_department (
    department_no VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(50),
    category VARCHAR(20)
);

insert into tb_category values('공학', 'Y')
insert into tb_category values('자연과학', 'Y')
insert into tb_category values('의학', 'Y')
insert into tb_category values('예체능', 'Y')
insert into tb_category values('인문사회', 'Y')

alter table tb_department
add constraint fk_department_category foreign key(category) references tb_category(category_name)

CREATE VIEW vw_학생일반정보 AS
SELECT student_no AS 학번,
       student_name AS 학생이름,
       student_address AS 주소
FROM tb_student;