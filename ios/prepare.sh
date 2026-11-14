#!/bin/bash
# Remplit ios/Web avec la page de l'appli (la même que sur Android), le pont iPhone et les polices.
set -e
cd "$(dirname "$0")"
rm -rf Web && mkdir -p Web/fonts
cp ../app/src/main/assets/index.html Web/index.html
cp bridge.js Web/bridge.js
cd Web/fonts
get() { curl -fsSL --retry 2 -m 60 -o "$1" "$2" || rm -f "$1"; }
get bricolage.woff2 "https://cdn.jsdelivr.net/npm/@fontsource-variable/bricolage-grotesque/files/bricolage-grotesque-latin-wght-normal.woff2"
get instrument.woff2 "https://cdn.jsdelivr.net/npm/@fontsource-variable/instrument-sans/files/instrument-sans-latin-wght-normal.woff2"
get caveat.woff2 "https://cdn.jsdelivr.net/npm/@fontsource-variable/caveat/files/caveat-latin-wght-normal.woff2"
[ -s caveat.woff2 ] || get caveat.ttf "https://raw.githubusercontent.com/google/fonts/main/ofl/caveat/Caveat%5Bwght%5D.ttf"
[ -s bricolage.woff2 ] || get bricolage.ttf "https://raw.githubusercontent.com/google/fonts/main/ofl/bricolagegrotesque/BricolageGrotesque%5Bopsz%2Cwdth%2Cwght%5D.ttf"
[ -s instrument.woff2 ] || get instrument.ttf "https://raw.githubusercontent.com/google/fonts/main/ofl/instrumentsans/InstrumentSans%5Bwdth%2Cwght%5D.ttf"
find . -type f -size -8k -delete
ls -la
