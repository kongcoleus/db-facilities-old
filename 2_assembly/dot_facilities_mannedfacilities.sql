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
	(CASE
		WHEN oper_label IS NOT NULL THEN oper_label
		ELSE label
	END),
	-- addressnumber
	(CASE 
		WHEN arc_street IS NOT NULL THEN split_part(trim(both ' ' from REPLACE(arc_street,' - ','-')), ' ', 1)
		ELSE NULL
	END),
	-- streetname
	(CASE 
		WHEN arc_street IS NOT NULL THEN trim(both ' ' from substr(trim(both ' ' from REPLACE(arc_street,' - ','-')), strpos(trim(both ' ' from REPLACE(arc_street,' - ','-')), ' ')+1, (length(trim(both ' ' from REPLACE(arc_street,' - ','-')))-strpos(trim(both ' ' from REPLACE(arc_street,' - ','-')), ' '))))
		ELSE NULL
	END),
	-- address
	(CASE 
		WHEN arc_street IS NOT NULL THEN arc_street
		ELSE NULL
	END),
	-- borough
	NULL,
	-- zipcode
	NULL,
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	(CASE
		WHEN oper_label LIKE '%Asphalt%' THEN 'Material Supplies and Markets'
		ELSE 'Transportation'
	END),
	-- facilitysubgroup
	(CASE
		WHEN oper_label LIKE '%Asphalt%' THEN 'Material Supplies'
		ELSE 'Other Transportation'
	END),
	-- facilitytype
	(CASE
		WHEN oper_label LIKE '%Asphalt%' THEN 'Asphalt Plant'
		WHEN oper_label IS NOT NULL THEN
			REPLACE(
			REPLACE(
			REPLACE(
			REPLACE(
			REPLACE(
			REPLACE(
			REPLACE(
			oper_label,
			'RRM','Roadway Repair and Maintenance'),
			'SIM','Sidewalk and Inspection Management'),
			'OCMC','Construction Mitigation and Coordination'),
			'HIQA','Highway Inspection and Quality Assurance'),
			'BCO','Borough Commissioner’s Office'),
			'JETS','Roadway Repair and Maintenance'),
			'TMC','Traffic Management Center')
		ELSE 'Manned Transportation Facility'
	END),
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
	dot_facilities_mannedfacilities;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dot_facilities_mannedfacilities
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
	'dot_facilities_mannedfacilities'
FROM dot_facilities_mannedfacilities, facilities
WHERE facilities.hash = dot_facilities_mannedfacilities.hash;

--INSERT INTO
--facdb_agencyid(
--	uid,
--	overabbrev,
--	idagency,
--	idname
--)
--SELECT
--	uid,
--
--FROM dot_facilities_mannedfacilities, facilities
--WHERE facilities.hash = dot_facilities_mannedfacilities.hash;
--
--INSERT INTO
--facdb_area(
--	uid,
--	area,
--	areatype
--)
--SELECT
--	uid,
--
--FROM dot_facilities_mannedfacilities, facilities
--WHERE facilities.hash = dot_facilities_mannedfacilities.hash;

-- INSERT INTO
-- facdb_bbl(
-- 	uid,
-- 	bbl
-- )
-- SELECT
-- 	uid,

-- FROM dot_facilities_mannedfacilities, facilities
-- WHERE facilities.hash = dot_facilities_mannedfacilities.hash;

-- INSERT INTO
-- facdb_bin(
-- 	uid,
-- 	bin
-- )
-- SELECT
-- 	uid,

-- FROM dot_facilities_mannedfacilities, facilities
-- WHERE facilities.hash = dot_facilities_mannedfacilities.hash;

-- INSERT INTO
-- facdb_capacity(
--   uid,
--   capacity,
--   capacitytype
-- )
-- SELECT
-- 	uid,

-- FROM dot_facilities_mannedfacilities, facilities
-- WHERE facilities.hash = dot_facilities_mannedfacilities.hash;

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
FROM dot_facilities_mannedfacilities, facilities
WHERE facilities.hash = dot_facilities_mannedfacilities.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM dot_facilities_mannedfacilities, facilities
--WHERE facilities.hash = dot_facilities_mannedfacilities.hash;
--