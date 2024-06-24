DROP TABLE IF EXISTS event;

CREATE TABLE event (
    id uuid DEFAULT gen_random_uuid(),
    lut BIGINT DEFAULT (extract(epoch from NOW()) * 1000),
    name VARCHAR(30) NOT NULL,
    longitude DOUBLE PRECISION NOT NULL CHECK (longitude BETWEEN -180 AND 180),
    latitude DOUBLE PRECISION NOT NULL CHECK (latitude BETWEEN -90 AND 90),
    description VARCHAR(500) NOT NULL,
    PRIMARY KEY (id, lut)
);