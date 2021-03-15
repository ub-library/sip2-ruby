#!/bin/sh

redo-ifchange sip2_fields.tmp

sed -f sip2_fields.sed sip2_fields.tmp
