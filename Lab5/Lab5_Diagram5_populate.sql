-- Lab5 Diagram5 Populate --

INSERT INTO address VALUES ('1640-091', 'Rua António de Oliveira Salazar, N27', 'Lisbon', 'Portugal', '216785491');

INSERT INTO musician VALUES (13747098, '915634353', 'Lisbon', 'Portugal', '1640-091', 'Rua António de Oliveira Salazar, N27' );

INSERT INTO instrument VALUES ('guitar', 'C major');

INSERT INTO music VALUES ('The Charms of the Earth', 'Nightingale Faduncho');

INSERT INTO album VALUES ( 81246, '03-10-2016', 'A Minha Vida',  13747098);

INSERT INTO consists_of VALUES ('The Charms of the Earth','Nightingale Faduncho', 81246);

INSERT INTO participates VALUES (13747098, 'The Charms of the Earth', 'Nightingale Faduncho' );


-- Some Queries --

SELECT *
FROM instrument;

