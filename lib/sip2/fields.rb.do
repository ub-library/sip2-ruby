#!/usr/bin/env ruby

require 'json'

project_root = File.expand_path(File.join(__dir__, "../.."))

src = "#{project_root}/doc/sip2_fields.json"

require "#{project_root}/environment.rb"

INDENT=4

MODULE_TEMPLATE =<<EOS
module Sip2
  module Types
    include Dry.Types()
  end

  format_bool = ->(v) { v ? "Y" : "N" }

  format_int_2 = ->(v) { sprintf('%%02d', v) }

  format_int_4_or_blank = ->(v) { v.nil? ? "    " : sprintf("%%04d", v) }

  format_nillable_bool = ->(v) { v.nil? ? 'U' : format_bool.(v) }

  format_string = ->(v) { v.to_s }

  # TODO: Proper roundtrip of one letter time zones?
  format_timestamp = ->(v) {
    tz = sprintf("%%4s", v.utc? ? "Z" : String(v.zone))
    if tz == Time.now.getlocal.zone
      tz = sprintf("%%4s","")
    end
    v.strftime("%%Y%%m%%d\#{tz}%%H%%M%%S")
  }

  format_timestamp_or_blanks = ->(v) {
    v ? format_timestamp.(v) : sprintf("%%18s", "")
  }

  FIELDS = {
%s
  }

end
EOS

FIELD_TEMPLATE =<<EOS
%<symbol>s: {
  code: "%<code>s",
  type: %<type>s,
  format: %<format>s,
},
EOS

def to_type(type)
  case type
  when "bool", "numerical_bool"
    "Types::Bool"
  when "nillable_bool"
    "Types::Bool.optional"
  when "variable_length_value"
    "Types::String.constrained(max_size: 255)"
  when "four_digits_or_blanks"
    "Types::Integer.constrained(included_in: 0..9999)"
  when "timestamp"
    "Types::Time"
  when "(digit >> digit).as(:int)"
    "Types::Integer.constrained(included_in: 0..99)"
  when "any_valid.as(:str)"
    "Types::String.constrained(size: 1)"
  when /any_valid\.repeat\((\d+), \1\)\.as\(:str\)/
    "Types::String.constrained(size: #{$~[1]})"
  when 'match["012"].as(:int)'
    "Types::Integer.constrained(included_in: 0..2)"
  when "natural.as(:int)"
    "Types::Integer.constrained(included_in: 1..9)"
  when "((zero >> natural) | (natural >> digit)).as(:int)"
    "Types::Integer.constrained(included_in: 1..99)"
  when '(digit >> str(".") >> digit >> digit).as(:str)'
    'Types::String.constrained(format: /^\d\.\d\d$/)'
  when 'hex_digit.repeat(4,4).as(:str)'
    'Types::String.constrained(format: /^[0-9A-Fa-f]{4,4}$/)'
  else
    type
  end

end

HARDCODED_TYPES = {
  "nb_due_date" => "Types::Time.optional"
}

HARDCODED_FORMATS = {
  "nb_due_date" => "format_timestamp_or_blanks"
}

def to_format(type)
  case type
  when "bool"
    "format_bool"
  when "numerical_bool"
    '->(v) { v ? "1" : "0" }'
  when "nillable_bool"
    "format_nillable_bool"
  when "variable_length_value"
    "format_string"
  when "four_digits_or_blanks"
    "format_int_4_or_blank"
  when "timestamp"
    "format_timestamp"
  when "(digit >> digit).as(:int)"
    "format_int_2"
  when "any_valid.as(:str)"
    "format_string"
  when /any_valid\.repeat\((\d+), \1\)\.as\(:str\)/
    "format_string"
  when 'match["012"].as(:int)'
    "format_string"
  when "natural.as(:int)"
    "format_string"
  when "((zero >> natural) | (natural >> digit)).as(:int)"
    "format_int_2"
  when '(digit >> str(".") >> digit >> digit).as(:str)'
    "format_string"
  when 'hex_digit.repeat(4,4).as(:str)'
    "format_string"
  else
    "TODO: " + type
  end

end

require 'pp'
fields = JSON.parse(File.read(src))
  .map { |f|
    sprintf(FIELD_TEMPLATE,
      symbol: f["name"],
      code: f["code"],
      type: HARDCODED_TYPES.fetch(f["name"]) { to_type(f["type"]) },
      format: HARDCODED_FORMATS.fetch(f["name"]) { to_format(f["type"]) }
    ).gsub(/^/, " "*INDENT)
  }

puts sprintf(MODULE_TEMPLATE, fields.join("\n"))
