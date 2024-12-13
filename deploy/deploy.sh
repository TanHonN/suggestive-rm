#!/bin/bash
project_dir=$(dirname $0)/..
cp $project_dir/src/rm.sh $project_dir/target/rm
chmod 751 $project_dir/target/rm
sudo cp $project_dir/target/rm /usr/local/bin
