-- facilities
-- Custom insert statement
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
    proptype,
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
			WHEN (name = ' ' OR name IS NULL) AND usedec LIKE '%OFFICE%' THEN 'Office'
			WHEN (name = ' ' OR name IS NULL) AND usedec LIKE '%NO USE%' THEN 'City Owned Property'
			WHEN name <> ' ' AND name IS NOT NULL THEN initcap(name)
			ELSE initcap(REPLACE(usedec, 'OTHER ', ''))
		END),
	-- addressnumber
	split_part(trim(both ' ' from initcap(address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(address)), strpos(trim(both ' ' from initcap(address)), ' ')+1, (length(trim(both ' ' from initcap(address)))-strpos(trim(both ' ' from initcap(address)), ' ')))),
	-- address
	initcap(address),
	-- borough
	initcap(boro),
	-- zipcode
	NULL,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE
			-- Admin of Gov
			WHEN usedec LIKE '%AGREEMENT%'
				OR usedec LIKE '%DISPOSITION%'
				OR usedec LIKE '%COMMITMENT%'
				OR agency LIKE '%PRIVATE%'
				THEN 'Properties Leased or Licensed to Non-public Entities'
			WHEN usedec LIKE '%SECURITY%' THEN 'Miscellaneous Use'
			WHEN (usedec LIKE '%PARKING%'
				OR usedec LIKE '%PKNG%')
				AND usedec NOT LIKE '%MUNICIPAL%'
				THEN 'City Agency Parking'
			WHEN usedec LIKE '%STORAGE%' OR usedec LIKE '%STRG%' THEN 'Storage'
			WHEN usedec LIKE '%CUSTODIAL%' THEN 'Custodial'
			WHEN usedec LIKE '%GARAGE%' THEN 'Maintenance and Garages'
			WHEN usedec LIKE '%OFFICE%' THEN 'City Government Offices'
			WHEN usedec LIKE '%MAINTENANCE%' THEN 'Maintenance and Garages'
			WHEN usedec LIKE '%NO USE%' THEN 'Miscellaneous Use'
			WHEN usedec LIKE '%MISCELLANEOUS USE%' THEN 'Miscellaneous Use'
			WHEN usedec LIKE '%OTHER HEALTH%' AND name LIKE '%ANIMAL%' THEN 'Miscellaneous Use'
			WHEN agency LIKE '%DCA%' and usedec LIKE '%OTHER%' THEN 'Miscellaneous Use'
			WHEN usedec LIKE '%UNDEVELOPED%' THEN 'Miscellaneous Use'
			WHEN (usedec LIKE '%TRAINING%' 
				OR usedec LIKE '%TESTING%')
				AND usedec NOT LIKE '%LABORATORY%'
				THEN 'Training and Testing'

			-- Trans and Infra
			WHEN usedec LIKE '%MUNICIPAL PARKING%' THEN 'Parking Lots and Garages'
			WHEN usedec LIKE '%MARKET%' THEN 'Wholesale Markets'
			WHEN usedec LIKE '%MATERIAL PROCESSING%' THEN 'Material Supplies'
			WHEN usedec LIKE '%ASPHALT%' THEN 'Material Supplies'
			WHEN usedec LIKE '%AIRPORT%' THEN 'Airports and Heliports'
			WHEN usedec LIKE '%ROAD/HIGHWAY%'
				OR usedec LIKE '%TRANSIT WAY%'
				OR usedec LIKE '%OTHER TRANSPORTATION%'
				THEN 'Other Transportation'
			WHEN agency LIKE '%DEP%'
				AND (usedec LIKE '%WATER SUPPLY%'
				OR usedec LIKE '%RESERVOIR%'
				OR usedec LIKE '%AQUEDUCT%')
				THEN 'Water Supply'
			WHEN agency LIKE '%DEP%'
				AND usedec NOT LIKE '%NATURE AREA%'
				AND usedec NOT LIKE '%NATURAL AREA%'
				AND usedec NOT LIKE '%OPEN SPACE%'
				THEN 'Wastewater and Pollution Control'
			WHEN usedec LIKE '%WASTEWATER%' THEN 'Wastewater and Pollution Control'
			WHEN usedec LIKE '%LANDFILL%' 
				OR usedec LIKE '%SOLID WASTE INCINERATOR%'
				THEN 'Solid Waste Processing'
			WHEN usedec LIKE '%SOLID WASTE TRANSFER%'
				OR (agency LIKE '%SANIT%' AND usedec LIKE '%SANITATION SECTION%')
				THEN 'Solid Waste Transfer and Carting'
			WHEN usedec LIKE '%ANTENNA%' OR usedec LIKE '%TELE/COMP%' THEN 'Telecommunications'
			WHEN usedec LIKE '%PIER - MARITIME%'
				OR usedec LIKE '%FERRY%' 
				OR usedec LIKE '%WATERFRONT TRANSPORTATION%'
				OR usedec LIKE '%MARINA%'
				THEN 'Ports and Ferry Landings'
			WHEN usedec LIKE '%RAIL%'
				OR (usedec LIKE '%TRANSIT%'
					AND usedec NOT LIKE '%TRANSITIONAL%')
				THEN 'Rail Yards and Maintenance'
			WHEN usedec LIKE '%BUS%' THEN 'Bus Depots and Terminals'

			-- Health and Human
			WHEN agency LIKE '%HHC%' THEN 'Hospitals and Clinics'
			WHEN usedec LIKE '%HOSPITAL%' THEN 'Hospitals and Clinics'
			WHEN usedec LIKE '%AMBULATORY HEALTH%' THEN 'Hospitals and Clinics'
			WHEN agency LIKE '%OCME%' THEN 'Other Health Care'
			WHEN agency LIKE '%ACS%' AND usedec LIKE '%HOUSING%' THEN 'Shelters and Transitional Housing'
			WHEN agency LIKE '%AGING%' THEN 'Senior Services'
			WHEN (agency LIKE '%DHS%' OR agency LIKE '%HRA%')
				AND (usedec LIKE '%RESIDENTIAL%'
				OR usedec LIKE '%TRANSITIONAL HOUSING%')
				THEN 'Shelters and Transitional Housing'
			WHEN agency LIKE '%DHS%' AND usedec NOT LIKE '%OPEN SPACE%' THEN 'Non-residential Housing and Homeless Services'
			WHEN (agency LIKE '%NYCHA%' 
				OR agency LIKE '%HPD%')
				AND usedec LIKE '%RESIDENTIAL%'
				THEN 'Public or Affordable Housing'
			WHEN usedec LIKE '%COMMUNITY CENTER%' OR (agency LIKE '%HRA%' AND name LIKE '%CENTER%') 
				THEN 'Community Centers and Community School Programs'

			-- Parks, Cultural
			WHEN usedec LIKE '%LIBRARY%' THEN 'Public Libraries'
			WHEN usedec LIKE '%MUSEUM%' THEN 'Museums'
			WHEN usedec LIKE '%CULTURAL%' THEN 'Other Cultural Institutions'
			WHEN usedec LIKE '%ZOO%' THEN 'Other Cultural Institutions'
			WHEN usedec LIKE '%CEMETERY%' THEN 'Cemeteries'
			WHEN agency LIKE '%CULT%' AND usedec LIKE '%MUSEUM%' THEN 'Museums'
			WHEN agency LIKE '%CULT%' THEN 'Other Cultural Institutions'
			WHEN usedec LIKE '%NATURAL AREA%'
				OR (usedec LIKE '%OPEN SPACE%'
					AND agency LIKE '%DEP%')
				THEN 'Preserves and Conservation Areas'
			WHEN usedec LIKE '%BOTANICAL GARDENS%' THEN 'Other Cultural Institutions'
			WHEN usedec LIKE '%GARDEN%' THEN 'Gardens'
			WHEN agency LIKE '%PARKS%'
				AND usedec LIKE '%OPEN SPACE%'
				THEN 'Streetscapes, Plazas, and Malls'
			WHEN usedec = 'MALL/TRIANGLE/HIGHWAY STRIP/PARK STRIP'
				THEN 'Streetscapes, Plazas, and Malls'
			WHEN usedec LIKE '%PARK%' THEN 'Parks'
			WHEN usedec LIKE '%PLAZA%'
				OR usedec LIKE '%SITTING AREA%' 
				THEN 'Streetscapes, Plazas, and Malls'
			WHEN usedec LIKE '%PLAYGROUND%'
				OR usedec LIKE '%SPORTS%'
				OR usedec LIKE '%TENNIS COURT%'
				OR usedec LIKE '%PLAY AREA%'
				OR usedec LIKE '%RECREATION%'
				OR usedec LIKE '%BEACH%'
				OR usedec LIKE '%PLAYING FIELD%'
				OR usedec LIKE '%GOLF COURSE%'
				OR usedec LIKE '%POOL%'
				OR usedec LIKE '%STADIUM%'
				THEN 'Recreation and Waterfront Sites'
			WHEN usedec LIKE '%THEATER%' AND agency LIKE '%DSBS%'
				THEN 'Other Cultural Institutions'

			-- Public Safety, Justice etc
			WHEN agency LIKE '%ACS%' AND usedec LIKE '%DETENTION%' THEN 'Detention and Correctional'
			WHEN agency LIKE '%CORR%' AND usedec LIKE '%COURT%' THEN 'Courthouses and Judicial'
			WHEN agency LIKE '%CORR%' THEN 'Detention and Correctional'
			WHEN agency LIKE '%COURT%' AND usedec LIKE '%COURT%' THEN 'Courthouses and Judicial'
			WHEN usedec LIKE '%AMBULANCE%' THEN 'Other Emergency Services'
			WHEN usedec LIKE '%EMERGENCY MEDICAL%' THEN 'Other Emergency Services'
			WHEN usedec LIKE '%FIREHOUSE%' THEN 'Fire Services'
			WHEN usedec LIKE '%POLICE STATION%' THEN 'Police Services'
			WHEN usedec LIKE '%PUBLIC SAFETY%' THEN 'Other Public Safety'
			WHEN agency LIKE '%OCME%' THEN 'Forensics'

			-- Education, Children, Youth
			WHEN usedec LIKE '%UNIVERSITY%' THEN 'Colleges or Universities'
			WHEN usedec LIKE '%EARLY CHILDHOOD%' THEN 'Child Care'
			WHEN usedec LIKE '%DAY CARE%' THEN 'Child Care'
			WHEN agency LIKE '%ACS%' AND usedec LIKE '%RESIDENTIAL%' THEN 'Foster Care Services and Residential Care'
			WHEN agency LIKE '%ACS%' THEN 'Child Care'
			WHEN agency LIKE '%EDUC%' and usedec LIKE '%PLAY AREA%' THEN 'Public K-12 Schools'
			WHEN usedec LIKE '%HIGH SCHOOL%' THEN 'Public K-12 Schools'
			WHEN agency LIKE '%CUNY%' AND usedec NOT LIKE '%OPEN SPACE%' THEN 'Colleges or Universities'
			WHEN AGENCY LIKE '%EDUC%' AND usedec LIKE '%SCHOOL%' THEN 'Public K-12 Schools'
			WHEN usedec LIKE '%EDUCATIONAL SKILLS%' THEN 'Public K-12 Schools'

			ELSE 'Miscellaneous Use'
		END),
    -- facilitytype
	initcap(REPLACE(usedec, 'OTHER ', '')),
	-- propertytype
	(CASE
		WHEN type='OF' THEN 'City Owned'
		WHEN type='LF' THEN 'City Leased'
	END),
	-- operatortype
	(CASE
		WHEN agency = 'PRIV' THEN 'Non-public'
		ELSE 'Public'
	END),
	-- operatorname
		(CASE
			WHEN agency='ACS' THEN 'NYC Administration for Childrens Services'
			WHEN agency='ACTRY' THEN 'NYC Office of the Actuary'
			WHEN agency='AGING' THEN 'NYC Department for the Aging'
			WHEN agency='BIC' THEN 'NYC Business Integrity Commission'
			WHEN agency='BLDGS' THEN 'NYC Department of Buildings'
			WHEN agency='BP-BK' THEN 'NYC Borough President - Brooklyn'
			WHEN agency='BP-BX' THEN 'NYC Borough President - Bronx'
			WHEN agency='BP-MN' THEN 'NYC Borough President - Manhattan'
			WHEN agency='BP-QN' THEN 'NYC Borough President - Queens'
			WHEN agency='BP-SI' THEN 'NYC Borough President - Staten Island'
			WHEN agency='BPL' THEN 'Brooklyn Public Library'
			WHEN agency='BSA' THEN 'NYC Board of Standards and Appeals'
			WHEN agency LIKE 'CB%' THEN REPLACE(CONCAT('NYC ', initcap(boro), ' Community Board ', RIGHT(agency,2)),' 0',' ')
			WHEN agency='CCRB' THEN 'NYC Civilian Complaint Review Board'
			WHEN agency='CEO' THEN 'NYC Center for Economic Opportunity'
			WHEN agency='CFB' THEN 'NYC Campaign Finance Board'
			WHEN agency='CIVIL' THEN 'NYC Civil Service Commission'
			WHEN agency='CLERK' THEN 'NYC Office of the City Clerk'
			WHEN agency='COIB' THEN 'NYC Conflict of Interest Board'
			WHEN agency='COMPT' THEN 'NYC Office of the Comptroller'
			WHEN agency='CORR' THEN 'NYC Department of Correction'
			WHEN agency='COUNC' THEN 'NYC City Council'
			WHEN agency='COURT' THEN 'NYS Unified Court System'
			WHEN agency='CULT' THEN 'NYC Department of Cultural Affairs'
			WHEN agency='CUNY' THEN 'City University of New York'
			WHEN agency='DA-BK' THEN 'NYC District Attorney - Brooklyn'
			WHEN agency='DA-BX' THEN 'NYC District Attorney - Bronx '
			WHEN agency='DA-MN' THEN 'NYC District Attorney - Manhattan'
			WHEN agency='DA-QN' THEN 'NYC District Attorney - Queens'
			WHEN agency='DA-SI' THEN 'NYC District Attorney - Staten Island'
			WHEN agency='DA-SP' THEN 'NYC District Attorney - Office Special Narcotics'
			WHEN agency='DCA' THEN 'NYC Department of Consumer Affairs'
			WHEN agency='DCAS' THEN 'NYC Department of Citywide Administrative Services'
			WHEN agency='DDC' THEN 'NYC Department of Design and Construction'
			WHEN agency='DEP' THEN 'NYC Department of Environmental Protection'
			WHEN agency='DHS' THEN 'NYC Department of Homeless Services'
			WHEN agency='DOI' THEN 'NYC Department of Investigation'
			WHEN agency='DOITT' THEN 'NYC Department of Information Technology and Telecommunications'
			WHEN agency='DORIS' THEN 'NYC Department of Records and Information Services'
			WHEN agency='DOT' THEN 'NYC Department of Transportation'
			WHEN agency='DSBS' THEN 'NYC Department of Small Business Services'
			WHEN agency='DYCD' THEN 'NYC Department of Youth and Community Development'
			WHEN agency='EDC' THEN 'NYC Economic Development Corporation'
			WHEN agency='EDUC' THEN 'NYC Department of Education'
			WHEN agency='ELECT' THEN 'NYC Board of Elections'
			WHEN agency='FINAN' THEN 'NYC Department of Finance'
			WHEN agency='FIRE' THEN 'NYC Fire Department'
			WHEN agency='FISA' THEN 'NYC Financial Information Services Agency'
			WHEN agency='HHC' THEN 'NYC Health and Hospitals Corporation'
			WHEN agency='HLTH' THEN 'NYC Department of Health and Mental Hygiene'
			WHEN agency='HPD' THEN 'NYC Department of Housing Preservation and Development'
			WHEN agency='HRA' THEN 'NYC Human Resources Administration/Department of Social Services'
			WHEN agency='HUMRT' THEN 'NYC Commission on Human Rights'
			WHEN agency='HYDC' THEN 'Hudson Yards Development Corporation'
			WHEN agency='IBO' THEN 'NYC Independent Budget Office'
			WHEN agency='LAW' THEN 'NYC Law Department'
			WHEN agency='LDMKS' THEN 'NYC Landmarks Preservation Commission'
			WHEN agency='MAYOR' THEN 'NYC Office of the Mayor'
			WHEN agency='MOME' THEN 'NYC Office of the Mayor'
			WHEN agency='MTA' THEN 'Metropolitan Transportation Authority'
			WHEN agency='NYCHA' THEN 'NYC Housing Authority'
			WHEN agency='NYCTA' THEN 'Metropolitan Transportation Authority'
			WHEN agency='NYPD' THEN 'NYC Police Department'
			WHEN agency='NYPL' THEN 'New York Public Library'
			WHEN agency='OATH' THEN 'NYC Office of Administrative Trials and Hearings'
			WHEN agency='OCA' THEN 'NYC Office of Court Administration'
			WHEN agency='OCB' THEN 'NYC Office of Collective Bargaining'
			WHEN agency='OCME' THEN 'NYC Office of the Medical Examiner'
			WHEN agency='OEM' THEN 'NYC Office of Emergency Management'
			WHEN agency='OLR' THEN 'NYC Office of Labor Relations'
			WHEN agency='OMB' THEN 'NYC Office of Management and Budget'
			WHEN agency='OPA' THEN 'NYC Office of Payroll Administration'
			WHEN agency='PA-BK' THEN 'NYC Public Administrators Office - Brooklyn'
			WHEN agency='PA-BX' THEN 'NYC Public Administrators Office - Bronx'
			WHEN agency='PA-MN' THEN 'NYC Public Administrators Office - Manhattan'
			WHEN agency='PA-QN' THEN 'NYC Public Administrators Office - Queens'
			WHEN agency='PA-SI' THEN 'NYC Public Administrators Office - Staten Island'
			WHEN agency='PARKS' THEN 'NYC Department of Parks and Recreation'
			WHEN agency='PBADV' THEN 'NYC Office of Public Advocate'
			WHEN agency='PLAN' THEN 'NYC Department of City Planning'
			WHEN agency='PRIV' THEN 'Non-public'
			WHEN agency='PROB' THEN 'NYC Department of Probation'
			WHEN agency='QPL' THEN 'Queens Public Library'
			WHEN agency='SANIT' THEN 'NYC Department of Sanitation'
			WHEN agency='TAXCM' THEN 'NYC Tax Commission'
			WHEN agency='TBTA' THEN 'Metropolitan Transportation Authority'
			WHEN agency='TLC' THEN 'NYC Taxi and Limousine Commission'
			WHEN agency='UNKN' THEN 'NYC Unknown'
		END),
	-- operatorabbrev
		(CASE
			WHEN agency='HYDC' THEN 'HYDC'
			WHEN agency='MTA' THEN 'MTA'
			WHEN agency='NYCTA' THEN 'MTA'
			WHEN agency='TBTA' THEN 'MTA'
			WHEN agency='PARKS' THEN 'NYCDPR'
			WHEN agency='BLDGS' THEN 'NYCDOB'
			WHEN agency='BPL' THEN 'BPL'
			WHEN agency='NYPL' THEN 'NYPL'
			WHEN agency='QPL' THEN 'QPL'
			WHEN agency='SANIT' THEN 'NYCDSNY'
			WHEN agency='AGING' THEN 'NYCDFTA'
			WHEN agency='EDUC' THEN 'NYCDOE'
			WHEN agency='CULT' THEN 'NYCDCLA'
			WHEN agency='CORR' THEN 'NYCDOC'
			WHEN agency='FIRE' THEN 'NYCFDNY'
			WHEN agency='HLTH' THEN 'NYCDOHMH'
			WHEN agency='ELECT' THEN 'NYCBOE'
			WHEN agency='CIVIL' THEN 'NYCCSC'
			WHEN agency='HUMRT' THEN 'NYCCCHR'
			WHEN agency='COUNC' THEN 'NYCCOUNCIL'
			WHEN agency='PLAN' THEN 'NYCDCP'
			WHEN agency='FINAN' THEN 'NYCDOF'
			WHEN agency='PROB' THEN 'NYCDOP'
			WHEN agency='DSBS' THEN 'NYCSBS'
			WHEN agency='FIRE' THEN 'FDNY'
			WHEN agency='NYPD' THEN 'NYPD'
			WHEN agency='HRA' THEN 'NYCHRA/DSS'
			WHEN agency='DA-SP' THEN 'NYCDA-SNP'
			WHEN agency='LDMKS' THEN 'NYCLPC'
			WHEN agency='OEM' THEN 'NYCEM'
			WHEN agency='PBADV' THEN 'NYCPA'
			WHEN agency='ACTRY' THEN 'NYCACT'
			WHEN agency='COMPT' THEN 'NYCCOMP'
			WHEN agency='MAYOR' THEN 'NYCMO'
			WHEN agency='MOME' THEN 'NYCMO'
			WHEN agency='TAX' THEN 'NYCTC'
			WHEN agency='COURT' THEN 'NYCOURTS'
			WHEN agency='CUNY' THEN 'CUNY'
			WHEN agency='PRIV' THEN 'Non-public'
			WHEN agency='UNKN' THEN 'NYC-Unknown'
			ELSE CONCAT('NYC',agency)
		END),
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
		(CASE WHEN usedec LIKE '%RESIDENTIAL%' AND usedec NOT LIKE '%NON RESIDENTIAL%' THEN TRUE
			ELSE FALSE
		END)
