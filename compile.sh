#!/bin/bash


dir_cod="/home/codmp/codmp/main/"

# Copy files

echo "zombies"
cd "./zombies"
cp -R . ${dir_cod}"zombies"

echo "maps"
cd "../maps"
cp -R . ${dir_cod}"maps"

echo "modules"
cd "../modules"
cp -R . ${dir_cod}"modules"

echo "weapons"
cd "../weapons"
cp -R . ${dir_cod}"weapons"
