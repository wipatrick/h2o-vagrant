#!/bin/sh

# H2O Vers. 3.6.0.8
H2O_URL=https://h2o-release.s3.amazonaws.com/h2o/rel-tibshirani/8/h2o-3.6.0.8.zip

wget -O h2o.zip $H2O_URL -q --show-progress && unzip -j h2o.zip -d h2o/ && rm h2o.zip && find h2o/ -type f ! -name "h2o.jar" -exec rm -rf {} \;