FROM 
	dcas_facilities_colp
WHERE
	(agency <> 'NYCHA'
	AND agency <> 'HPD'
	AND usedec <> 'ROAD/HIGHWAY'
	AND usedec <> 'TRANSIT WAY'
	AND usedec NOT LIKE '%WATER SUPPLY%'
	AND usedec NOT LIKE '%RESERVOIR%'
	AND usedec NOT LIKE '%AQUEDUCT%'
	AND agency <> 'DHS')
	OR (agency = 'DHS' AND usedec NOT LIKE '%RESIDENTIAL%' AND usedec NOT LIKE '%HOUSING%')
	OR (agency = 'HRA' AND usedec NOT LIKE '%RESIDENTIAL%' AND usedec NOT LIKE '%HOUSING%')
	OR (agency = 'ACS' AND usedec NOT LIKE '%RESIDENTIAL%' AND usedec NOT LIKE '%HOUSING%')
;
-- end select
UPDATE facilities
SET facname = CONCAT(opname, ' ', facname)
WHERE facname = 'Office';

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dcas_facilities_colp
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
) AND
        (agency <> 'NYCHA'
	AND agency <> 'HPD'
	AND usedec <> 'ROAD/HIGHWAY'
	AND usedec <> 'TRANSIT WAY'
	AND usedec NOT LIKE '%WATER SUPPLY%'
	AND usedec NOT LIKE '%RESERVOIR%'
	AND usedec NOT LIKE '%AQUEDUCT%'
	AND agency <> 'DHS')
	OR (agency = 'DHS' AND usedec NOT LIKE '%RESIDENTIAL%' AND usedec NOT LIKE '%HOUSING%')
	OR (agency = 'HRA' AND usedec NOT LIKE '%RESIDENTIAL%' AND usedec NOT LIKE '%HOUSING%')
	OR (agency = 'ACS' AND usedec NOT LIKE '%RESIDENTIAL%' AND usedec NOT LIKE '%HOUSING%')
