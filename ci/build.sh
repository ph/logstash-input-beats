#!/bin/bash
set -e

echo "Starting build process in: `pwd`"

if [ "$LOGSTASH_BRANCH" ]; then
    BASE_DIR=`pwd`
    echo "Checking out branch: $LOGSTASH_BRANCH"
    git clone -b $LOGSTASH_BRANCH https://github.com/elastic/logstash.git ../../logstash --depth 1
    printf "Checked out Logstash revision: %s\n" "$(git -C ../../logstash rev-parse HEAD)"
    cd ../../logstash
    echo "Building plugins with Logstash version:"
    cat versions.yml
    echo "---"
    # We need to build the jars for that specific version
    echo "Running gradle assemble in: `pwd`"
    ./gradlew assemble
    cd $BASE_DIR
    export LOGSTASH_SOURCE=1
fi

echo "Running install in: `pwd`"
bundle install
bundle exec rake vendor
./gradlew test
bundle exec rspec spec
bundle exec rake test:integration:setup
bundle exec rspec spec --tag integration
