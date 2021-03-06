--day02

/*
    오라클이 데이터를 보관하는 방법
    : 테이블(Entity, 개체) 단위로 보관
    
        ERD (Entity Relation Diagram)
            :   테이블 간의 관계를 도식화한 다이어그램
            
    오라클은 테이블들 간의 관계를 형성해서 데이터를 저장
    이런 종류의 데이터베이스 관리시스템을 
            RDBMS(개체들 간 관계를 형성해서 데이터 관리하는 시스템, 관계형 데이터베이스 관리 시스템)라고 한다.
            
            
        +)  
            정형 데이터베이스 : 데이터 추가 시 데이터의 형태가 갖춰져야 추가되는 데이터베이스
                
                사원번호 사원이름 직급 널 입사일 급여 널 널
                                
                                분산저장, 분산처리 불가 (중앙집중식)
            
            비정형 데이터베이스 : 형태가 갖춰지지 않아도 저장할 수 있는 데이터베이스
                               
                                분산저장, 분산처리 가능
                                보안문제, 성능 저하...
                                
                                NoSQL
                                    MongoDB
                                    
                                NewSQL
   
    테이블 : 필드(컬럼, 열)와 레코드(ROW, 행)로 구성된 데이터를 보관하는 가장 작은 단위
    
        필드 : 같은 개념의 데이터 모임(컬럼, 열, 칸...)
            필드에는 그 항목을 구분하기 위한 이름이 부여되어 있다.
            이것을 우리는 필드이름이라고 부른다.
            
        레코드 : 같은 목적을 가진 데이터 모임(행, 로우...)
            레코드는 각 행을 구분하는 방법이 존재하지 않는다.
            
       +) 우리가 오라클에 접속하게 되면 오라클이 접속자에게 메모리를 할당
          이때 이 메모리가 할당된 상태를 "세션이 하나 열렸다"라고 표현한다.
          오라클에서는 접속을 세션으로 표현한다.
          오라클에서는 같은 계정으로 여러 컴퓨터에서 동시 접속 가능
          이때 확보된 메모리 공간은 서로 공유가 안 된다.
            
            따라서 접속한 사람은 확보한 공간에서만 작업(DML 명령)하게 되고
            최종적으로 데이터베이스에 적용시키는 작업(DCL 명령)은 별도로 명령해야 한다.(TCL 명령) 
*/

-- 내가 접속한 계정 안에 테이블 이름 조회
SELECT
    tname
FROM
    tab
;

/*
    오라클은 명령, 테이블이름, 필드이름 구분 시 대소문자 구분하지 않는다.
    데이터는 대소문자 구분해야 한다.
*/

-----------

/*
    조회된 데이터 중 중복된 데이터를 한 번만 조회되도록 하는 방법
    = 같은 데이터는 한 번만 출력되도록 하는 방법
    
    +)주의사항
        이 명령은 질의명령에서 한 번만 사용해야 하고 
        조회된 데이터의 각 행들이 같은 경우에만 적용된다.
        = 각 필드의 데이터들 마저 동일해야 중복된 데이터로 간주한다.
        
    [형식]
        SELECT
            DISTINCT    컬럼(필드)이름
        FROM
            테이블이름
        ;
*/

--사원들의 직급 조회. 단, 중복된 직급은 한 번만 출력
SELECT
    DISTINCT job, ename
FROM
    emp
;

--사원들의 직급과 부서 번호를 조회하는데 중복된 데이터는 한 번만 출력되도록 하라
SELECT
    DISTINCT job, deptno
FROM
    emp
;

