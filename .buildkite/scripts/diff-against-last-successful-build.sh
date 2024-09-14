#!/bin/bash

set -eo pipefail 

# get_last_successful_commit will query the Buildkite REST API for the 
# last successful build's commit hash. It considers any build with a 
# state of BLOCKED or PASSED as successful. When encountering an error, 
# it will fail gracefully back to the current build job's commit-1 i.e. 
# HEAD~. It makes use of an API token from the Buildkite # secret bucket to query the API ($BUILDKITE_REST_API_TOKEN). 
# # This function is intended to be re-usable in other pipelines. 

get_last_successful_commit() { 
    warn="--- :x: Failed querying for last successful build's commit" 
    warn="${warn}\n--- :+1: Failing gracefully to n-1 commits" 
    url="https://api.buildkite.com/v2" 
    url="${url}/organizations/${BUILDKITE_ORGANIZATION_SLUG}" 
    url="${url}/pipelines/${BUILDKITE_PIPELINE_SLUG}" 
    url="${url}/builds?branch=master" 
    url="${url}&state=passed" 
    url="${url}&per_page=1&page=1" 
    
    if ! curl -sSfg "${url}" \ 
        -H "Authorization: Bearer ${BUILDKITE_REST_API_TOKEN}" | 
        jq -er '.[0].commit' | grep -v null; then 
        echo -e "${warn}" >&2 
        echo "HEAD~1" 
        fi 
} 
    
set -x 

if [ "${BUILDKITE_TAG}" != "" ]; then 
    # only get the diff for the tagged commit 
    git diff --name-only ${BUILDKITE_COMMIT} ${BUILDKITE_COMMIT}~1 
else 
    LAST_SUCCESSFUL_COMMIT=$(get_last_successful_commit) 
    git diff --name-only $LAST_SUCCESSFUL_COMMIT 
fi