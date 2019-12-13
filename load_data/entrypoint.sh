#!/bin/bash

#download files
S3_DIR=http://loci-assets.s3-website-ap-southeast-2.amazonaws.com/source-data/

ASGS16_FILE_LIST="
asgs2016/1270055001_sa1_2016_aust_shape.zip
asgs2016/1270055001_sa2_2016_aust_shape.zip
asgs2016/1270055001_sa3_2016_aust_shape.zip
asgs2016/1270055001_sa4_2016_aust_shape.zip
asgs2016/1270055001_ste_2016_aust_shape.zip
"

GF_FILE_LIST="
geofabric_2-1/HR_Catchments_GDB_V2_1_1.zip
geofabric_2-1/HR_Regions_GDB_V2_1_1.zip
"

# Iterate and download all files
for file in $ASGS16_FILE_LIST; do
    url=${S3_DIR}${file}
    filename=${file##*/}
    echo $url
    if [ -f "$filename" ]; then
	       echo "$filename exist"
    else 
       echo "wget $url"
       wget $url
    fi


    #unzip 
    unzip -o $filename
done


HOST=localhost
PORT=25432
DB=gis
USER=jon
PASS=jon

ASGS16_MAP="
SA1_2016_AUST.shp|asgs16_sa1
SA2_2016_AUST.shp|asgs16_sa2
SA3_2016_AUST.shp|asgs16_sa3
SA4_2016_AUST.shp|asgs16_sa4
STE_2016_AUST.shp|asgs16_ste
"

# load asgs files into postgis
for map in $ASGS16_MAP; do
    ary=(${map//|/ })
    FNAME=${ary[0]}
    TNAME=${ary[1]}
    echo "$FNAME $TNAME"
    ogr2ogr -f "PostgreSQL"  PG:"host=${HOST} port=${PORT} dbname=${DB} user=${USER} password=${PASS}"  ${FNAME} -nln ${TNAME} -overwrite -progress -lco GEOMETRY_NAME=geom_3577 -lco PRECISION=NO -t_srs EPSG:3577 -nlt MULTIPOLYGON --config PG_USE_COPY YES
done


exit

FNAME=SA3_2016_AUST.shp
TNAME=asgs16_sa3
ogr2ogr -f "PostgreSQL"  PG:"host=${HOST} port=${PORT} dbname=${DB} user=${USER} password=${PASS}"  ${FNAME} -nln ${TNAME} -overwrite -progress -lco GEOMETRY_NAME=geom_3577 -lco PRECISION=NO -t_srs EPSG:3577 -nlt MULTIPOLYGON --config PG_USE_COPY YES

FNAME=HR_Regions_GDB/HR_Regions.gdb
FEAT_NAME=AWRADrainageDivision
TNAME=geofabric2-1-1_AWRADrainageDivision
ogr2ogr -f "PostgreSQL"  PG:"host=${HOST} port=${PORT} dbname=${DB} user=${USER} password=${PASS}"  ${FNAME} -nln ${TNAME} ${FEAT_NAME} -overwrite -progress -lco GEOMETRY_NAME=geom_3577 -lco PRECISION=NO -t_srs EPSG:3577 -nlt MULTIPOLYGON --config PG_USE_COPY YES

