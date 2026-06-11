USE mysns;

INSERT INTO user(id, password, name, bio, profile_image)
VALUES("kim@abc.com", "111", "김시민", "자동화 업무를 정리합니다.", "profile1.jpg")
ON DUPLICATE KEY UPDATE name = VALUES(name), bio = VALUES(bio), profile_image = VALUES(profile_image);

INSERT INTO user(id, password, name, bio, profile_image)
VALUES("lee@abc.com", "111", "이순신", "프로젝트 진행 상황을 공유합니다.", "profile2.jpg")
ON DUPLICATE KEY UPDATE name = VALUES(name), bio = VALUES(bio), profile_image = VALUES(profile_image);

INSERT INTO user(id, password, name, bio, profile_image)
VALUES("kwon@abc.com", "111", "권율", "아이디어와 기록을 남깁니다.", "profile3.jpg")
ON DUPLICATE KEY UPDATE name = VALUES(name), bio = VALUES(bio), profile_image = VALUES(profile_image);

INSERT INTO feed(id, title, content) VALUES("kim@abc.com", "첫 게시글", "Hello");
INSERT INTO feed(id, title, content) VALUES("kwon@abc.com", "업무 기록", "Aloha");

INSERT INTO reply(feed_no, id, content) VALUES(1, "lee@abc.com", "확인했습니다.");

