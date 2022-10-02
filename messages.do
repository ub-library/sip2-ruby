#!/usr/bin/env bash

src="doc/sip2_messages.json"

redo-ifchange "$src"

jq '.[] | "lib/sip2/message/" + .message_name.code + ".rb"' < "$src" \
| xargs redo-ifchange
