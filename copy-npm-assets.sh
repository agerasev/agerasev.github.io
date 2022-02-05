#!/usr/bin/env bash

export SRC="node_modules/mathjax/es5"
export DST="assets/mathjax"

export MAIN="tex-chtml.js"
export INPUT="input/tex/extensions"
export OUTPUT="output/chtml/fonts/woff-v2"

rm -rf $DST && mkdir $DST && \
cp -r $SRC/$MAIN $DST && \
mkdir -p $DST/$INPUT && cp -r $SRC/$INPUT/* $DST/$INPUT && \
mkdir -p $DST/$OUTPUT && cp -r $SRC/$OUTPUT/* $DST/$OUTPUT && \
echo "MathJax files copied"
