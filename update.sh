#!/bin/bash

set -x

git submodule init
git submodule update

while read agent; do
    set +x
    [ -z "$agent" ] && continue # skip empty lines
    [[ $agent == \#* ]] && continue # skip comments
    set -x
    (cd "agents/$agent" && exec npm install --production)
done < scripts/agents

echo "Update complete."
