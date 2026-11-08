-- Link user 'winters' to 'Megazone 23 Part 1' (with media_type 'DVD')
INSERT INTO users_medias (user_id, media_id)
SELECT u.id, m.id
FROM users u
JOIN medias m ON m.title = 'Megazone 23 Part 1'
JOIN media_types t ON m.media_type_id = t.id
WHERE u.username = 'winters' AND t.name = 'DVD';

COMMIT;
