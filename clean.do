for file in \
    doc/sip2_field_parse_rules.rb \
    doc/sip2_field_types.txt \
    doc/sip2_fields.{json,rb,tmp,txt} \
    doc/sip2_messages.{json,rb,tmp,txt} \
    ; do

    if test -f "$file"; then
        rm "$file"
    fi
done
