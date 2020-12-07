CREATE TABLE nodes (
    id INTEGER PRIMARY KEY NOT NULL,
    lat REAL,
    lon REAL,
    user TEXT,
    uid INTEGER,
    version INTEGER,
    changeset INTEGER,
    timestamp TEXT
);

CREATE TABLE nodes_temp (
    id TEXT,
    lat TEXT,
    lon TEXT,
    user TEXT,
    uid TEXT,
    version TEXT,
    changeset TEXT,
    timestamp TEXT
);

.mode csv
.import nodes.csv nodes_temp

INSERT INTO nodes
SELECT CAST(id AS INTEGER), 
    CAST(lat AS REAL),
    CAST(lon AS REAL),
    CAST(user AS TEXT),
    CAST(uid AS INTEGER),
    CAST(version AS INTEGER),
    CAST(changeset AS INTEGER),
    CAST(timestamp AS TEXT)
FROM nodes_temp;

SELECT * FROM nodes
LIMIT 10;

DROP TABLE nodes_temp;

// now nodes_tags

CREATE TABLE nodes_tags (
    id INTEGER,
    key TEXT,
    value TEXT,
    type TEXT,
    FOREIGN KEY (id) REFERENCES nodes(id)
);

CREATE TABLE nodes_tags_temp (
    id TEXT,
    key TEXT,
    value TEXT,
    type TEXT
);

.mode csv
.import nodes_tags.csv nodes_tags_temp

INSERT INTO nodes_tags
SELECT CAST(id AS INTEGER), key, value, type
FROM nodes_tags_temp;

SELECT * FROM nodes_tags
LIMIT 10;



// temp and import into ways

CREATE TABLE ways (
    id INTEGER PRIMARY KEY NOT NULL,
    user TEXT,
    uid INTEGER,
    version TEXT,
    changeset INTEGER,
    timestamp TEXT
);

CREATE TABLE ways_temp (
    id TEXT,
    user TEXT,
    uid TEXT,
    version TEXT,
    changeset TEXT,
    timestamp TEXT
);

.mode csv
.import ways.csv ways_temp

INSERT INTO ways
SELECT CAST(id AS INTEGER),
    user,
    CAST(uid AS INTEGER),
    version,
    CAST(changeset AS INTEGER),
    timestamp
FROM ways_temp;

SELECT * FROM ways
LIMIT 10;


// temp and import into ways_tags

CREATE TABLE ways_tags (
    id INTEGER NOT NULL,
    key TEXT NOT NULL,
    value TEXT NOT NULL,
    type TEXT,
    FOREIGN KEY (id) REFERENCES ways(id)
);

CREATE TABLE ways_tags_temp (
    id TEXT,
    key TEXT,
    value TEXT,
    type TEXT
);

.mode csv
.import ways_tags.csv ways_tags_temp

INSERT INTO ways_tags
SELECT CAST(id AS INTEGER), key, value, type
FROM ways_tags_temp;

SELECT * FROM ways_tags
LIMIT 10;


// temp and import into way_nodes

CREATE TABLE ways_nodes (
    id INTEGER NOT NULL,
    node_id INTEGER NOT NULL,
    position INTEGER NOT NULL,
    FOREIGN KEY (id) REFERENCES ways(id),
    FOREIGN KEY (node_id) REFERENCES nodes(id)
);

CREATE TABLE ways_nodes_temp (
    id TEXT,
    node_id TEXT,
    position TEXT
);

.mode csv
.import ways_nodes.csv ways_nodes_temp

INSERT INTO ways_nodes
SELECT CAST(id AS INTEGER), 
    CAST(node_id AS INTEGER), 
    CAST(position AS INTEGER)
FROM ways_nodes_temp;

SELECT * FROM ways_nodes
LIMIT 10;