#!/usr/bin/env bash

redo-ifchange \
    lib/sip2/{field,message}_parser_rules.rb \
    doc/sip2_{fields,messages}.json \
    lib/sip2/message_types.rb