/*
    원칙적으로 데이터를 조회할 땐 조회할 필드의 이름을 정확하게 나열해서 조회해야 함
    간혹 모든 필드(정보)를 보고 싶은 경우 필드 이름을 나열하는 대신 
    ' * ' 기호를 사용해서 대신하는 경우가 있다.
    하지만 실무에서는 절대로 사용하면 안 되는 방법이다.
    
        * : 자바와 마찬가지로 모두의 의미 
*/
---------
/*
    질의 명령 안에 연산식을 포함할 수 있다. 
    연산식이 포함되면 연산된 결과가 출력된다.
    이때 출력되는 필드의 이름은 연산식이 된다.
*/

/*
    NUMBER : 정수, 실수 구분 안 함. 
*/

--사원들의 이름, 급여, 10% 인상된 급여 조회
SELECT--데이터 꺼내오기만 하는 명령(수정 불가)
    ename AS 이름, sal AS 원급여, sal * 1.1 "인상 급여" -- 공백이 포함된 별칭은 큰따옴표로 감싼다
FROM
    emp
;

/*
    DUAL 테이블
    : 조회 시 테이블에 저장된 데이터 중 필터링 해서 그 결과를 보여준다.
      데이터 자체를 조회 시(SELECT 절에 데이터 나열 시) 조회되는 데이터는 
      필터링된 데이터 갯수 만큼 출력될 것이다.
      
      이때 간단한 계산식의 결과만 원하는 경우 이렇게 조회하면 불편하다.
      따라서 이런 경우 사용할 수 있도록 만들어 제공하는 테이블이 있는데
      그 테이블이 바로 " DUAL 테이블 " 이다.
      
      하지만 이 테이블은 물리적으로 저장되어 있는 테이블은 아니다.
      오라클 시스템 자체가 제공해주는 가상의 테이블이다.
      이 테이블은 한 개의 row만 가지고 있는 테이블이다.
      
*/
SELECT
    '제니'
FROM
    emp
;-- ==>이 질의명령은 각 데이터에서 '제니'를 조회하라는 명령과 같은 의미

SELECT
    '제니'
FROM
    dual
;

--현재 시간을 조회해보자
SELECT
    sysdate
FROM
    dual
;

/*
    시스템의 현재 시간을 반환해주는 연산자
        
        sysdate
        
    오라클에서는 자바와 마찬가지로 날짜와 시간을 분리해서 기억하지 않는다.
*/

/*
    <오라클에서 사용하는 산술 연산자>
    +
    -
    *
    /
*/
SELECT
    10 / 3 -- 오라클에서는 정수의 연산 결과가 실수가 될 수 있다.
FROM
    dual
;

--------

/*
    NULL 데이터
    : 필드 안에는 데이터가 보관되어야 하는데, 없는 정보는 데이터가 없을 수 있다.
      이처럼 필드의 데이터가 없는 상태를 NULL 데이터라고 한다.
      
      0은 0이라는 데이터가 결정된 상태로 NULL과 다르다.
      
     
      +) NULL 데이터는 모든 연산에서 제외된다.
        => NULL 데이터로 연산하는 데이터는 조회에서 제외된다.
      
      
      +)
      NVL 함수
        [형식]
            NVL(필드이름/필드계산식, NULL일 경우 대신할데이터)
        
        [의미]
            NULL 데이터를 강제로 특정 데이터로 바꾸어주는 명령
            따라서 특정 데이터로 변경하게 되면 연산에 포함될 수 있다.
*/

-- 사원들의 상사번호에 10000을 추가해서 이름, 상사번호 조회
SELECT
    ename, mgr + 10000 상사번호
FROM
    emp
;

--사원들의 연봉을 계산해서 이름, 입사일, 연봉(급여 * 12 + comm) 조회. (comm 없는 사원은 0으로 계산)
SELECT
    ename 이름, hiredate 입사일, sal * 12 + comm 연봉
FROM
    emp
;

--NVL 함수 사용
SELECT
    ename 이름, hiredate 입사일, (sal * 12 + NVL(comm, 0)) 연봉
FROM
    emp
;

SELECT
    ename 이름, hiredate 입사일, NVL(sal * 12 + comm, sal * 12) 연봉
