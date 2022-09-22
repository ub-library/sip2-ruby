#!/usr/bin/env ruby
require 'json'
require 'pp'

source="sip2_messages.txt"
system("redo-ifchange #{source}")

require_relative "../environment"

require "sip2/meta/messages_parser"
system("redo-ifchange #{$LOADED_FEATURES.last}")

require "sip2/meta/messages_transformer"
system("redo-ifchange #{$LOADED_FEATURES.last}")

parser = Sip2::Meta::MessagesParser.new
transform = Sip2::Meta::MessagesTransformer.new

File.open(source) do |src|

  intermediate_tree = parser.parse(src.read)

  tree = transform.apply(intermediate_tree)
  puts JSON.dump(tree)
end
