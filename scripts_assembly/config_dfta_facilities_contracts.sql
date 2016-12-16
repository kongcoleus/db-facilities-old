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
	'dfta_facilities_contracts',
	-- hash,
	md5(CAST((*) AS text)),
	-- geom
	NULL,
	-- idagency
	ARRAY[Provider_ID],
	-- facilityname
	initcap(Sponsor_Name),
	-- addressnumber
	split_part(trim(both ' ' from initcap(Program_Address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Program_Address)), strpos(trim(both ' ' from initcap(Program_Address)), ' ')+1, (length(trim(both ' ' from initcap(Program_Address)))-strpos(trim(both ' ' from initcap(Program_Address)), ' ')))),
	-- address
	initcap(Program_Address),
	-- borough
	NULL,
	-- zipcode
	Program_Zipcode::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- parkid
	NULL,
	-- facilitytype
		(CASE
			WHEN Contract_Type LIKE '%INNOVATIVE SENIOR CENT%' THEN 'Innovative Senior Centers'
			WHEN Contract_Type LIKE '%NEIGHBORHOOD SENIOR CENT%' THEN 'Neighborhood Senior Centers'
			WHEN Contract_Type LIKE '%MEALS%' THEN  initcap(Contract_Type)
			ELSE 'Senior Services'
		END),
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Human Services',
	-- facilitysubgroup
	'Senior Services',
	-- agencyclass1
	Contract_Type,
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
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(Sponsor_Name),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	ARRAY['New York City Department for the Aging'],
	-- oversightabbrev
	ARRAY['NYCDFTA'],
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
	TRUE,
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
	dfta_facilities_contracts