FROM
    emp
;

-------------------------------

/*
    <결합연산자> = 결합된 결과는 문자열로 만들어진다.
    ==> 오라클 역시 문자열을 결합하여 출력 가능
        이 때는 두 개의 필드를 결합할 수도 있고 
        데이터를 결합할 수도 있다.
*/
SELECT
    10 || 20
FROM
    dual
;

--사원번호와 사원이름을 조회하는데, 형식은 사원번호 - 사원이름 으로 하라.
SELECT
    empno || ' - ' || ename 사원
FROM
    emp
;

--사원번호, 이름 조회하는데 0000번, 홍길동 님 의 형식으로 조회하라
SELECT
    empno || '번' 사원번호, ename || ' 님' 이름
FROM
    emp
;

-----------------------

/*
    <조건조회>
    
        [형식]
            SELECT
                필드이름들
            FROM
                테이블이름
            WHERE
                조건식
            ;
            
        +) NULL 검색
            : NULL 데이터는 모든 연산에서 제외된다.
              따라서 비교 연산자로 NULL 데이터를 비교할 수 없다.
              
              NULL 데이터는
                IS NULL, IS NOT NULL 을 사용해서 비교해야 한다.
*/

--커미션이 없는 사원들의 이름, 급여, 커미션 조회
SELECT
    ename, sal, comm
FROM
    emp
WHERE
    comm = NULL--NULL 데이터는 연산에서 제외되기 때문에 결과가 안 나옴
;

SELECT
    ename, sal, comm
FROM
    emp
WHERE
    comm IS NULL
;

-- 커미션이 있는 사원들의 사원번호, 이름, 급여, 커미션 조회(단, 커미션은 100을 추가해서 조회)
SELECT
    empno 사원번호, ename 이름, sal 급여, comm + 100 커미션
FROM
    emp
WHERE
    comm IS NOT NULL-- NOT comm IS NULL
;

-----------

/*
    <원하는 형태로 조회된 결과 정렬하기>
    원칙적으로 DB는 종류에 따라 나름의 기준을 가지고 데이터를 조회한다.
    (반드시 입력 순서대로 조회되는 것은 아니라는 것)
    오라클은 내부적으로 인덱스를 이용해서 출력 순서를 조절하고 있다.
    출력 순서는 모를 수 있다.
    
    조회된 결과를 원하는 순서대로 정렬하도록 지정해야 한다.
        [형식]
            SELECT
                필드이름 ...
            FROM
                테이블이름
            WHERE
                조건식
            ORDER BY
                필드이름 [ASC || DESC], 필드이름 [ASC || DESC] ...
            ;
            
            +) ASC : 오름차순 정렬
               DESC : 내림차순 정렬
               

            +) 테이블 구조를 조회해보는 명령
    
                describe    테이블이름;
                desc    테이블이름;

*/

--사원의 이름, 직급, 입사일을 조회. (이름 순으로 내림차순 정렬)
SELECT
    ename, job, hiredate
FROM
    emp
ORDER BY
    ename DESC
;

--위 문제를 입사일 기준 오름차순 정렬
SELECT
    ename, job, hiredate, sal
FROM
    emp
ORDER BY
    hiredate ASC
;

/*
    오름차순 정렬 시 ASC 생략 가능 
*/

--사원들의 사원이름, 급여, 부서번호 조회(부서번호 기준 오름차순 정렬 후, 같은 부서의 경우 급여 내림차순 정렬)
SELECT
    ename 이름, sal 급여, deptno 부서번호
FROM
    emp
ORDER BY
    deptno ASC, sal DESC
--    부서번호 ASC, 급여 DESC => 조회된 결과 가지고 정렬하기 때문에 같은 의미
;

/*
    윗 절들의 실행결과를 가지고 정렬하는 것
    따라서 ORDER BY 절은 다른 절들 이후에 기술돼야 한다.
*/

