
-- select u.username, m.title, mt.name as media_type
-- from users u, medias m, users_medias um, media_types mt
-- where u.id = um.user_id and m.id = um.media_id and m.media_type_id = mt.id;

SELECT
  u.username,
  m.title,
  mt.name AS media_type
FROM
  users u
JOIN
  users_medias um ON u.id = um.user_id
JOIN
  medias m ON m.id = um.media_id
JOIN
  media_types mt ON m.media_type_id = mt.id;

/*
The explicit JOIN syntax was introduced in the SQL-92 standard (published in
1992). Since then, the industry gradually adopted it as the preferred style. By
the late 1990s and early 2000s, most modern databases and teams favored explicit
JOINs for clarity and maintainability. The older style (listing tables in FROM
and joining in WHERE) is still valid, but explicit JOINs are now the standard.
*/
