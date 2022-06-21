#!/bin/sh

src="$2.tmp"
script="$2.sed"

redo-ifchange "$src" "$script"

sed -E -f "$script" "$src"