/*
    필드 이용한 연산 결과도 정렬에 사용 가능
*/
/*
    문자열의 길이를 알려주는 함수
    : LENGTH() => 문자열의 문자열 수 반환
*/

--사원이름, 직급, 급여 조회. (단 이름 길이가 짧은 사람이 먼저 출력, 같은 길이면 오름차순 정렬
SELECT
    ename 이름, job 직급, sal 급여
FROM
    emp
ORDER BY
    LENGTH(ename) ASC, ename ASC 
;

SELECT
    LENGTH('윤아') 문자수, LENGTHB('윤아') 바이트수
FROM
    dual
;    

/*
    <집합 연산자>
    두 개 이상의 SELECT 질의명령을 이용해서 그 결과의 집합을 얻어내는 방법
    (되도록이면 안 쓰는 게 좋다)
    
        [형식]
            SELECT ....
            집합연산자
            SELECT ....;
        
        [종류]
            UNION : A + B (합집합) => 두 가지 질의명령 결과를 하나로 합쳐 조회
            
            UNION ALL   : UNION(중복데이터 1번 출력) + INTERSECT
                          = 같은 합집합이나, 중복데이터 모두 출력
            
            INTERSECT : A와 B의 교집합
                        조회 질의명령 결과 중 양쪽 모두 존재하는 결과만 출력
            
            MINUS : A - B (차집합)
                    앞의 질의명령 결과에서
                    뒤의 질의명령 결과에 포함된 데이터를 뺀 결과 출력
                    
        +)  공통적인 특징
        
            1. 두 SELECT 질의명령에서 나온 결과는 같은 필드의 갯수를 가져야 한다.
            2. 두 질의명령의 결과는 같은 형태의 필드이면 된다.(데이터 타입만 같으면 된다.)
            
*/                  
SELECT
    ename 사원이름, sal 급여
FROM
    emp
UNION
SELECT
    job 직급, deptno 부서번호
FROM
    emp
;

/*
    <함수(Function)>
    : 데이터를 가공하기 위해 오라클이 제시한 명령들
    
        DBMS는 데이터베이스 밴더(오라클, MYSQL...)들마다 다르다.
        함수 부분은 DBMS들마다 매우 다르다.
        
        [종류]
        
        1. 단일행 함수
        
        : 한 줄 한 줄 마다 매번 명령이 실행되는 함수
          따라서 단일행 함수의 결과는 출력되는 데이터의 갯수와 동일
          
        2. 그룹 함수
        
        : 여러 행이 모여서 한 번만 실행되는 함수
          따라서 그룹 함수의 결과는 오직 1개
          집계 함수들이 그룹 함수에 해당
          max(), min(), sum(), avg(), count()...
    
          
    * [주의사항]
        단일행 함수, 일반필드와 그룹 함수는 절대로 같이 사용할 수 없다.
*/

--사원들 이름, 이름의 문자 수 조회
SELECT
    ename 사원이름, LENGTH(ename) 이름문자수 
FROM
    emp
;

--10번 부서의 사원들의 사원 수를 조회
SELECT
    count(*) 사원수
FROM
    emp
WHERE
    deptno = 10
;

--커미션이 없는 사원들의 수를 조회
SELECT
    count(*) "커미션 없는 사원 수"
FROM
    emp
WHERE
    comm IS NULL
;

--null 데이터는 모든 연산에서 제외된다.
--따라서 함수에서도 제외된다.
SELECT
    (count(*) - count(comm)) "커미션 없는 사원 수"
FROM
    emp
;

------------------

/*
    <단일행 함수>
        
        * 숫자 타입을 바로 날짜 타입으로 변환할 수는 없다.
        
        숫자  <------->   문자  <---------->   날짜

        +) 자릿수는 소수 이하 자릿수 의미, 음수 형태 입력 시 소수 이상 자릿수 의미

        [종류]
        
        1. 숫자함수
            : 데이터가 숫자인 경우에만 사용할 수 있는 함수
        
            1) ABS() : 절대값 구해주는 함수
                [형식]
                    ABS(데이터/필드/연산식)
                    
            2) ROUND() : 반올림 함수(자릿수 지정 가능)
                [형식]
                    ROUND(데이터[, 자릿수])
                    
            3) FLOOR() : 버림 함수(소수점 이하 무조건 버림, 자릿수 지정 불가)
                [형식]
                    FLOOR(데이터/필드/연산식)
                    
            4) TRUNC() : 자릿수 이하 버림 (자릿수 지정해서 버림)
                [형식]
                    TRUNC(데이터[, 자릿수])
                
            5) MOD() : 나머지 구하는 함수
                [형식]
                    MOD(데이터, 나눌 수)
            
            
        2. 문자함수
            : 
        
        3. 날짜함수
        
        +) 오라클의 데이터 타입
        
           CLOB : 문자데이터를 4기가까지 저장할 수 있는 타입
           BLOB : 바이너리코드를 4기가까지 저장할 수 있는 타입 
           
           문자열 데이터 타입의 최대 크기는 4KB
*/
SELECT
    ABS(-3.14) pi
FROM
    dual
;

-- 사원들의 급여를 15% 인상한 금액을 조회하라
-- 단, 소수점 이하는 소수 첫째자리에서 반올림하고 조회하라
SELECT
    ename 사원이름, sal 원급여, sal * 1.15 계산값, ROUND(sal * 1.15, -2) 인상급여, FLOOR(sal * 1.15) 버림함수, 
    TRUNC(sal * 1.15, -2) 자릿수버림
FROM
    emp
;

SELECT
    MOD(10, 3) "10을 3으로 나눈 나머지"
FROM
    dual
;

SELECT
    TRUNC(3.14)
FROM
    dual
;

--급여가 짝수인 사원들 이름, 직급, 급여 출력
SELECT
    ename 이름, job 직급, sal 급여
FROM
    emp
WHERE
    MOD(sal, 2) = 0
;

------------


/*
    2. 문자 함수
    
        1) LOWER() : 소문자로
        
        2) UPPER() : 대문자로
        
        3) INITCAP() : 첫문자만 대문자로, 나머지는 소문자로 변환
        
        4) LENGTH()/ LENGTHB()
            [형식]
                LENGTH(문자열데이터)
            
            [의미]
                LENGTH() : 문자열의 문자 수 반환
                LENGTHB() : 문자열의 바이트 수 반환
        
        5) CONCAT() : || (결합연산자)와 같은 기능
            [형식]
                CONCAT(데이터1, 데이터2)
        
        6) SUBSTR() / SUBSTRB() : 문자열 중에서 특정 위치의 문자열만 따로 추출해서 반환해주는 함수(자바의 substring과 유사)
            [형식]
                SUBSTR(데이터, 시작위치, 꺼낼갯수)
                
                위치값은 DB에서는 1부터 시작한다.
                갯수 생략 가능, 이 때 시작위치부터 문자열의 끝부분까지 전부 꺼내오게 된다.
                시작위치를 음수로 기입하는 경우는 문자열 뒤에서부터의 자릿수를 의미
        
        7) INSTR() / INSTRB() : 문자열 중에서 원하는 문자열이 몇번째 글자에 있는지 알려주는 함수 (자바의 indexOf와 유사)
            [형식]
                INSTR(데이터1, 데이터2[, 시작위치, 건너뛸 횟수(출현횟수)])
        
        
        8) LPAD() / RPAD() : 문자열의 길이를 지정한 후 문자열을 만드는데 남는 공간은 지정한 문자로 채워주는 함수
                             둘의 차이점은 남는 공간을 왼쪽(LPAD)에 채울지 오른쪽(RPAD)에 채울지 결정한다는 것
                [형식]
                    LPAD(데이터, 만들길이, 채울문자) 
*/  

SELECT
    LOWER(ename) 소문자이름, UPPER(LOWER(ename)) 대문자이름, INITCAP(ename) "첫글자만 대문자"
FROM
    emp
;

SELECT
    INITCAP('hello jennie!')
FROM
    dual
;

--사원들의 이름, 직급, 급여 조회
-- [형식] Mr.SMITH     CLERTK 직급       800 달러
SELECT
    CONCAT('Mr.', ename) 이름, CONCAT(job, ' 직급') 직급, CONCAT(sal, ' 달러') 급여
FROM
    emp
;

SELECT
    SUBSTR('Hello Wrold!', 1, 5) 문자열추출
FROM
    dual
;

SELECT
    SUBSTR('Hello Wrold!', -6, 6) 문자열추출
FROM
    dual
;

SELECT
    INSTR('hello honggildong! hi', 'h', 2, 2)
FROM
    dual
;

-- 사원 이름 조회하는데 남는 공간에 *을 채워서 이름을 10글자로 만들라
SELECT
    LPAD(ename, 10, '*') 오른쪽정렬, RPAD(ename, 10, '*') 왼쪽정렬
FROM
    emp
;

-----------------------
-- 사원들의 이름을 앞 두글자만 표시하고 나머지는 *로 표시하라
SELECT
    SUBSTR(ename, 1, 2) 앞두글자, RPAD(SUBSTR(ename, 1, 2), LENGTH(ename), '*') 꺼내온이름, -- 오라클은 변수가 없어서 중첩 불가피
    ename 원이름
FROM
    emp
;

/*
    문제1]   
        사원이름이 5글자 이하인 사원들의 사원번호, 이름, 이름글자수, 직급, 급여 조회
        출력은 글자수가 작은 사원부터 정렬
*/
SELECT
    empno 사원번호, ename 이름, LENGTH(ename) 글자수, job 직급, sal 급여 
FROM
    emp
WHERE   
    LENGTH(ename) <= 5
ORDER BY
    LENGTH(ename)
;


/*
    문제2]
        사원이름 뒤에 '사원'을 붙여서 사원이름, 직급, 입사일 조회
*/
SELECT
   CONCAT(ename, ' 사원') 이름, job 직급, hiredate 입사일
FROM
    emp
;
/*
    문제3]
        사원 이름의 마지막 글자가 'N'인 사원들의 이름, 입사일, 부서번호 조회
        부서번호 순으로 오름차순 정렬
        같은 부서는 이름순으로
*/
SELECT
    ename, hiredate, deptno
FROM
    emp
WHERE
    SUBSTR(ename, -1, 1) = 'N'
ORDER BY
    deptno, ename
;

/*
    문제4]
        사원 이름 중 'a'가 존재하지 않는 사원의 정보를 조회
*/
SELECT
    empno 사원번호, ename 이름, job 직급, hiredate 입사일, sal 급여
FROM
    emp
WHERE
    INSTR(ename, 'a') = 0 -- 데이터베이스에서는 위치값이 1부터 시작, 따라서 0이 나온다는 건 포함 안 돼있다는 말과 같음
;

SELECT
    empno 사원번호, ename 이름, job 직급, hiredate 입사일, sal 급여
FROM
    emp
WHERE
    ename NOT LIKE'%a%'
;


/*
    문제5]
        사원 이름 중 뒤 2글자만 남기고 앞글자는 모두 '#'으로 대체해서
        이름, 입사일, 급여 조회
*/
SELECT
    ename 이름, SUBSTR(ename, -2) 뒤두글자, LPAD(SUBSTR(ename, -2), LENGTH(ename), '#') 꺼내온이름, hiredate 입사일, sal 급여
FROM
    emp
;

/*
    문제6]
        'jennie@githrd.com'이라는 메일에서 아이디 부분은 세 번째 문자만 표시하고
        나머지 문자는 '*'로 대체하고 @는 표시하고 .com도 표시하고
        나머지는 '*'로 대체해서 조회되는 질의명령 작성
*/
SELECT
    CONCAT(
        CONCAT(
            RPAD(
                LPAD(
                    SUBSTR('jennie@githrd.com' , 3, 1), 
                    3, 
                    '*'
                ), 
                INSTR('jennie@githrd.com', '@') - 1 , 
                '*'
            ), 
            '@'
        ),
        LPAD(
            SUBSTR(
                'jennie@githrd.com', 
                INSTR('jennie@githrd.com' , '.')
            ),
            LENGTH(
                SUBSTR(
                    'jennie@githrd.com', 
                    INSTR('jennie@githrd.com', '@') + 1
                )
            ),
            '*'
        )
    ) 제니메일
FROM
    dual
;
/*
    문제 1 ]
        사원의 이름, 직급, 입사일, 급여를 조회하세요.
        단, 급여가 높은 사람부터 먼저 출력되도록 하세요.
*/
SELECT
    ename, job, hiredate, sal
FROM
    emp
ORDER BY
    sal DESC
;
/*
    문제 2 ]
        사원들의 
            사원이름, 직급, 입사일, 부서번호를 조회하세요.
        단, 부서번호 순서대로 출력하고 
        같은 부서이면 입사일 순서대로 출력되도록 하세요.
*/
SELECT
    ename, job, hiredate, deptno
FROM
    emp
ORDER BY
    deptno, hiredate
;
/*
    문제 3 ]
        입사월이 5월인 사원의 
            사원이름, 직급, 입사일을 조회하세요.
            단, 입사일이 빠른 사람이 먼저 조회되도록 하세요.
*/
SELECT
    ename, job, hiredate
FROM
    emp
WHERE
    hiredate Like '__/05/__'
ORDER BY
    hiredate
;
/*
    문제 4 ] 연산자 사용해서 해결하세요.
        이름의 마지막 글자가 S인 사람의 
            사원이름, 직급, 입사일을 조회하세요.
        단, 직급 순서대로 조회하고 
        같은 직급이면 입사일 순서대로 출력되도록 하세요.
*/
SELECT
    ename, job, hiredate
FROM
    emp
WHERE
    SUBSTR(ename, -1, 1) = 'S'
ORDER BY
    job,  hiredate
;
/*
    문제 5 ] NVL() 사용해서 처리
        커미션을 27% 인상하여 조회하세요.
        단, 커미션이 없는 사원은 커미션을 100으로 계산해서
            100에 27% 를 인상하도록 하세요.
        단, 소수이상 2째 자리에서 반올림하여 출력하세요.
*/
SELECT
    ename 이름, sal 원급여, comm 원래커미션, ROUND(((NVL(comm, 100)) * 1.27), -2) 인상커미션
FROM
    emp
;

SELECT
    ename 이름, sal 원급여, comm 원래커미션, ROUND(NVL(comm * 1.27, 100 * 1.27), -2) 인상커미션
FROM
    emp
;
/*
    문제 6 ]
        급여의 15%를 인상한 급액과 커미션을 합쳐서 
        사원이름, 직급, 급여를 출력하세요.
        단, 급여는 소수이상 첫째자리에서 버림하여 출력하도록 하세요.
        그리고 커미션이 없는 사람은 0으로 가정하여 계산하도록 하세요.
*/
SELECT
    ename 이름, job 직급, sal 급여, comm 커미션, TRUNC((sal * 1.15 + NVL(comm, 0)), -1) 인상급여
FROM
    emp
;
/*
    문제 7 ]
        급여를 100으로 나누어 떨어지는 사람만 
            사원이름, 직급, 급여를 조회하세요.
*/
SELECT
    ename 이름, job 직급, sal 급여
FROM
    emp
WHERE
    MOD(sal, 100) = 0
;