#!/bin/bash

GFX_MMP_DRV=R-Car_Gen3_Series_Evaluation_Software_Package_for_Linux-20220121.zip
GFX_MMP_LIB=R-Car_Gen3_Series_Evaluation_Software_Package_of_Linux_Drivers-20220121.zip

GFX_FILE_TO_CHECK=LICENSE.TXT

CheckEvaluationPackage () {
    if [[ ! -e "../proprietary/$GFX_MMP_DRV" ]] || [[ ! -e "../proprietary/$GFX_MMP_LIB" ]]; then
        echo "Error: GFX/MMP evaluation package is missing."
        echo "please download follwing items and copy into '../propietary' directory:"
        echo "- $GFX_MMP_DRV"
        echo "- $GFX_MMP_LIB"
        echo ""
        echo "Package can be downloaded from following link:"
        echo "- https://www.renesas.com/application/automotive/r-car-h3-m3-h2-m2-e2-documents-software"
        echo ""
        echo "Directory structure:"
        echo ".."
        echo "|--proprietary"
        echo "   |--$GFX_MMP_DRV"
        echo "   |--$GFX_MMP_LIB"
        exit -1
    fi
    if [[ ! -e "../prebuilt_gsx/$GFX_FILE_TO_CHECK" ]]; then
        return 1
    else
        return 0
    fi
}

WORK="$PWD"

if ! CheckEvaluationPackage; then
    mkdir -p ../prebuilt_gsx/domd
    for zipname in $(ls ../proprietary/*.zip); do
        unzip -qo $zipname -d ../prebuilt_gsx
    done
    cd ../prebuilt_gsx/
    ls *.zip | xargs -i unzip -qo {}
    find | grep -e GSX -e gles | xargs cp -t domd
    mv -f domd/{INF_,}r8a77951_linux_gsx_binaries_gles.tar.bz2
    mv -f domd/{INF_,}r8a77960_linux_gsx_binaries_gles.tar.bz2
    cp -rf $WORK/../prebuilt_gsx/domd $WORK/../prebuilt_gsx/domu
    cd "$WORK"
fi

if [ ! -f ./repo ]; then
    curl https://storage.googleapis.com/git-repo-downloads/repo > repo
    chmod a+x ./repo
fi

export PATH=$PWD:$PATH
