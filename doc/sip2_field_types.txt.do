#!/usr/bin/env ruby
require 'json'

source="sip2_fields.txt"

system("redo-ifchange #{source}")

require_relative "../environment"

require "sip2/protocol/fields_parser"
system("redo-ifchange #{$LOADED_FEATURES.last}")
require "sip2/protocol/fields_transformer"
system("redo-ifchange #{$LOADED_FEATURES.last}")

parser = Sip2::Protocol::FieldsParser.new
transform = Sip2::Protocol::FieldsTransformer.new

File.open(source) do |src|
  intermediate_tree = parser.parse_with_debug(src.read)
  tree = transform.apply(intermediate_tree)

  puts tree
    .group_by { |field| field[:type] }
    .map { |type,fields| sprintf("%-50s %4d", type + ":", fields.size) }
    .sort

end
