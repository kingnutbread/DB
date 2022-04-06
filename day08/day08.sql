--day08

/*
    시퀀스(Sequence)
    : 자동적으로 일련번호를 발생시키는 도구
    
      테이블을 만들면 각각의 행을 구분할 수 있는 기본키가 거의 필수적이다.
      
      예를 들어
      사원을 관리하는 테이블을 만들면 각각의 사원을 구별할 수 있는 무언가가 있어야 하고
      emp 테이블에서는 사원번호(empno)를 이용해서 이것을 처리하고 있다.
      
      몇 개의 테이블은 이것을 명확하게 구분할 수 있지만 그렇지 못한 테이블도 있다.
      예를 들어 게시판 내용을 관리하는 테이블을 만들게 되면
      제목, 글쓴이, 내용, 작성일 ... 등이 있지만 
      이것 중에서 명확하게 한 글의 데이터를 구분할 수 있는 필드가 보이지 않는다.
     
      이런 경우 대부분 일련번호를 이용해서 이 역할을 하도록 하고 있다.
      따라서 일련번호는 절대로 중복되어선 안 되고 절대로 생략돼서도 안 된다.
      (Primary key == Unique + Not NULL이니까.)
      
      데이터베이스에 내용을 입력하는 사람이 실수할 수도 있다.
      
      시퀀스는 이런 문제점을 해결하기 위해서 나타난 개념으로 자동적으로 일련번호를 발생시키는 도구
      
      [방법] 
        1. 시퀀스를 만든다.
        2. 데이터베이스에 일련번호의 입력이 필요하면 시퀀스에게 일련번호를 만들어달라고 요청
            = 데이터 INSERT 시킬 때 일련번호 부분은 시퀀스에게 맡긴다는 뜻
      
      [시퀀스 생성 방법]
      
        [형식]
            
            CREATE SEQUENCE 시퀀스이름
                START WITH 숫자   ==> 발생시킬 일련번호의 시작값. 생략 시 1부터 시작
                INCREMENT BY 숫자 ==> 발생할 일련번호의 증가값. 생략 시 1  
                MAXVALUE    숫자  
                MINVALUE    숫자     ==> 발생시킬 일련번호의 최댓값과 최솟값. 생략 시 NO 사용(계속 증가)
                CYCLE 또는 NOCYCLE ==> 발생시킬 일련번호가 최댓값에 도달하면 다시 처음부터 시작할지 여부 지정하는 옵션
                                        생략하면 NOCYCLE
                CACHE 숫자(메모리에 저장할 갯수) 또는 NOCACHE  ==> 일련번호 발생 시 임시메모리를 사용할지 여부 지정하는 옵션 (10개)
                                        (미리 일정 갯수를 만들어놓고 메모리에 기억시킨 후 사용한다)
                                        사용 시 속도는 빨라지나 메모리가 줄어든다는 단점이 있다.
                                        사용 안 하면 속도는 느리지만 메모리가 줄지 않는다.
                                        생략 시 NOCACHE
                ;
    ---------------------
    
        [시퀀스 사용 방법]
            데이터 입력 시 자동으로 일련번호 발생하려 만든 것.
            따라서 주로 INSERT 명령에서 사용
            
            [형식]
                시퀀스이름.NEXTVAL
                
                [참고]
                    시퀀스가 마지막으로 만든 번호 확인하는 방법
                    : 시퀀스이름.CURRVAL
        
        [시퀀스 문제점]
            시퀀스는 테이블에 독립적.
            즉, 한 번 만든 시퀀스는 여러 테이블에서 사용 가능
            이 때 어떤 테이블에서 시퀀스를 사용하든지 항상 다음 일련번호를 만들어준다.
            
        [시퀀스 수정]
                
                    ALTER SEQUENCE 시퀀스이름
                        INCREMENT BY 숫자
                        MAXVALUE    숫자[또는 NOMAXVALUE]
                        MINVALUE    숫자[또는 NOMINVALUE]
                        CYCLE[ 또는 NOCYCLE ]
                        CACHE 숫자 [ 또는 NOCACHE ]
            
            [참고]
                시퀀스를 수정하는 경우 시작값은 수정 불가
                이미 발생한 번호이기 때문
                시작번호는 전에 만들어 놓은 시작번호가 자동으로 시작번호가 된다.
       
       [시퀀스 삭제]
            [형식]
                DROP SEQUENCE 시퀀스이름;
                
*/

