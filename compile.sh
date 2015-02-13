#!/bin/bash

dir_cod="/home/codmp/codmp/main/"
pk3="zZz_zombies_v6_beta.pk3"

# Zip files
zip -r ${pk3} zombies/ maps/ modules/ weapons/

# Copy files
echo "copy"
cp ${pk3} ${dir_cod}
