#!/bin/bash

# author: Bruno Combal, IOC-UNESCO
# date: April, 2015

# get the list of arrangements shapefiles, transform into rasters
# count the number of overlaid pixels (=redundancy in arrangements geographic coverage)

# definitions
shpDir='/Users/bruno/Documents/data/arrangements/' # directory storing the shapfiles
tmpDir='/Users/bruno/Documents/data/tmp/' # a working directory. Files in this directory won't be kept
mkdir -p $tmpDir
outDir='/Users/bruno/Documents/data/arrangements_out' # output directory
mkdir -p $outDir
TE=(-180 -90 180 90)
# 10 km at the equator
xyres=`echo "scale=12; 10/112" | bc`
TR=($xyres $xyres)

function exitMessage(){
    echo $1
    exit $2
}

# this function returns the list of shapfiles to process
# can be adapted to specific needs
function doCleanShpList(){
    find ${shpDir} -type f -name *.shp -exec basename {} \; #print name of any shapefile
    }

# ____ main ____

lstShp=($(doCleanShpList))


if [ ${#lstShp[@]} -eq 0 ]; then
    exitMessage "Found no shapefile in ${shpDir}" 1
fi

# transform shapefiles into rasters
# burn 1 in each raster
lstRaster=''
for shpFile in ${lstShp[@]}
do
    rasterFile=${shpFile%.shp}.tif
    layerName=`ogrinfo -q ${shpDir}/${shpFile} | cut -d ' ' -f 2`
    echo ${layerName}" --> "$rasterFile
    gdal_rasterize -init 0 -a_srs 'epsg:4326' -te "${TE[@]}" -tr "${TR[@]}" -ot GDT_Byte -of Gtiff -co "compress=lzw" -burn 1 -l ${layerName} ${shpDir}/${shpFile}  ${tmpDir}/${rasterFile}
    lstRaster=(${lstRaster[@]} ${rasterFile})
done

# create a 0 image for the sum
sumFile=${outDir}/sum_arrangements.tif
gdal_calc.py -A ${tmpDir}/${lstRaster[0]} --outfile=${sumFile} --calc="A*0"

# and now add all values
for ii in ${lstRaster[@]}
do
    tempFile=${tmpDir}/addition_${RANDOM}.tif
    gdal_calc.py -of gtiff -co "compress=lzw" -A ${tmpDir}/${ii} -B ${sumFile} --calc="A+B" --outfile=${tempFile}
    mv ${tempFile} ${sumFile}
done


# end of script
