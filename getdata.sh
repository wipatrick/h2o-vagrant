#!/bin/sh

# https://github.com/h2oai/h2o-2/wiki/Hacking-Airline-DataSet-with-H2O
URL_SMALL=https://s3.amazonaws.com/h2o-airlines-unpacked/allyears2k.csv
URL_BIG=https://s3.amazonaws.com/h2o-airlines-unpacked/allyears.csv

case $1 in
    small)
      echo "Downloading 4.5 MB dataset ..."
      wget -O - $URL_SMALL > ./data/airline_small.csv
    ;;
    big)
      echo "Downloading 12 GB dataset ..."
      wget -O - $URL_BIG > ./data/airline_big.csv
    ;;
esac
