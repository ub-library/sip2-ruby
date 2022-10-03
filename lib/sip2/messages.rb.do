#!/usr/bin/env bash

template="$1.erb"

src="../../doc/sip2_messages.json"

redo-ifchange "$src" "$template"

erb -T - src="$src" "$template"
