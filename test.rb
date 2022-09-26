require_relative 'environment'

require 'json'
require 'sip2/parser'
require 'sip2/transformer'

parser = Sip2::Parser.new
transformer = Sip2::Transformer.new

data = ARGF.read
intermediate_tree = parser.parse_with_debug(data)
tree = transformer.apply(intermediate_tree)
puts tree.to_json




