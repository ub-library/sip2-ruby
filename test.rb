#!/usr/bin/env ruby

require_relative 'environment'

require 'json'
require 'sip2/parser'
require 'sip2/transformer'

parser = Sip2::Parser.new
transformer = Sip2::Transformer.new

parse = ->(data) {
  intermediate_tree = parser.parse_with_debug(data)
  transformer.apply(intermediate_tree)
}

if ARGV.first == "-1"
  ARGV.shift

  ARGF.each_line do |data|
    puts parse.call(data).first.to_json
  end
else
  puts parse.call(ARGF.read).to_json
end
