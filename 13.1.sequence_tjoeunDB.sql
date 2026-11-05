/*
 <sequence>
 자동으로 번호 발생기켜주는 역할을 하는 객체
 정수값을 순차적으로 일정값씩 증가시키면서 생성해줌
 
 ex) 회원번호, 사원번호, 게시글 번호,...
 
 1. sequence 생성
    [표현식]
    create sequence 시퀀스명
    [start with 시작숫자]					-> 처음 발생시킬 시작값 지정(기본값1)
    [increament by 증가값]					-> 몇 씩 증가시킬것인지(기본값1)
    [maxvalue 숫자]						-> 최대값 지정(기본값 무지큼)
    [minvalue 숫자]						-> 최소값 지정(기본값1)
    [cycle | no cycle]					-> 값 순환 여부 지정(기본값 no cycle)
    [cache 미리 만들어둘 번호의 개수]			-> 미리 확보할 시퀀스 번호 개수
*/