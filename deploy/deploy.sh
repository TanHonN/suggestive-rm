#!/bin/bash
src=$(dirname $0)/../src/rm.sh
des=/usr/local/bin/rm
sudo cp $src $des
sudo chmod 751 $des
