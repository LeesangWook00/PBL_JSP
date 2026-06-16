# MySNS

JSP, DAO, MySQL을 사용해 구현한 SNS형 게시판 웹 애플리케이션입니다.

회원가입, 로그인, 게시글 작성, 이미지 첨부, 댓글, 좋아요, 팔로우, 회원 정보 수정, 회원 탈퇴 기능을 제공합니다.

## 프로젝트 이미지

MySNS 주요 화면 구성입니다.

| 홈 | 로그인 | 회원가입 |
|----|--------|----------|
| ![홈 화면](src/main/image/UI/home.png) | ![로그인 화면](src/main/image/UI/login.png) | ![회원가입 화면](src/main/image/UI/signup.png) |

| 피드 목록 | 게시글 상세 | 글쓰기 |
|-----------|-------------|--------|
| ![피드 목록 화면](src/main/image/UI/feed.png) | ![게시글 상세 화면](src/main/image/UI/feedView.png) | ![글쓰기 화면](src/main/image/UI/feedAddForm.png) |

| 게시글 수정/삭제 | 정보수정 | 회원목록 | 팔로우 목록 |
|------------------|----------|----------|-------------|
| ![게시글 수정 화면](<src/main/image/UI/edit feed.png>) ![게시글 삭제 확인 화면](<src/main/image/UI/confirm delete feed.png>) | ![정보수정 화면](src/main/image/UI/edit.png) | ![회원목록 화면](src/main/image/UI/userList.png) | ![팔로우 목록 화면](src/main/image/UI/followinglist.png) |

| 댓글 확인 | 좋아요/팔로우 확인 | 회원탈퇴 | 로그아웃 |
|-----------|--------------------|----------|----------|
| ![댓글 확인 화면](<src/main/image/UI/check reply.png>) | ![좋아요와 팔로우 확인 화면](<src/main/image/UI/check follow&like.png>) | ![회원탈퇴 화면](<src/main/image/UI/delete account.png>) | ![로그아웃 화면](src/main/image/UI/logout.png) |

## 팀 소개

| 이름 | GitHub | 역할 |
|------|--------|------|
| EUNTELLA | [@EUNTELLA](https://github.com/EUNTELLA) | 프로젝트 구현 |
| LeeSangWook00 | [@LeeSangWook00](https://github.com/LeeSangWook00) | 프로젝트 구현 |

## 프로젝트 개요

MySNS는 JSP 화면과 Java DAO 클래스를 분리해 구현한 게시판 기반 SNS 서비스입니다.

사용자는 회원가입과 로그인 후 게시글을 작성하고 이미지 파일을 첨부할 수 있습니다. 게시글 목록에서는 제목, 내용, 작성자 기준 검색과 페이지 이동을 지원하며, 상세 화면에서는 댓글 작성, 좋아요, 팔로우 기능을 사용할 수 있습니다.

관리자 계정은 회원 목록을 조회할 수 있고, 일반 사용자는 본인 정보 수정과 회원 탈퇴를 진행할 수 있습니다.

## 주요 기능

- 회원가입, 로그인, 로그아웃
- 회원 정보 수정, 소개글 수정, 회원 탈퇴
- 게시글 작성, 목록 조회, 상세보기, 수정, 삭제
- 게시글 제목, 내용, 작성자 검색
- 게시글 목록 페이지네이션
- 이미지 파일 업로드
- 댓글 작성, 목록 조회, 삭제
- 좋아요 추가 및 취소
- 사용자 목록 조회, 팔로우 및 팔로우 목록 조회
- 로그인 상태와 관리자 권한에 따른 메뉴 표시
- 모바일 화면 기준 UI 구성

## 기술 스택

| 분야 | 기술 |
|------|------|
| 언어 | Java, JSP, HTML, CSS |
| 서버 | Apache Tomcat 9 |
| 데이터베이스 | MySQL |
| DB 연결 | JNDI DataSource, JDBC |
| 파일 업로드 | Apache Commons FileUpload, Apache Commons IO |
| JDBC 드라이버 | MySQL Connector/J |
| IDE | Eclipse Dynamic Web Project, VS Code |
| 빌드 출력 | `build/classes` |

## 빠른 시작

### 사전 요구사항

- Java
- Apache Tomcat 9
- MySQL
- MySQL Connector/J
- Apache Commons FileUpload
- Apache Commons IO

필요한 라이브러리 jar 파일은 `src/main/webapp/WEB-INF/lib`에 포함되어 있습니다.

### DB 생성

MySQL에서 아래 SQL을 실행합니다.

```sql
SOURCE src/main/webapp/SQL/mysns.sql;
SOURCE src/main/webapp/SQL/data.sql;
```

페이지 테스트용 더미 데이터가 필요하면 추가로 실행합니다.

```sql
SOURCE src/main/webapp/SQL/dummy.sql;
```

기존 DB를 사용하는 경우에는 마이그레이션 SQL을 실행합니다.

```sql
SOURCE src/main/webapp/SQL/migrate.sql;
```

### Tomcat JNDI 설정

프로젝트는 다음 JNDI 이름으로 DB 커넥션을 가져옵니다.

```text
java:comp/env/jdbc/mysns
```

프로젝트의 `src/main/webapp/META-INF/context.xml` 또는 Tomcat의 `conf/context.xml`에 Resource 설정을 추가합니다.

```xml
<Resource
    name="jdbc/mysns"
    auth="Container"
    type="javax.sql.DataSource"
    driverClassName="com.mysql.cj.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/mysns?serverTimezone=Asia/Seoul&amp;characterEncoding=UTF-8"
    username="root"
    password="본인_MySQL_비밀번호"
    maxTotal="20"
    maxIdle="10"
    maxWaitMillis="-1" />
```

### 실행

Tomcat에 프로젝트를 배포한 뒤 브라우저에서 접속합니다.

```text
http://localhost:8080/PBL_JSP/index.jsp
```

JSP 파일은 직접 열지 말고 반드시 Tomcat 주소로 접속해야 합니다.

### 테스트 계정

`data.sql`을 실행한 경우 아래 계정을 사용할 수 있습니다.

| 아이디 | 비밀번호 |
|--------|----------|
| `root@abc.com` | `111` |
| `kim@abc.com` | `111` |
| `lee@abc.com` | `111` |
| `kwon@abc.com` | `111` |

## 프로젝트 구조

```text
PBL_JSP
├── README.md
├── src
│   └── main
│       ├── image
│       │   ├── profile
│       │   └── UI
│       ├── java
│       │   ├── dao
│       │   └── util
│       └── webapp
│           ├── index.html
│           ├── index.jsp
│           ├── css
│           ├── html
│           ├── jsp
│           ├── SQL
│           └── WEB-INF
└── build
    └── classes
```
