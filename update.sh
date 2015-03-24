#!/usr/bin/env bash

SCRIPTS_DIR="scripts"
AGENTS_FILE="scripts/agents"

trap "kill 0" SIGINT # kill all subprocesses

set -e # exit script if any command errors out

git submodule init
git submodule update

if [ ! -f $AGENTS_FILE ]; then
    (set -x && exec cp "$SCRIPTS_DIR/agents.sample" $AGENTS_FILE)
fi

(set -x && cd xi-core && exec npm install --production)
(set -x && cd xal-javascript && exec npm install --production)

while read agent; do
    [ -z "$agent" ] && continue # skip empty lines
    [[ $agent == \#* ]] && continue # skip comments
    (set -x && cd "agents/$agent" && exec npm install --production)
done < $AGENTS_FILE

echo "Update complete."
