#!/usr/bin/env bash

src="sip2_fields.json"
redo-ifchange "$src"

jq -r '.[] | select(has("code") | not) | .name' < "$src" | sort > "$3"