-- 1에서 1씩 증가하는 시퀀스 test_seq 만들라. 단, 최댓값은 10으로 한다.
CREATE SEQUENCE test_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE    10
;
    
SELECT test_seq.CURRVAL FROM dual; -- => NEXTVAL 실행 시 바로 앞에서 만든 번호를 CURRVAL에 자동 기억.. 그래서 오류남

SELECT test_seq.NEXTVAL 다음번호, test_seq.CURRVAL 마지막번호 FROM dual;

SELECT test_seq.CURRVAL FROM dual;

SELECT test_seq.NEXTVAL FROM dual;

SELECT test_seq.CURRVAL FROM dual; -- => 중간에 누락되는 번호가 생길 수 있음.

--시퀀스 수정
ALTER SEQUENCE test_seq
    MAXVALUE    10
    CACHE 10  
;
-- 회원번호를 자동으로 만들어줄 시퀀스 MEMBSEQ 생성하라. 시작값은 1001, 증가값 1, 최댓값 9999, NOCYCLE
CREATE SEQUENCE membseq
    START WITH 1001
    INCREMENT BY 1
    MAXVALUE 9999
    NOCYCLE
    NOCACHE
;

--아바타 테이블 데이터 추가
INSERT INTO
    avatar
VALUES(
    10, 'noimage', 'noimage.jpg', 'noimage.jpg', '/img/avatar/', 6000, 'N', sysdate, 'Y' 
);

INSERT INTO
    avatar
VALUES(
    11, 'man1', 'img_avatar1.png', 'img_avatar1.png', '/img/avatar/', 11000, 'M', sysdate, 'Y' 
);

INSERT INTO
    avatar
VALUES(
    12, 'man2', 'img_avatar2.png', 'img_avatar2.png', '/img/avatar/', 8000, 'M', sysdate, 'Y' 
);

INSERT INTO
    avatar
VALUES(
    13, 'man3', 'img_avatar3.png', 'img_avatar3.png', '/img/avatar/', 8000, 'M', sysdate, 'Y' 
);

INSERT INTO
    avatar
VALUES(
    14, 'woman1', 'img_avatar4.png', 'img_avatar4.png', '/img/avatar/', 8000, 'M', sysdate, 'Y' 
);

INSERT INTO
    avatar
VALUES(
    15, 'woman2', 'img_avatar5.png', 'img_avatar5.png', '/img/avatar/', 8000, 'F', sysdate, 'Y' 
);

INSERT INTO
    avatar
VALUES(
    16, 'woman3', 'img_avatar6.png', 'img_avatar6.png', '/img/avatar/', 8000, 'F', sysdate, 'Y' 
);

--만들어 놓은 시퀀스를 사용해서 회원데이터를 입력하라
INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    1000, '이제리', 'jerryc', '12345', 'jerrc@githrd.com', '010-1111-1111', '11', 'M'
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    MEMBSEQ.nextval, '제니', 'jennie', '12345', 'jennie@githrd.com', '010-2222-2222', '14', 'F'
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    MEMBSEQ.nextval, '리사', 'lisa', '12345', 'lisa@githrd.com', '010-3333-3333', '15', 'F'
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    MEMBSEQ.nextval, '로제', 'rose', '12345', 'rose@githrd.com', '010-4444-4444', '16', 'F'
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    MEMBSEQ.nextval, '지수', 'jisoo', '12345', 'jisoo@githrd.com', '010-5555-5555', '16', 'F'
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    MEMBSEQ.nextval, '왕밤빵', 'kingnut', '12345', 'kingnut@githrd.com', '010-6666-6666', '12', 'M'
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    MEMBSEQ.nextval, '박소연', 'soyeon', '12345', 'park@githrd.com', '010-7777-7777', '16', 'F'
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    MEMBSEQ.nextval, '이주연', 'juyeon', '12345', 'lee@githrd.com', '010-8888-8888', '11', 'M'
);

COMMIT;

-------------------

--방명록 테이블 생성
CREATE TABLE guestboard(
    gno NUMBER(4)
        CONSTRAINT GB_NO_PK PRIMARY KEY,
    writer NUMBER(4)
        CONSTRAINT GB_WRITER_FK REFERENCES MEMBER(MNO)
        CONSTRAINT GB_SRITER_UK UNIQUE
        CONSTRAINT GB_WRITER_NN NOT NULL,
    body VARCHAR2(4000)
        CONSTRAINT GB_BODY_NN NOT NULL,
    wdate DATE DEFAULT sysdate
        CONSTRAINT GB_WDATE_NN NOT NULL,
    isshow CHAR(1) DEFAULT 'Y'
        CONSTRAINT GB_SHOW_CK CHECK(isshow IN('Y', 'N'))
        CONSTRAINT GB_SHOW_NN NOT NULL
);

