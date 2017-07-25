INSERT INTO
facilities(
	hash,
	uid,
    geom,
    geomsource,
	facname,
	addressnum,
	streetname,
	address,
	boro,
	zipcode,
	facdomain,
	facgroup,
	facsubgrp,
	factype,
	optype,
	opname,
	opabbrev,
	datecreated,
	children,
	youth,
	senior,
	family,
	disabilities,
	dropouts,
	unemployed,
	homeless,
	immigrants,
	groupquarters
)
SELECT
	-- hash,
    hash,
    -- uid
    NULL,
	-- geom
	geom,
    -- geomsource
    'Agency',
	-- facilityname
	name,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	Street,
	-- borough
		(CASE
			WHEN boro_code = 1 THEN 'Manhattan'
			WHEN boro_code = 2 THEN 'Bronx'
			WHEN boro_code = 3 THEN 'Brooklyn'
			WHEN boro_code = 4 THEN 'Queens'
			WHEN boro_code = 5 THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- domain
	'Parks, Gardens, and Historical Sites',
	-- facilitygroup
	'Parks and Plazas',
	-- facilitysubgroup
	'Streetscapes, Plazas, and Malls',
	-- facilitytype
	'Pedestrian Plaza',
	-- operatortype
	'Public',
	-- operatorname
	'NYC Department of Transportation',
	-- operatorabbrev
	'NYCDOT',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	FALSE,
	-- youth
	FALSE,
	-- senior
	FALSE,
	-- family
	FALSE,
	-- disabilities
	FALSE,
	-- dropouts
	FALSE,
	-- unemployed
	FALSE,
	-- homeless
	FALSE,
	-- immigrants
	FALSE,
	-- groupquarters
	FALSE
FROM
	dot_facilities_pedplazas;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dot_facilities_pedplazas
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
);
-- JOIN uid FROM KEY ONTO DATABASE
UPDATE facilities AS f
SET uid = k.uid
FROM facdb_uid_key AS k
WHERE k.hash = f.hash AND
      f.uid IS NULL;

INSERT INTO
facdb_pgtable(
   uid,
   pgtable
)
SELECT
	uid,
	'dot_facilities_pedplazas'
FROM dot_facilities_pedplazas, facilities
WHERE facilities.hash = dot_facilities_pedplazas.hash;

INSERT INTO
facdb_agencyid(
	uid,
	overabbrev,
	idagency,
	idname
)
SELECT
	uid,
	'NYCDOT',
	mapid,
	'Map ID'
FROM dot_facilities_pedplazas, facilities
WHERE facilities.hash = dot_facilities_pedplazas.hash;

--INSERT INTO
--facdb_area(
--	uid,
--	area,
--	areatype
--)
--SELECT
--	uid,
--
--FROM dot_facilities_pedplazas, facilities
--WHERE facilities.hash = dot_facilities_pedplazas.hash;

-- INSERT INTO
-- facdb_bbl(
-- 	uid,
-- 	bbl
-- )
-- SELECT
-- 	uid,

-- FROM dot_facilities_pedplazas, facilities
-- WHERE facilities.hash = dot_facilities_pedplazas.hash;

-- INSERT INTO
-- facdb_bin(
-- 	uid,
-- 	bin
-- )
-- SELECT
-- 	uid,

-- FROM dot_facilities_pedplazas, facilities
-- WHERE facilities.hash = dot_facilities_pedplazas.hash;

-- INSERT INTO
-- facdb_capacity(
--   uid,
--   capacity,
--   capacitytype
-- )
-- SELECT
-- 	uid,

-- FROM dot_facilities_pedplazas, facilities
-- WHERE facilities.hash = dot_facilities_pedplazas.hash;

INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
	-- oversightagency
	'NYC Department of Transportation',
	-- oversightabbrev
	'NYCDOT',
    'City'
FROM dot_facilities_pedplazas, facilities
WHERE facilities.hash = dot_facilities_pedplazas.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM dot_facilities_pedplazas, facilities
--WHERE facilities.hash = dot_facilities_pedplazas.hash;