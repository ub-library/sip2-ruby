require 'sip2/parser'
require 'sip2/transformer'

module Sip2
  PARSER = Sip2::Parser.new
  TRANSFORMER = Sip2::Transformer.new

  def self.parse(data)
    TRANSFORMER.apply(PARSER.parse(data))
  end
end
