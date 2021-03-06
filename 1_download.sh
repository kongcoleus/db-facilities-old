################################################################################################
### OBTAINING DATA
################################################################################################
### NOTE: This script requires that you setup the DATABASE_URL environment variable.
### Directions are in the README.md.

## Load all datasets from sources using civic data loader
## https://github.com/NYCPlanning/data-loading-scripts

cd '/prod/data-loading-scripts'
pwd

## Open_datasets - PULLING FROM OPEN DATA
echo 'Loading FacDB helper files...'
node loader.js install facdb_datasources
node loader.js install facdb_uid_key
node loader.js install dcp_facilities_togeocode

echo 'Loading open source datasets...'
## Data you probably already have loaded
node loader.js install dcp_mappluto
# node loader.js install doitt_buildingfootprints
node loader.js install dcp_boroboundaries_wi
node loader.js install dcp_cdboundaries
node loader.js install dcp_censustracts
node loader.js install dcp_councildistricts
node loader.js install dcp_ntaboundaries
node loader.js install doitt_zipcodes

## Data you probably don't have loaded
node loader.js install acs_facilities_daycareheadstart
node loader.js install bic_facilities_tradewaste
node loader.js install dca_facilities_operatingbusinesses
node loader.js install dcla_facilities_culturalinstitutions
node loader.js install dcp_facilities_sfpsd
node loader.js install dcp_pops
node loader.js install dfta_facilities_contracts
node loader.js install doe_facilities_busroutesgarages
node loader.js install doe_facilities_lcgms
node loader.js install doe_facilities_universalprek
node loader.js install dohmh_facilities_daycare
node loader.js install dot_parkingfacilities
node loader.js install dpr_parksproperties
node loader.js install dycd_facilities_afterschoolprograms

node loader.js install hhc_facilities_hospitals
node loader.js install hra_centers

node loader.js install nycha_facilities_policeservice
node loader.js install nysdec_facilities_lands
node loader.js install nysdec_facilities_solidwaste
node loader.js install nysdoh_facilities_healthfacilities
node loader.js install nysdoh_nursinghomebedcensus
node loader.js install nysomh_facilities_mentalhealth
node loader.js install nysopwdd_facilities_providers
node loader.js install nysparks_facilities_historicplaces
node loader.js install nysparks_facilities_parks
node loader.js install sbs_facilities_workforce1
node loader.js install usdot_facilities_airports
node loader.js install usdot_facilities_ports
node loader.js install usnps_facilities_parks


echo 'Done loading open source datasets. Moving on to "other" datasets...'
## Other_datasets - PULLING FROM FTP SITE
node loader.js install dcas_facilities_colp
node loader.js install doe_facilities_schoolsbluebook
node loader.js install dot_facilities_pedplazas
node loader.js install dot_facilities_bridgehouses
node loader.js install dot_facilities_ferryterminalslandings
node loader.js install dot_facilities_mannedfacilities
node loader.js install dsny_facilities_mtsgaragemaintenance
node loader.js install foodbankny_facilities_foodbanks
node loader.js install hhs_facilities_fmscontracts
node loader.js install hhs_facilities_financialscontracts
node loader.js install hhs_facilities_proposals
node loader.js install nysoasas_facilities_programs ## download from here https://www.oasas.ny.gov/providerDirectory/index.cfm?search_type=2
node loader.js install nysed_facilities_activeinstitutions ## download from here https://eservices.nysed.gov/sedreports/list?id=1
node loader.js install nysed_nonpublicenrollment ## download from here http://www.p12.nysed.gov/irs/statistics/nonpublic/
node loader.js install omb_facilities_libraryvisits
# node loader.js install dycd_facilities_compass
# node loader.js install dycd_facilities_otherprograms
# node loader.js install hra_facilities_centers
# node loader.js install dhs_facilities_shelters

echo 'Done loading other source datasets'
cd '../facilities-db'
