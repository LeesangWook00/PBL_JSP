# MySNS — JSP 기반 게시판 서비스

MySNS는 JSP, DAO, MySQL을 사용해 구현한 간단한 SNS형 게시판 웹 애플리케이션입니다.

회원가입, 로그인, 게시글 작성, 이미지 첨부, 댓글, 정보수정, 회원탈퇴 기능을 제공하며,
교재 예제 구조를 유지하면서 `user`, `feed`, `reply` 테이블을 확장했습니다.

## 주요 기능

- **회원 인증** - 회원가입, 로그인, 로그아웃 기능 제공
- **회원 관리** - 정보수정, 소개글 수정, 회원탈퇴 기능 제공
- **게시판** - 게시글 등록, 목록 조회, 수정, 삭제 기능 제공
- **이미지 첨부** - 게시글 작성 시 이미지 파일 업로드 지원
- **댓글 기능** - 새 `reply` 테이블을 사용한 댓글 등록, 목록, 삭제 기능 제공
- **로그인 상태별 메뉴** - 로그인 전/후에 다른 메뉴 표시
- **DB 확장** - `user.bio`, `feed.title`, `reply` 테이블 추가
- **JSP/DAO 구조** - JSP 화면과 Java DAO 클래스로 DB 작업 분리

## 기술 스택

| 분야 | 기술 |
|------|------|
| **언어** | Java, JSP, HTML, CSS |
| **서버** | Apache Tomcat 9 |
| **데이터베이스** | MySQL |
| **DB 연결** | JNDI DataSource, JDBC |
| **파일 업로드** | Apache Commons FileUpload |
| **IDE** | Eclipse Dynamic Web Project |
| **빌드 출력** | `build/classes` |

## 빠른 시작

### 사전 요구사항

- Java 20
- Apache Tomcat 9
- MySQL
- Eclipse IDE
- MySQL Connector/J
- Apache Commons FileUpload
- Apache Commons IO

### 실행 방법

1. **프로젝트 열기**

```text
Eclipse > File > Import > Existing Projects into Workspace
```

2. **MySQL DB 생성**

```sql
SOURCE src/main/webapp/SQL/mysns.sql;
```

3. **샘플 데이터 입력**

```sql
SOURCE src/main/webapp/SQL/data.sql;
```

4. **기존 DB를 사용하는 경우 마이그레이션 실행**

```sql
SOURCE src/main/webapp/SQL/migrate.sql;
```

5. **Tomcat 서버에 프로젝트 배포**

```text
Servers 탭 > Tomcat v9.0 > Add and Remove > PBL_JSP 추가
```

6. **브라우저에서 확인**

```text
http://localhost:8080/PBL_JSP/index.html
```

프로젝트 컨텍스트명이 다르면 `PBL_JSP` 부분을 실제 컨텍스트명으로 변경해야 합니다.

## 저장소 구조

```text
PBL_JSP
├── README.md
├── src
│   └── main
│       ├── java
│       │   ├── dao
│       │   │   ├── UserDAO.java
│       │   │   ├── UserObj.java
│       │   │   ├── FeedDAO.java
│       │   │   ├── FeedObj.java
│       │   │   ├── ReplyDAO.java
│       │   │   └── ReplyObj.java
│       │   └── util
│       │       ├── ConnectionPool.java
│       │       └── FileUtil.java
│       └── webapp
│           ├── index.html
│           ├── css
│           │   └── core.css
│           ├── html
│           │   ├── login.html
│           │   ├── signup.html
│           │   ├── feedAdd.html
│           │   └── withdraw.html
│           ├── jsp
│           │   ├── login.jsp
│           │   ├── logout.jsp
│           │   ├── signup.jsp
│           │   ├── update.jsp
│           │   ├── withdraw.jsp
│           │   ├── main.jsp
│           │   ├── feedAdd.jsp
│           │   ├── feedEdit.jsp
│           │   ├── feedUpdate.jsp
│           │   ├── feedDelete.jsp
│           │   ├── replyAdd.jsp
│           │   ├── replyDelete.jsp
│           │   └── userList.jsp
│           ├── SQL
│           │   ├── mysns.sql
│           │   ├── data.sql
│           │   └── migrate.sql
│           └── WEB-INF
│               └── lib
└── build
    └── classes
```

## 아키텍처 개요

### 화면 계층

- `html/` 폴더는 로그인 전 정적 화면을 담당합니다.
- `jsp/` 폴더는 요청 처리, 세션 처리, DB 결과 출력 화면을 담당합니다.
- `core.css`는 전체 공통 레이아웃과 게시판 스타일을 담당합니다.

### 비즈니스 로직 계층

- `UserDAO`는 회원가입, 로그인, 정보수정, 회원탈퇴, 회원목록 기능을 처리합니다.
- `FeedDAO`는 게시글 등록, 목록, 상세조회, 수정, 삭제 기능을 처리합니다.
- `ReplyDAO`는 댓글 등록, 목록, 삭제 기능을 처리합니다.

### 유틸리티 계층

- `ConnectionPool`은 Tomcat JNDI DataSource에서 DB 커넥션을 가져옵니다.
- `FileUtil`은 업로드 이미지를 서버의 `images` 폴더에 저장합니다.

## 데이터베이스 테이블

| 테이블 | 용도 |
|--------|------|
| `user` | 회원 계정, 이름, 소개글 저장 |
| `feed` | 게시글 제목, 내용, 이미지 저장 |
| `reply` | 게시글 댓글 저장 |

### user 테이블

