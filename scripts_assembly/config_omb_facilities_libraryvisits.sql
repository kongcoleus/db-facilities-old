INSERT INTO
facilities (
	pgtable,
	hash,
	geom,
	idagency,
	facilityname,
	addressnumber,
	streetname,
	address,
	borough,
	zipcode,
	bbl,
	bin,
	parkid,
	facilitytype,
	domain,
	facilitygroup,
	facilitysubgroup,
	agencyclass1,
	agencyclass2,
	capacity,
	utilization,
	capacitytype,
	utilizationrate,
	area,
	areatype,
	operatortype,
	operatorname,
	operatorabbrev,
	oversightagency,
	oversightabbrev,
	datecreated,
	buildingid,
	buildingname,
	schoolorganizationlevel,
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
	-- pgtable
	ARRAY['omb_facilities_libraryvisits'],
	-- hash,
	md5(CAST((omb_facilities_libraryvisits.*) AS text)),
	-- geom
	ST_SetSRID(ST_MakePoint(lon, lat),4326),
	-- idagency
	NULL,
	-- facilityname
	split_part(name,' - ',1),
	-- addressnumber
	housenum,
	-- streetname
	initcap(streetname),
	-- address
	CONCAT(housenum,' ',initcap(streetname)),
	-- borough
	boroname,
	-- zipcode
	ROUND(zip::numeric,0),
	-- bbl
	ARRAY[ROUND(bbl::numeric,0)],
	-- bin
	ARRAY[ROUND(bin::numeric,0)],
	-- parkid
	NULL,
	-- facilitytype
	'Public Libraries',
	-- domain
	'Parks, Cultural, and Other Community Facilities',
	-- facilitygroup
	'Libraries',
	-- facilitysubgroup
	'Public Libraries',
	-- agencyclass1
	'NA',
	-- agencyclass2
	'NA',

	-- capacity
	NULL,
	-- utilization
	visits,
	-- capacitytype
	'Visits',
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
		(CASE
			WHEN system = 'QPL' THEN 'Queens Public Libraries'
			WHEN system = 'BPL' THEN 'Brooklyn Public Libraries'
			WHEN system = 'NYPL' THEN 'New York Public Libraries'
		END),
	-- operatorabbrev
	system,
	-- oversightagency
		(CASE
			WHEN system = 'QPL' THEN ARRAY['Queens Public Libraries']
			WHEN system = 'BPL' THEN ARRAY['Brooklyn Public Libraries']
			WHEN system = 'NYPL' THEN ARRAY['New York Public Libraries']
		END),
	-- oversightabbrev
	ARRAY[system],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- buildingid
	NULL,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
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
	omb_facilities_libraryvisits