; 
-- JOIN uid FROM KEY ONTO DATABASE
UPDATE facilities AS f
SET uid = k.uid
FROM facdb_uid_key AS k
WHERE k.hash = f.hash AND
      f.uid IS NULL;

-- pgtable
INSERT INTO
facdb_pgtable(
   uid,
   pgtable
)
SELECT
	uid,
	'dcas_facilities_colp'
FROM dcas_facilities_colp, facilities
WHERE facilities.hash = dcas_facilities_colp.hash;

-- agency id
INSERT INTO
facdb_agencyid(
	uid,
	idagency,
	idname,
	idfield,
	idtable
)
SELECT
	uid,
	gid,
	'Global ID',
	'gid',
	'dcas_facilities_colp'
FROM dcas_facilities_colp, facilities
WHERE facilities.hash = dcas_facilities_colp.hash;

-- area NA

-- bbl
INSERT INTO
facdb_bbl(
	uid,
	bbl)
SELECT uid,
    (CASE
	    WHEN dcas_facilities_colp.boro = 'MANHATTAN' THEN CONCAT('1',LPAD(block::text, 5, '0'),LPAD(lot::text, 4, '0'))::text
	    WHEN dcas_facilities_colp.boro = 'BRONX' THEN CONCAT('2',LPAD(block::text, 5, '0'),LPAD(lot::text, 4, '0'))::text
	    WHEN dcas_facilities_colp.boro = 'BROOKLYN' THEN CONCAT('3',LPAD(block::text, 5, '0'),LPAD(lot::text, 4, '0'))::text
	    WHEN dcas_facilities_colp.boro = 'QUEENS' THEN CONCAT('4',LPAD(block::text, 5, '0'),LPAD(lot::text, 4, '0'))::text
	    WHEN dcas_facilities_colp.boro = 'STATEN ISLAND' THEN CONCAT('5',LPAD(block::text, 5, '0'),LPAD(lot::text, 4, '0'))::text
	END)
FROM dcas_facilities_colp, facilities
WHERE facilities.hash = dcas_facilities_colp.hash;

-- bin NA

-- capacity NA

-- oversight
INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
    opname,
    opabbrev,
    (CASE
       WHEN (opabbrev = 'MTA' OR
            opabbrev = 'NYCHA' OR
            opabbrev = 'PANYNJ')
       THEN 'State Authority'
       ELSE 'City'
    END
    )
FROM dcas_facilities_colp, facilities
WHERE facilities.hash = dcas_facilities_colp.hash;

-- utilization NA