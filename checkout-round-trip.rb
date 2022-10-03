
require_relative 'environment'

require 'parslet'
require 'parslet/export'

require 'sip2/parser'
require 'sip2/transformer'
require 'sip2/message'


parser = Sip2::Parser.new
transformer = Sip2::Transformer.new

intermediate_tree = parser.parse(ARGF.read)
tree = transformer.apply(intermediate_tree)

tree.each do |message|
  puts Sip2::Message.from_hash(message).to_sip2
end
