#!/bin/bash
set -eo pipefail
. ./.cicd/helpers/general.sh
export ENABLE_INSTALL=true
export BRANCH=$(echo $BUILDKITE_BRANCH | sed 's/\//\_/')
export CONTRACTS_BUILDER_TAG="eosio/ci-contracts-builder:base-ubuntu-18.04"
export ARGS="--name ci-contracts-builder-$BUILDKITE_PIPELINE_SLUG-$BUILDKITE_BUILD_NUMBER --init -v $(pwd):$(pwd)"
$CICD_DIR/build.sh
docker commit ci-contracts-builder-$BUILDKITE_PIPELINE_SLUG-$BUILDKITE_BUILD_NUMBER $CONTRACTS_BUILDER_TAG-$BUILDKITE_COMMIT
docker commit ci-contracts-builder-$BUILDKITE_PIPELINE_SLUG-$BUILDKITE_BUILD_NUMBER $CONTRACTS_BUILDER_TAG-$BUILDKITE_COMMIT-$PLATFORM_TYPE
docker commit ci-contracts-builder-$BUILDKITE_PIPELINE_SLUG-$BUILDKITE_BUILD_NUMBER $CONTRACTS_BUILDER_TAG-$BRANCH-$BUILDKITE_COMMIT
docker push $CONTRACTS_BUILDER_TAG-$BUILDKITE_COMMIT
docker push $CONTRACTS_BUILDER_TAG-$BUILDKITE_COMMIT-$PLATFORM_TYPE
docker push $CONTRACTS_BUILDER_TAG-$BRANCH-$BUILDKITE_COMMIT
docker stop ci-contracts-builder-$BUILDKITE_PIPELINE_SLUG-$BUILDKITE_BUILD_NUMBER
docker rm ci-contracts-builder-$BUILDKITE_PIPELINE_SLUG-$BUILDKITE_BUILD_NUMBER
