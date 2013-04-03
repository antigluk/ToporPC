#!/bin/bash

echo
echo "==================================" >&2
echo "Running test for $1" >&2

RESULT=$(vsim -quiet -c -do "source $1" | grep -v -e "^#" -e "^$$" | sed "1d")

[ $RESULT -eq 0 ] && echo "OK" || echo "$RESULT ERRORS DETECTED"
