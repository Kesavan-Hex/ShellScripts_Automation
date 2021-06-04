#!/bin/bash



folder="/home/kesavan/spark"
gapps_command="WITH_GAPPS"
with_gapps="yes"
build_type="user"
device_codename="violet"
use_brunch="no"
OUT_PATH="$folder/out/target/product/${device_codename}"
lunch="spark"



make_clean="yes"
# make_clean="no"
# make_clean="installclean"

# Rom being built

ROM=${OUT_PATH}/${rom_name}

#Folder specifity

cd "$folder"

echo -e "\rBuild starting thank you for waiting"


# Colors makes things beautiful

export TERM=xterm

        red=$(tput setaf 1)             #  red
        grn=$(tput setaf 2)             #  green
        blu=$(tput setaf 4)             #  blue
        cya=$(tput setaf 6)             #  cyan
        txtrst=$(tput sgr0)             #  Reset

# Ccache

echo -e ${blu}"CCACHE is enabled for this build"${txtrst}
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
mkdir ~/ccache
export CCACHE_DIR=~/ccache
ccache -M 75G

# Time to build

. build/envsetup.sh


if [ "$with_gapps" = "yes" ];
then
export "$gapps_command"=true
export TARGET_GAPPS_ARCH=arm64
fi

if [ "$with_gapps" = "no" ];
then
export "$gapps_command"=false
fi

# Clean build

if [ "$make_clean" = "yes" ];
then
rm -rf ${OUT_PATH}
wait
echo -e ${cya}"OUT dir from your repo deleted"${txtrst};
fi

if [ "$make_clean" = "installclean" ];
then
rm -rf ${OUT_PATH}
wait
echo -e ${cya}"Images deleted from OUT dir"${txtrst};
fi

rm -rf ${OUT_PATH}/*.zip
lunch ${lunch}_${device_codename}-${build_type}

# Brunch Options

START=$(date +%s)
if [ "$use_brunch" = "yes" ];
then
brunch ${device_codename}
fi

if [ "$use_brunch" = "no" ];
then
mka ${lunch} -j$(nproc --all)
fi

if [ "$use_brunch" = "spark" ];
then
make mka spark
fi

END=$(date +%s)
TIME=$(echo $((${END}-${START})) | awk '{print int($1/60)" Minutes and "int($1%60)" Seconds"}')


