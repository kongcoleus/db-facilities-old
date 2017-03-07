COPY (
	
	WITH inside AS (
	SELECT
		facilities.uid
	FROM
		facilities,
		dcp_boroboundaries_wi
	WHERE
		facilities.geom IS NOT NULL
		AND ST_Intersects (facilities.geom, dcp_boroboundaries_wi.geom)
	)

	SELECT
		facilities.uid,
		facilities.hash,
		facilities.idold,
		array_to_string(facilities.idagency,';') AS idagency,
		facilities.facilityname AS facname,
		facilities.addressnumber AS addressnum,
		facilities.streetname,
		facilities.address,
		facilities.city,
		facilities.borough AS boro,
		facilities.boroughcode AS borocode,
		facilities.zipcode,
		facilities.latitude,
		facilities.longitude,
		facilities.xcoord,
		facilities.ycoord,
		array_to_string(facilities.bin,';') AS bin,
		array_to_string(facilities.bbl,';') AS bbl,
		facilities.communityboard AS commboard,
		facilities.councildistrict AS council,
		facilities.censustract AS censtract,
		facilities.nta,
		facilities.domain AS facdomain,
		facilities.facilitygroup AS facgroup,
		facilities.facilitysubgroup AS facsubgrp,
		facilities.facilitytype AS factype,
		array_to_string(facilities.capacity,';') AS capacity,
		array_to_string(facilities.utilization,';') AS util,
		array_to_string(facilities.capacitytype,';') AS captype,
		array_to_string(facilities.utilizationrate,';') AS utilrate,
		array_to_string(facilities.area,';') AS area,
		array_to_string(facilities.areatype,';') AS areatype,
		facilities.propertytype AS proptype,
		facilities.operatortype AS optype,
		facilities.operatorname AS opname,
		facilities.operatorabbrev AS opabbrev,
		array_to_string(facilities.oversightlevel,';') AS overlevel,
		-- array_to_string(facilities.oversighttype,';') AS oversighttype,
		array_to_string(facilities.oversightagency,';') AS overagency,
		array_to_string(facilities.oversightabbrev,';') AS overabbrev,
		array_to_string(facilities.agencysource,';') AS datasource,
		array_to_string(facilities.sourcedatasetname,';') AS dataname,
		array_to_string(facilities.linkdata,';') AS datalink,
		array_to_string(facilities.datesourceupdated,';') AS datadate,
		-- facilities.processingflag,
		-- facilities.agencyclass1,
		-- facilities.agencyclass2,
		-- facilities.colpusetype,
		-- facilities.dateactive,
		-- facilities.dateinactive,
		-- facilities.inactivestatus,
		-- array_to_string(facilities.tags,';'),
		-- facilities.notes,
		-- array_to_string(facilities.datesourcereceived,';'),
		-- facilities.datecreated,
		-- facilities.dateedited,
		-- facilities.creator,
		-- facilities.editor,
		-- array_to_string(facilities.linkdownload,';'),
		-- array_to_string(facilities.datatype,';'),
		-- array_to_string(facilities.refreshmeans,';'),
		-- array_to_string(facilities.refreshfrequency,';'),
		array_to_string(facilities.pgtable,';') AS pgtable,
		array_to_string(facilities.uid_merged,';') AS uid_merged,
		array_to_string(facilities.hash_merged,';') AS hash_merged,
		-- facilities.buildingid,
		-- facilities.buildingname,
		-- facilities.schoolorganizationlevel,
		-- facilities.children,
		-- facilities.youth,
		-- facilities.senior,
		-- facilities.family,
		-- facilities.disabilities,
		-- facilities.dropouts,
		-- facilities.unemployed,
		-- facilities.homeless,
		-- facilities.immigrants,
		-- facilities.groupquarters,
		facilities.geom
	FROM
		facilities
	WHERE
		facilities.uid NOT IN (SELECT uid FROM inside)
	ORDER BY
		-- domain, facilitygroup, facilitysubgroup, facilitytype
		RANDOM()
) TO '/Users/hannahbkates/Desktop/facilities_unmapped.csv' WITH CSV DELIMITER ',' HEADER;