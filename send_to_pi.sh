#!/bin/env bash

set -e

if [[ ! -d $1 ]]; then
	echo "directory not found $1"
	exit 1
fi

echo "Sending $1"

rsync -rP $1 ripi:~/$1

echo "Sent $1"
