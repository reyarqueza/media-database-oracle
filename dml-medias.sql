-- Insert a new media
INSERT INTO medias (title, media_type_id) VALUES ('Megazone 23 Part 1',
  (SELECT id FROM media_types WHERE name = 'VHS')
);
INSERT INTO medias (title, media_type_id) VALUES ('Megazone 23 Part 2 - International',
  (SELECT id FROM media_types WHERE name = 'LaserDisc')
);
INSERT INTO medias (title, media_type_id) VALUES ('Megazone 23 Part 1',
  (SELECT id FROM media_types WHERE name = 'DVD')
);
INSERT INTO medias (title, media_type_id) VALUES ('Megazone 23 Part 2',
  (SELECT id FROM media_types WHERE name = 'DVD')
);
INSERT INTO medias (title, media_type_id) VALUES ('Megazone 23 Part 3',
  (SELECT id FROM media_types WHERE name = 'DVD')
);
INSERT INTO medias (title, media_type_id) VALUES ('Megazone 23 Collection',
  (SELECT id FROM media_types WHERE name = 'Blu-ray')
);
INSERT INTO medias (title, media_type_id) VALUES ('Attack of the Bionoids',
  (SELECT id FROM media_types WHERE name = 'VHS')
);
INSERT INTO medias (title, media_type_id) VALUES ('Superdimension Fortress Macross',
  (SELECT id FROM media_types WHERE name = 'LaserDisc')
);
INSERT INTO medias (title, media_type_id) VALUES ('Robotech: The Macross Saga',
  (SELECT id FROM media_types WHERE name = 'DVD')
);
INSERT INTO medias (title, media_type_id) VALUES ('Macross Plus - Box Set',
  (SELECT id FROM media_types WHERE name = 'DVD')
);
INSERT INTO medias (title, media_type_id) VALUES ('Macross Zero',
  (SELECT id FROM media_types WHERE name = 'DVD')
);
INSERT INTO medias (title, media_type_id) VALUES ('Macross 7 Collection',
  (SELECT id FROM media_types WHERE name = 'Blu-ray')
);

COMMIT;
