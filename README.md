# Sip2 (sip2-ruby)

Sip2 is a library for parsing and encoding messages in the [Sip2 standard][sip2]
used for communication between library automation devices and automated
circulation systems. It is also two executables, `sip2-to-json` and
`json-to-sip2`, for parsing and encoding respectively.

[sip2]: https://developers.exlibrisgroup.com/wp-content/uploads/2020/01/3M-Standard-Interchange-Protocol-Version-2.00.pdf

Sip2 messages are parsed into a Hash/JSON representation, and the
Hash/JSON representation can be converted back into Sip2 format.

The library is only concerned with parsing and encoding and does not provide
anything related to the connection between the devices and the library system.

The parser is built on the excellent Parslet library.

## Basic usage

### As a script

Given that `sip2.log` contains only Sip2 messages, separated by `\r` (CR) and
optionally `\n` (LF).

```
sip2-to-json < sip2.log > sip2-log.json

json-to-sip2 < sip2-log.json > sip2.txt
```

Normally `sip2.log` and `sip2.txt` should now be semantically identical. (Field
order might differ.)

Typically `sip2-to-json` can be used to view, query and filter logs, while
`json-to-sip2` is best used in combination with `sip2-to-json` to rewrite
messages, operating on the JSON representation rather than on the raw strings:

```
sip2-to-json < sip2.log | your-script-here | json-to-sip2
```

### As a library

The main interfaces are two methods on the `Sip2` module: `Sip2.parse` and
`Sip2.encode`.

```ruby
require 'sip2'
message = "9900802.00\r"

parsed_message = Sip2.parse(message).first
#=> {:message_code=>"99", :message_name=>"SC Status", :status_code=>0,
#   :max_print_width=>80, :protocol_version=>"2.00"}

parsed_message[:max_print_width] = 100

Sip2.encode(parsed_message)
#=> "9901002.00\r"
```

## Validation

`Sip2.parse` only accepts well formed messages, but handles invalid dates in a
possibly unexpected way. It enforces *date-like* values, but would accept e.g.
"2023-02-30" *and convert it* to 2023-03-02. Messages that are not well formed
will cause a `Parslet::ParseFailed` error to be raised. See [Parslet
documentation][parslet-docs] for how to get more information from the error.

[parslet-docs]: https://kschiess.github.io/parslet/documentation.html

`Sip2.encode` enforces the type of all values and outputs valid Sip2
messages. On most type errors, a `Dry::Struct::Error` will be raised.

Unrecognized message types and unrecognized fields for recognized messages are
accepted, in accordance with the Sip2 standard. The data is captured and can
round trip between parsing and encoding.

## Error detection and checksums

The Sip2 standard allows for some basic error detection using checksums. This
library does not validate checksums, but can create and update them.
When integrating with a system that validates and enforces checksums the way
checksums are calculated must match.

The standard is a bit vague on the topic of encodings, and especially for
checksums, where it is important since characters are "binary summed".
`Sip2#encode` accepts an optional `checksum_encoder`, a simple lambda that
accepts a string and returns a string. If supplied, the checksum will be
calculated on the return value of this lambda applied to the message. (The
lambda should not alter the original message.) In `Sip2::ChecksumEncoder` a
couple of encoders are provided (accessible both through their constant names
and through `#[]`):

    * `ALMA`: Encodes the message as ASCII, using replacement characters for
    non-ascii values. Matches the (undocumented) behaviour of Ex Libris Alma.

    * `IDENTITY`: Pass through of the original message. Thus, a message in UTF-8
    will be checksummed as UTF-8, while a message in Latin-1 will be checksummed
    as Latin1. (This is the same as not specifying a `checksum_encoder`.)

The pre defined encoders are also available for `json-to-sip2` through the
command line option `--checksum-encoder`.

## Caveats

### Documentation

*Note that the ruby code is currently entirely undocumented.* This is due to
much of it being dynamically generated from a code representation of the Sip2
standard, and I simply do not know how to let rdoc or yard pick this up. The
parts that are static can of course be documented, but as they read or return
the dynamically generated message classes the documentation would still be
incomplete.

Running `script/sip2-messages-info` will output a JSON representation of all
known messages and the fields they include. There is also a JSON representation
of all fields in `doc/sip2_fields.json`. These two sources can be used to some
extent to see how the mapping between the Sip2 format and the Hash/JSON
representation looks like.

### Time Zones

Time zones are not fully implemented and do not round trip. The Sip2
specification declares that time zones should be expressed according to ancient
ANSI standard X3.43, which in its turn refers to X3.51. This standard is
mentioned in RFC822, which specifies a few two or three letter codes, "military"
one letter time zone codes, and explicit offset using four digits prefixed with
`+` or `-`. The prefixed digits will not fit in the designated four character
segment.

In this library only `Z` for "UTC" and `    ` (four spaces, no time zone) are
round tripped. When parsing, `Z` and `UTC` will be parsed as times with UTC time
zone, four blanks will be parsed as local time, and military one letter time
zone codes will be parsed into times with the correct offset but with no
`Time#zone` set. When encoding, times in UTC will be encoded as `Z`, and all
other times, including local time, will be encoded without time zone data.
