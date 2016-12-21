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
	ARRAY['usdot_facilities_airports'],
	-- hash,
	md5(CAST((usdot_facilities_airports.*) AS text)),
	-- geom
	geom,
	-- idagency
	ARRAY[locationid],
	-- facilityname
	fullname,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
		(CASE
			WHEN (stateabbv = 'NY') AND (County = 'New York') THEN 'Manhattan'
			WHEN (stateabbv = 'NY') AND (County = 'Bronx') THEN 'Bronx'
			WHEN (stateabbv = 'NY') AND (County = 'Kings') THEN 'Brooklyn'
			WHEN (stateabbv = 'NY') AND (County = 'Queens') THEN 'Queens'
			WHEN (stateabbv = 'NY') AND (County = 'Richmond') THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- parkid
	NULL,
	-- facilitytype
	facilityty,
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Transportation',
	-- facilitysubgroup
	'Airports and Heliports',
	-- agencyclass1
	facilityty,
	-- agencyclass2
	'NA',

	-- capacity
	NULL,
	-- utilization
	NULL,
	-- capacitytype
	NULL,
	-- utilizationrate
	NULL,
	-- area
	acres,
	-- areatype
	'Acres',
	-- operatortype
		(CASE
			WHEN ownertype = 'Pr' THEN 'Non-public'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE
			WHEN ownertype = 'Pr' THEN fullname
			ELSE 'Public'
		END),
	-- operatorabbrev
		(CASE
			WHEN ownertype = 'Pr' THEN 'Non-public'
			ELSE 'Public'
		END),
	-- oversightagency
	ARRAY['United States Department of Transportation'],
	-- oversightabbrev
	ARRAY['USDOT'],
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
	usdot_facilities_airports
WHERE
	stateabbv = 'NY' 
	AND (County = 'New York'
	OR County = 'Bronx'
	OR County = 'Kings'
	OR County = 'Queens'
	OR County = 'Richmond')