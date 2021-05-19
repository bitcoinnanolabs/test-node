#!/bin/bash
REPO_ROOT=`git rev-parse --show-toplevel`
pushd $REPO_ROOT
docker build -f docker/ci/Dockerfile -t btco-ci:latest .
popd
