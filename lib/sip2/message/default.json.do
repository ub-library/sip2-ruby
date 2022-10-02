#!/usr/bin/env bash

message="$2"

src="../../../doc/sip2_messages.json"

redo-ifchange "$src"

jq '.[] | select(.message_name.code == "'"$message"'")' < "$src"
