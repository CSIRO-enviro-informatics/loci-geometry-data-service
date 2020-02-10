#!/bin/bash

#download files
S3_DIR=http://loci-assets.s3-website-ap-southeast-2.amazonaws.com/source-data/

ASGS16_FILE_LIST="
asgs2016/1270055001_sa1_2016_aust_shape.zip
asgs2016/1270055001_sa2_2016_aust_shape.zip
asgs2016/1270055001_sa3_2016_aust_shape.zip
asgs2016/1270055001_sa4_2016_aust_shape.zip
asgs2016/1270055001_ste_2016_aust_shape.zip
asgs2016/1270055001_gccsa_2016_aust_shape.zip
asgs2016/1270055001_mb_2016_act_shape.zip
asgs2016/1270055001_mb_2016_nsw_shape.zip
asgs2016/1270055001_mb_2016_nt_shape.zip
asgs2016/1270055001_mb_2016_qld_shape.zip
asgs2016/1270055001_mb_2016_sa_shape.zip
asgs2016/1270055001_mb_2016_tas_shape.zip
asgs2016/1270055001_mb_2016_vic_shape.zip
asgs2016/1270055001_mb_2016_wa_shape.zip
asgs2016/1270055002_iare_2016_aust_shape.zip
asgs2016/1270055002_iloc_2016_aust_shape.zip
asgs2016/1270055002_ireg_2016_aust_shape.zip
asgs2016/1270055004_sos_2016_aust_shape.zip
asgs2016/1270055004_sosr_2016_aust_shape.zip
asgs2016/1270055004_sua_2016_aust_shape.zip
asgs2016/1270055004_ucl_2016_aust_shape.zip
asgs2016/1270055005_ra_2016_aust_shape.zip
asgs2016/1270055003_ced_2016_aust_shape.zip 
asgs2016/1270055003_lga_2016_aust_shape.zip
asgs2016/1270055003_nrmr_2016_aust_shape.zip
asgs2016/1270055003_ssc_2016_aust_shape.zip
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

for file in $GF_FILE_LIST; do
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


HOST=$PG_HOSTNAME
PORT=$PG_PORT
DB=$PG_DBNAME
USER=$PG_USER
PASS=$PG_PASS

ASGS16_MAP="
SA1_2016_AUST.shp|asgs16_sa1
SA2_2016_AUST.shp|asgs16_sa2
SA3_2016_AUST.shp|asgs16_sa3
SA4_2016_AUST.shp|asgs16_sa4
STE_2016_AUST.shp|asgs16_ste
ILOC_2016_AUST.shp|asgs16_iloc
IREG_2016_AUST.shp|asgs16_ireg
IARE_2016_AUST.shp|asgs16_iare
UCL_2016_AUST.shp|asgs16_ucl
SOSR_2016_AUST.shp|asgs16_sosr
SOS_2016_AUST.shp|asgs16_sos
SUA_2016_AUST.shp|asgs16_sua
RA_2016_AUST.shp|asgs16_ra
CED_2016_AUST.shp|asgs16_ced
LGA_2016_AUST.shp|asgs16_lga
NRMR_2016_AUST.shp|asgs16_nrmr
SSC_2016_AUST.shp|asgs16_ssc
"

# load asgs files into postgis
for map in $ASGS16_MAP; do
    ary=(${map//|/ })
    FNAME=${ary[0]}
    TNAME=${ary[1]}
    echo "Loading $FNAME into DB table: $TNAME"
    ogr2ogr -f "PostgreSQL"  PG:"host=${HOST} port=${PORT} dbname=${DB} user=${USER} password=${PASS}"  ${FNAME} -nln ${TNAME} -overwrite -progress -lco GEOMETRY_NAME=geom_3577 -lco PRECISION=NO -t_srs EPSG:3577 -nlt MULTIPOLYGON --config PG_USE_COPY YES
done


# load first asgs mb files into postgis
FNAME=MB_2016_VIC.shp
TNAME=asgs16_mb
echo "Loading $FNAME into DB table: $TNAME"
ogr2ogr -f "PostgreSQL"  PG:"host=${HOST} port=${PORT} dbname=${DB} user=${USER} password=${PASS}"  ${FNAME} -nln ${TNAME} -overwrite -progress -lco GEOMETRY_NAME=geom_3577 -lco PRECISION=NO -t_srs EPSG:3577 -nlt MULTIPOLYGON --config PG_USE_COPY YES

ASGS16_MB_LIST="
MB_2016_NSW.shp
MB_2016_ACT.shp
MB_2016_QLD.shp
MB_2016_NT.shp
MB_2016_SA.shp
MB_2016_TAS.shp
MB_2016_WA.shp
"

# load rest of asgs mb files into postgis
for mbinstance in $ASGS16_MB_LIST; do
    FNAME=${mbinstance}
    TNAME=asgs16_mb
    echo "Loading $FNAME into DB table: $TNAME"
    ogr2ogr -f "PostgreSQL"  PG:"host=${HOST} port=${PORT} dbname=${DB} user=${USER} password=${PASS}"  ${FNAME} -nln ${TNAME} -progress -lco GEOMETRY_NAME=geom_3577 -lco PRECISION=NO -t_srs EPSG:3577 -nlt MULTIPOLYGON --config PG_USE_COPY YES
done

#load geofabric
GF_MAP="
HR_Catchments_GDB/HR_Catchments.gdb|AHGFContractedCatchment|geofabric2-1-1_AHGFContractedCatchment
HR_Regions_GDB/HR_Regions.gdb|AWRADrainageDivision|geofabric2-1-1_AWRADrainageDivision 
HR_Regions_GDB/HR_Regions.gdb|RiverRegion|geofabric2-1-1_RiverRegion
"

# load asgs files into postgis
for map in $GF_MAP; do
    ary=(${map//|/ })
    FNAME=${ary[0]}
    FEAT_NAME=${ary[1]}
    TNAME=${ary[2]}
    echo "$FNAME $TNAME"
    ogr2ogr -f "PostgreSQL"  PG:"host=${HOST} port=${PORT} dbname=${DB} user=${USER} password=${PASS}" ${FNAME} -nln ${TNAME} ${FEAT_NAME} -overwrite -progress -lco GEOMETRY_NAME=geom_3577 -lco PRECISION=NO -t_srs EPSG:3577 -nlt MULTIPOLYGON --config PG_USE_COPY YES
done

#create views and count table
PGPASSWORD=$PASS psql -h $HOST -d $DB -U $USER  -p $PORT -a -w -f create_tables.sql

exit

FNAME=SA3_2016_AUST.shp
TNAME=asgs16_sa3
ogr2ogr -f "PostgreSQL"  PG:"host=${HOST} port=${PORT} dbname=${DB} user=${USER} password=${PASS}"  ${FNAME} -nln ${TNAME} -overwrite -progress -lco GEOMETRY_NAME=geom_3577 -lco PRECISION=NO -t_srs EPSG:3577 -nlt MULTIPOLYGON --config PG_USE_COPY YES

FNAME=HR_Regions_GDB/HR_Regions.gdb
FEAT_NAME=AWRADrainageDivision
TNAME=geofabric2-1-1_AWRADrainageDivision
ogr2ogr -f "PostgreSQL"  PG:"host=${HOST} port=${PORT} dbname=${DB} user=${USER} password=${PASS}"  ${FNAME} -nln ${TNAME} ${FEAT_NAME} -overwrite -progress -lco GEOMETRY_NAME=geom_3577 -lco PRECISION=NO -t_srs EPSG:3577 -nlt MULTIPOLYGON --config PG_USE_COPY YES

