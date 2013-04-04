#!/bin/bash

echo "==================================" >&2
echo "Running test for $1" >&2

vsim -quiet -c -do "source $1" &> "$1.test"
RESULT=$(<"$1.test" grep -v -e "^#" -e "^$$" | sed "1d")

[ $RESULT -eq 0 ] && echo "OK" || echo "$RESULT ERRORS DETECTED"
