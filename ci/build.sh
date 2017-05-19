#!/bin/bash
########################################################
#
# AUTOMATICALLY GENERATED! DO NOT EDIT
#
# version: 1
########################################################
set -e

echo "Starting build process in: `pwd`"
./ci/setup.sh

if [[ -f "ci/run.sh" ]];
    echo "Running custom build script in: `pwd`"
    ./ci/run.sh
else
    echo "Running default build scripts in: `pwd`"
    bundle install
    bundle exec rspec spec
    bundle exec rspec spec --tag integration
fi