--게시글 등록에 사용할 글번호를 생성해주는 시퀀스 GBRDSEQ 만들라. 시작번호 1001, 최댓값 9999, NOCYCLE, NOCACHE
CREATE SEQUENCE gbrdseq
    START WITH  1001
    MAXVALUE    9999 -- MINVALUE는 CYCLE일 때만 작성
;

--방명록에 gbrdseq를 이용해서 글을 등록해보자
INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.nextval, 1000, '배가 고파요. 빨리 밥 먹고 싶어요.'
);

INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.nextval, 1006, '오늘 점심은 생선까스입니다.'
);

INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.nextval, 1001, '빛이 나는 솔로'
);

INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.nextval, 1002, '라리사라리사라리사라라라'
);

INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.nextval, 1003, '로제파스타 10인분'
);

INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.nextval, 1005, '왕밤빵왕밤빵왕밤빵'
);

INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.nextval, 1005, '왕밤빵왕밤빵왕밤빵'
);-- => UNIQUE 제약 조건에 위배돼서 오류남..

--방명록에서 글번호, 작성자아이디, 작성자 성별, 작성자 아바타 저장이름, 글내용, 작성일 조회
SELECT
    gno 글번호, id 아이디, m.gen 성별, savename 아바타저장이름, body 글내용, TO_CHAR(wdate, 'YYYY"년 "MM"월 "DD"일 "') 작성일
FROM
    guestboard g, member m, avatar a
WHERE  
    g.writer = m.mno
    AND m.avt = a.ano
;

SELECT * FROM member;

-- 'jisoo' 그리고 'juyeon' 아이디만 알고 있다는 가정 하에 방명록에 글을 등록하라

--지수
INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.nextval, 
    (SELECT
        mno
     FROM
        member
     WHERE
        id = 'jisoo'
     ),
    '오늘은 날씨가 좋아요.'
                
);

--주연
INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.nextval,
    (SELECT
        mno
     FROM
        member
     WHERE
        id = 'juyeon'
     ),
     '생선까스는 맛이 없었습니다.'
);

----------------------

/*
    <인덱스(INDEX)> = 찾아보기..
    : B-Tree 기법으로 색인을 만들어 SELECT 빠르게 처리할 수 있도록 하는 것
    
    [참고]
        인덱스 만들면 안 되는 경우
            1. 데이터 양 적은 경우
               오히려 속도가 떨어진다.
               시스템에 따라서 다르나 최소 몇십만 개 이상의 데이터가 있는 경우에만 효과 있음
        
            2. 데이터 입출력 빈번
               데이터 입력될 때마다 계속해서 색인(인덱스)을 수정해야 하므로 오히려 느림
    
    [참고]
        인덱스 만들면 좋은 경우
            1. JOIN 등이 많이 사용되는 필드가 존재하는 경우
            
            2. NULL 값이 많이 존재하는 경우
            
            3. WHERE 조건절에 많이 사용되는 필드가 존재하는 경우
    
    [참고]
        제약조건을 추가할 때 기본키, 유일키를 부여하면
        자동적으로 해당 필드는 인덱스가 만들어진다.
        별도로 인덱스 만들 필요 없음
    
    [인덱스 만드는 방법]
        [형식]
            1. 일반 인덱스(NON UNIQUE INDEX)
            
                CREATE INDEX 인덱스이름
                ON
                    테이블이름(인덱스에 사용할 필드 이름);
            
                [참고]
                    일반 인덱스는 데이터가 중복돼도 상관없다.
            
            2. UNIQUE INDEX
                : 인덱스용 데이터가 반드시 UNIQUE 하다는 보장이 있는 경우(필드에 U 제약조건 있음)에 한해서
                  인덱스 만드는 방법
                  
                CREATE UNIQUE INDEX 인덱스이름
                ON
                    테이블이름(필드이름);  
                
                [참고]
                    이 때 지정한 필드의 내용은 반드시 유일하다는 보장이 있어야 한다.
                
                [장점]
                    일반 인덱스보다 처리 속도가 아주 빠르다.
                    이진 검색을 사용하기 때문..
            
            3. 결합 인덱스
                : 여러 개의 필드를 결합해서 하나의 인덱스를 만드는 방법
                  여러 개의 필드의 조합이 반드시 유일해야 한다는 전제조건이 있다.
                  
                  즉 하나의 필드만 가지고는 유니크 인덱스를 만들지 못하는 경우
                  여러 개의 필드를 합쳐서 유니크 인덱스를 만들어서 사용하는 방법
                
                CREATE UNIQUE INDEX 인덱스이름
                ON
                    테이블이름(필드이름, 필드이름, ...);
                    
                [참고]
                    복합키 제약조건 추가하기
                    
                    CREATE TABLE 테이블이름(
                        필드1 데이터타입(길이),
                        필드1 데이터타입(길이),
                        필드1 데이터타입(길이),
                        ...
                        CONSTRAINT 제약조건이름 PRIMARY KEY(필드이름, 필드이름2)
                    );
            
            4. 비트 인덱스
                : 주로 그 안에 들어있는 데이터가 몇 가지 중 하나인 경우에 많이 사용되는 방법
                  gen 필드에는 F, M, N만 입력 가능
                  deptno 필드에는 10, 20, 30, 40만 입력 가능
                  위 사례가 내부적으로 데이터를 이용해서 인덱스를 만들어서 사용하는 경우
                  
                CREATE BITMAP INDEX 인덱스이름
                ON 
                    테이블이름(필드이름); => 도메인(데이터의 범위)이 정해져 있는 경우에 한해서만        
*/

