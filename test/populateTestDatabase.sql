-- Script to populate the earth database with test data

CREATE TABLE sequences (
  valid tinyint(1) NOT NULL default '0',
  imageFormat varchar(10) NOT NULL default '',
  width int(11) NOT NULL default '0',
  height int(11) NOT NULL default '0',
  path text NOT NULL,
  frames text NOT NULL
) TYPE=MyISAM;

INSERT INTO sequences VALUES (1, 'GIF',      2, 2, 'index/test1.#.gif',               '1-4');
INSERT INTO sequences VALUES (1, 'GIF',      4, 4, 'index/test1.#.gif',               '5');
INSERT INTO sequences VALUES (1, 'SGI',      8, 8, 'index/test2.@@',               '8');
INSERT INTO sequences VALUES (1, 'Cineon', 4, 4, 'test/index/foo/#',               '2-3');
INSERT INTO sequences VALUES (1, 'Cineon', 8, 8, 'index/blah/a/#.cin',           '6-7');
INSERT INTO sequences VALUES (1, 'GIF',      2, 2, 'seq/test1.#.gif',                 '1-4');
INSERT INTO sequences VALUES (1, 'GIF',      2, 2, 'seq/test2.@.gif',                '8');
INSERT INTO sequences VALUES (1, 'GIF',      2, 2, 'seq/test2.@@@@@@.gif', '123');
INSERT INTO sequences VALUES (1, 'GIF',      2, 2, 'seq/@@@.gif',                 '120');
INSERT INTO sequences VALUES (1, 'TIFF',     4, 4, 'seq/@@@.gif',                 '110');
INSERT INTO sequences VALUES (1, 'Cineon', 8, 8, 'seq/test3.#',                      '1,3');
INSERT INTO sequences VALUES (0, 'Cineon', 0, 0, 'seq/test3.#',                      '2,4');
INSERT INTO sequences VALUES (1, 'Cineon', 8, 8, 'seq/foo',                           '');
INSERT INTO sequences VALUES (1, 'Cineon', 8, 8, 'seq/bar',                           '');
