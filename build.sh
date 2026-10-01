#!/bin/sh
# Builds a signed squidGame.riv (web runtimes reject unsigned scripts) and copies it next to
# index.html. Needs a Rive login once: rive login
set -e
cd "$(dirname "$0")/.."
rive . --publish
cp build/squidGame.riv web/squidGame.riv
# A new version stamp in index.html, so browsers don't keep a cached .riv.
sed -i '' "s/const RIV_VERSION = '[^']*'/const RIV_VERSION = '$(date +%s)'/" web/index.html
echo "web/ is ready: index.html + squidGame.riv"