--회원 테이블의 이름을 이용해서 인덱스를 만드세요
CREATE INDEX name_idx
ON
    member(name)
;

-----------

/*
    <인라인 뷰(InLine View)>
    : 조회질의명령(SELECT 질의명령)을 내리면 발생하는 결과
    
     즉, 뷰는 인라인 뷰 중에서 자주 사용하는 인라인 뷰를 등록해서 사용하는 개념..
     매번 질의명령 만들지 않고 데이터베이스에 만들어 놓는 게 편하기 때문
     
     그런데 인라인 뷰는 하나의 가상의 테이블이다.
     (테이블이란 레코드(행)와 필드(컬럼, 열)로 구성된 데이터를 입력하는 단위)
     테이블이 구조를 갖고 있기에 인라인 뷰는 하나의 테이블로 재사용이 가능하다. (FROM절 안에 들어갈 수 있다.)
     즉, 테이블을 사용해야 하는 곳에는 인라인 뷰를 대신 사용할 수 있다.
     
     
    [사용 목적]
        실제 테이블에 존재하지 않는 데이터를 추가해서 사용해야 하는 경우 유용하다.
        
    [참고]
        ROWNUM
        : 데이터가 조회된 순서를 표시하는 가상의 필드(의사컬럼)
    
*/

-- 인라인 뷰의 결과 중 회원번호와 이름만 꺼내라
SELECT
    mno, name
FROM
    (SELECT * FROM member) -- => 인라인 뷰
;

-- 이 경우 에러 발생 : 인라인 뷰에 joindate라는 필드는 없으니까..
SELECT
    mno, id, name, joindate
FROM
    (SELECT
        mno, id, name, mail
     FROM
        member
     )
;

SELECT
    *
FROM
(
    SELECT
        ROWNUM rno, g.*
    FROM

        (SELECT
            gno, writer, body, wdate
        FROM
            guestboard
        WHERE
            isshow = 'Y' -- => WHERE절이 참이면 SELECT 절 표시한다.
        ORDER BY
            wdate DESC) g
)
WHERE
    rno BETWEEN 4 AND 6
;

SELECT
        ROWNUM rno, g.*
FROM

        (SELECT
            gno, writer, body, wdate
        FROM
            guestboard
        WHERE
            isshow = 'Y' -- => WHERE절이 참이면 SELECT 절 표시한다.
        ORDER BY
            wdate DESC) g
WHERE
    ROWNUM BETWEEN 1 AND 3 -- => 4 AND 6은 안 됨.
;

--회원 테이블의 회원들을 조회하는데 ROWNUM 기준으로 4 ~ 6 회원만 조회하라. 단, 정렬은 이름 기준 내림차순
SELECT
    *
FROM
    (SELECT
        ROWNUM rno, g.*
    FROM
        (SELECT
            mno, id, name, mail, tel, m.gen, joindate, avt, savename
        FROM
            member m, avatar a
        WHERE
            avt = ano
        ORDER BY
            name DESC) g
    )
WHERE
    rno BETWEEN 4 AND 6
;