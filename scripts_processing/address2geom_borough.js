/////////////////////////////////////////////////////////////////////////////////////////////////////////
// PROCESS OVERVIEW
/////////////////////////////////////////////////////////////////////////////////////////////////////////

// Select all records with null geoms and a borough value
// Geocode using borough and address -- prints errors and and skips to keep going
// Reject records do not get updated in the database.

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 1 --- LOADING DEPENDENCIES
/////////////////////////////////////////////////////////////////////////////////////////////////////////


// REQUIRE CODE LIBRARY DEPENDENCIES
var pgp = require('pg-promise')(), 
  request = require('request'),
  Mustache = require('mustache');

// REQUIRE JS FILE WITH API CREDENTIALS -- USED IN addressLookup FUNCTION
// ALSO REQUIRES JS SILE WITH DATABASE CONFIGURATION
var config = require('./dbconfig.js'),
  apiCredentials = require('./apiCredentials.js');

// USE DATABASE CONFIGURATION JS FILE TO LINK TO DATABASE
var db = pgp(config);


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 2 --- DEFINING THE QUERY USED TO FIND NULL GEOMETRIES
/////////////////////////////////////////////////////////////////////////////////////////////////////////


// querying for records without geoms
var nullGeomQuery = 'SELECT DISTINCT borough, addressnumber, streetname FROM facilities WHERE geom IS NULL AND addressnumber IS NOT NULL AND streetname IS NOT NULL AND borough IS NOT NULL';


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 3 --- APPLYING THE nullGeomQuery IN THE DATABASE TO FIND RECORDS WITH NULL GEOM
/////////////////////////////////////////////////////////////////////////////////////////////////////////


var i=0;
var nullGeomResults;

db.any(nullGeomQuery)
  .then(function (data) { 
    nullGeomResults = data

    console.log('Found ' + nullGeomResults.length + ' null geometries in facilities ')
    addressLookup1(nullGeomResults[i]);
  })
  .catch(function(err) {
    console.log(err)
  })


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 4 --- SETTING TEMPLATES FOR REQUEST TO API -- REQUIRES ADDRESS#, STREET NAME, AND BOROUGH OR ZIP
/////////////////////////////////////////////////////////////////////////////////////////////////////////


// records without geoms and with boro
var geoclientTemplate1 = 'https://api.cityofnewyork.us/geoclient/v1/address.json?houseNumber={{housenumber}}&street={{{streetname}}}&borough={{borough}}&app_id={{app_id}}&app_key={{app_key}}';


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 5 --- DEFINES AND RUNS FUNCTION WHICH LOOKS UP ADDRESSES USING geoclientTemplate
/////////////////////////////////////////////////////////////////////////////////////////////////////////


function addressLookup1(row) {
  console.log('Looking up address', row.borough.trim(), row.addressnumber.trim(), row.streetname.split(',')[0].split('#')[0].split(' - ')[0].trim())

      var apiCall1 = Mustache.render(geoclientTemplate1, {
        
        // MAKE SURE THESE MATCH THE FIELD NAMES
        housenumber: row.addressnumber.replace("/", "").replace("\"", "").replace("!", "").trim(),
        streetname: row.streetname.split(',')[0].split('#')[0].split(' - ')[0].split('(')[0].split(';')[0].split('Suite')[0].split('Ste')[0].split('Apt')[0].split('apt')[0].split('Room')[0].split('Rm')[0].split('Box')[0].split('Unit')[0].trim(),
        borough: row.borough.trim(),
        app_id: apiCredentials.app_id,
        app_key: apiCredentials.app_key
      })

      // console.log(apiCall1);

      request(apiCall1, function(err, response, body) {
          console.log(err)
          // A. try PARSING json
          try { 
            var data = JSON.parse(body)
            // B. try getting ADDRESS from data response
            try {
              data = data.address;
              // C. try UPDATING facilities with the address from data
              try {
                updateFacilities(data, row)
              // C. catch error when UPDATING facilities table
              } catch (e) {
                console.log(data)
                i++;
                console.log(i,nullGeomResults.length)
                  if (i<nullGeomResults.length) {
                    addressLookup1(nullGeomResults[i])
                  }
              }
            // B. catch error with getting ADDRESS from data response
            } catch (e) {
              i++;
              console.log(i,nullGeomResults.length)
              if (i<nullGeomResults.length) {
                addressLookup1(nullGeomResults[i])
              }
            }
          // A. catch error with PARSING json
          } catch (e) {
            i++;
            console.log(i,nullGeomResults.length)
            if (i<nullGeomResults.length) {
              addressLookup1(nullGeomResults[i])
            }
          }
      })
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 6 --- DEFINES/RUNS FUNCTION updateFacilities 
/////////////////////////////////////////////////////////////////////////////////////////////////////////


function updateFacilities(data, row) {

  var insertTemplate = 'UPDATE facilities SET geom=ST_SetSRID(ST_GeomFromText(\'POINT({{longitude}} {{latitude}})\'),4326), latitude=\'{{latitude}}\', longitude=\'{{longitude}}\', addressnumber=\'{{newaddressnumber}}\', streetname=initcap(\'{{newstreetname}}\'), address=initcap(CONCAT(\'{{newaddressnumber}}\',\' \',\'{{newstreetname}}\')), bbl=ARRAY[\'{{bbl}}\'], bin=ARRAY[\'{{bin}}\'], zipcode=\'{{zipcode}}\', city=initcap(\'{{city}}\'), processingflag=\'address2geom_borough\' WHERE (addressnumber=\'{{oldaddressnumber}}\' AND streetname=\'{{oldstreetname}}\')'

  if(data.latitude && data.longitude) {
    console.log('Updating facilities');

    var insert = Mustache.render(insertTemplate, {
      
      // data. comes from api response
      latitude: data.latitude,
      longitude: data.longitude,
      xcoord: data.xCoordinate,
      ycoord: data.yCoordinate,
      bbl: data.bbl,
      bin: data.buildingIdentificationNumber,
      zipcode: data.zipCode,
      city: data.uspsPreferredCityName,
      newaddressnumber: data.houseNumber,
      newstreetname: data.boePreferredStreetName,

      // row. comes from original table row from psql query
      oldaddressnumber: row.addressnumber,
      oldstreetname: row.streetname
    })

    // console.log(insert);

    db.none(insert)
    .then(function(data) {
      i++;
      console.log(i,nullGeomResults.length)
      if (i<nullGeomResults.length) {
         addressLookup1(nullGeomResults[i])
      } else {
        console.log('Done!')
      }
      
    })
    .catch(function(err) {
      console.log(err);
    })

  } else {
    console.log('Response did not include a lat/lon, skipping...');
    i++;
        console.log(i,nullGeomResults.length)
        if (i<nullGeomResults.length) {
           addressLookup1(nullGeomResults[i])
        }
  }
}