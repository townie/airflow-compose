#!/usr/bin/env bash
# Goal to support local development. We want to have a local pip install -e

cd /usr/local/airflow/packages
echo "******** STARTING LOCAL DEVELOPMENT INSTALL **************"
for i in * ; do
    if [ -d "$i" ]; then
        cd $i
        echo "############### Installing: $i ####################"
        make clean
        pip install -e .
        echo "############### Successfull Install: $i #####################"
        cd ..
    fi
done
cd ..
echo "******** COMPLETED LOCAL DEVELOPMENT INSTALL **************"
