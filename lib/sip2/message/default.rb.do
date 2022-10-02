#!/usr/bin/env bash

message="$2"

src="$2.json"

template="default.erb"

redo-ifchange "$src" "$template"

erb -T - message="$message" src="$src" "$template"
