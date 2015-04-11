#!/bin/bash

# author: Bruno Combal, IOC-UNESCO
# date: April, 2015

# get the list of arrangements shapefiles, transform into rasters
# count the number of overlaid pixels (=redundancy in arrangements geographic coverage)



# definitions
shpDir='' # directory storing the shapfiles
tmpDir='' # a working directory. Files in this directory won't be kept
mkdir -p $tmpDir
outDir='' # output directory
mkdir -p $outDir
TE=(-180 -90 180 90)
xyres=`echo "scale 12; 1/112" | bc`
TR=($xyres $xyres)

function exitMessage(){
    echo $1
    exit $2
}

# this function returns the list of shapfiles to process
# can be adapted to specific needs
function doCleanShpList(){
    find {shpDir} *.shp -print "%f\n" #print name of any shapefile
}

# ____ main ____

lstShp=(${doCleanShpList})

if [ -n ${#lstShp[@]} ]; then
    exitMessage "Found no shapefile in ${shpDir}" 1
fi

# transform shapefiles into rasters
# burn 1 in each raster
lstRaster=''
for shpFile in ${lstShp[#]}
do
    rasterFile=${shpFile%.shp}.tif
    layerName=`cut -d ' ' -f 2 ${$shpDir}/${shpFile}`
    gdal_rasterize -init 0 -a_srs 'epsg:4326' -te "${TE[@]}" -tr "${TR[@]}" -ot GDT_Byte -of Gtiff -co "compress=lzw" -burn 1 -l ${layerName} ${shpDir}/${shpFile}  ${tmpDir}/${rasterFile}
    lstRaster=(${lstRaster[@]} ${rasterFile})
done

# create a 0 image for the sum
sumFile=${outDir}/sum_arrangements.tif
gdal_calc.py -A ${tmpDir}/${lstRaster[0]} --outfile=${sumFile} --calc="A*0"

# and now add all values
for ii in ${lstRaster[@]}
do
    gdal_calc.py -A ${tmpDir}/${ii} -B ${sumFile} --calc="A+B"
done


# end of script