| 컬럼 | 설명 |
|------|------|
| `id` | 회원 아이디, 이메일 형식 |
| `password` | 비밀번호 |
| `name` | 회원 이름 |
| `bio` | 회원 소개 |
| `ts` | 가입일 |

### feed 테이블

| 컬럼 | 설명 |
|------|------|
| `no` | 게시글 번호 |
| `id` | 작성자 아이디 |
| `title` | 게시글 제목 |
| `content` | 게시글 내용 |
| `ts` | 작성일 |
| `images` | 첨부 이미지 파일명 |

### reply 테이블

| 컬럼 | 설명 |
|------|------|
| `no` | 댓글 번호 |
| `feed_no` | 게시글 번호 |
| `id` | 댓글 작성자 아이디 |
| `content` | 댓글 내용 |
| `ts` | 작성일 |

## 주요 JSP 흐름

### 인증

| 파일 | 설명 |
|------|------|
| `html/signup.html` | 회원가입 입력 화면 |
| `jsp/signup.jsp` | 회원가입 처리 |
| `html/login.html` | 로그인 입력 화면 |
| `jsp/login.jsp` | 로그인 처리 |
| `jsp/logout.jsp` | 로그아웃 처리 |

### 회원 관리

| 파일 | 설명 |
|------|------|
| `jsp/edit.jsp` | 정보수정 및 회원탈퇴 화면 |
| `jsp/update.jsp` | 회원 정보 수정 처리 |
| `jsp/withdraw.jsp` | 로그인된 회원 탈퇴 처리 |
| `jsp/userList.jsp` | 회원목록 출력 |

### 게시판

| 파일 | 설명 |
|------|------|
| `jsp/main.jsp` | 게시글 목록, 댓글 목록 출력 |
| `html/feedAdd.html` | 게시글 작성 화면 |
| `jsp/feedAdd.jsp` | 게시글 등록 처리 |
| `jsp/feedEdit.jsp` | 게시글 수정 화면 |
| `jsp/feedUpdate.jsp` | 게시글 수정 처리 |
| `jsp/feedDelete.jsp` | 게시글 삭제 처리 |

### 댓글

| 파일 | 설명 |
|------|------|
| `jsp/replyAdd.jsp` | 댓글 등록 처리 |
| `jsp/replyDelete.jsp` | 댓글 삭제 처리 |

## DB 마이그레이션

기존 DB가 이미 만들어져 있다면 `mysns.sql`의 변경사항이 자동 반영되지 않습니다.
아래 SQL을 실행하거나 `SQL/migrate.sql` 파일을 실행해야 합니다.

```sql
USE mysns;

ALTER TABLE user
ADD COLUMN bio VARCHAR(512);

ALTER TABLE feed
ADD COLUMN title VARCHAR(128);

CREATE TABLE IF NOT EXISTS reply(
    no INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    feed_no INT UNSIGNED,
    id VARCHAR(128),
    content VARCHAR(1024),
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

UPDATE feed
SET title = '제목 없음'
WHERE title IS NULL OR title = '';
```

이미 컬럼이 존재하는 경우 `Duplicate column` 오류가 날 수 있습니다.
그 경우 해당 `ALTER TABLE` 줄은 제외하고 실행하면 됩니다.

## 테스트 계정

`data.sql`을 실행한 경우 아래 계정을 사용할 수 있습니다.

| 아이디 | 비밀번호 |
|--------|----------|
| `kim@abc.com` | `111` |
| `lee@abc.com` | `111` |
| `kwon@abc.com` | `111` |

## 테스트 시나리오

1. 회원가입 화면에서 새 계정 생성
2. 로그인 화면에서 로그인
3. 로그인 후 메뉴가 `글쓰기`, `정보수정`, `회원목록`, `로그아웃`으로 바뀌는지 확인
4. 게시글 작성
5. 게시판 목록에서 게시글 확인
6. 본인 게시글 수정
7. 본인 게시글 삭제
8. 댓글 작성
9. 본인 댓글 삭제
10. 정보수정 화면에서 회원 정보 수정
11. 정보수정 화면에서 회원탈퇴
12. 로그아웃 후 메뉴가 `로그인`, `회원가입`으로 바뀌는지 확인

## 주의사항

- JSP 파일은 직접 열면 안 됩니다.
- 반드시 Tomcat 서버 주소로 접속해야 합니다.
- 예: `http://localhost:8080/PBL_JSP/html/login.html`
- Java class 버전 오류가 발생하면 Eclipse 컴파일러 버전과 Tomcat 실행 JRE 버전을 맞춰야 합니다.
- 현재 프로젝트는 Java 20 기준으로 컴파일되도록 설정되어 있습니다.

## 자주 발생하는 오류

### JSP 코드가 브라우저에 그대로 보이는 경우

Tomcat을 거치지 않고 파일을 직접 연 것입니다.

잘못된 예:

```text
file:///C:/Users/USER/eclipse-workspace/PBL_JSP/src/main/webapp/html/login.html
```

올바른 예:

```text
http://localhost:8080/PBL_JSP/html/login.html
```

### Column 'title' not found 오류

기존 DB에 `feed.title` 컬럼이 없는 상태입니다.
`SQL/migrate.sql`을 실행해야 합니다.

### UnsupportedClassVersionError 오류

Tomcat 실행 JRE보다 높은 버전으로 `.class` 파일이 컴파일된 상태입니다.

해결 방법:

```text
Project > Properties > Java Compiler > Compiler compliance level: 20
Servers 탭 > Tomcat 우클릭 > Clean > Publish > Restart
```
