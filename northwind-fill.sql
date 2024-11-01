CREATE TABLE new_table (
    id int,
    name text COLLATE "C"
);

INSERT INTO new_table(id, name)
SELECT s.id, md5(random()::text)
FROM generate_series(1, 1000000) AS s(id)
ORDER BY random();

UPDATE new_table
SET name = md5((random()::text))

--B-tree индекс для поиска по диапазонам
CREATE INDEX idx_new_table_id ON new_table (id);

--Hash индекс для поиска по точному значению
CREATE INDEX idx_new_table_name_hash ON new_table USING hash (name);

--Составной индекс с использованием правил для хорошей селективности
CREATE INDEX idx_new_table_id_name ON new_table (id, name);

--Проверка:
EXPLAIN ANALYZE SELECT *
FROM new_table
WHERE id BETWEEN 1 AND 10;

EXPLAIN ANALYZE SELECT *
FROM new_table
WHERE name = 'ab%';

EXPLAIN ANALYZE SELECT *
FROM new_table
WHERE id = 1 AND name = '7e70ce7e4e2775cab71bf0bdf1c4e3d3';