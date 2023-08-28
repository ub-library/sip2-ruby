require 'sip2/parser'
require 'sip2/transformer'
require 'sip2/message'

module Sip2
  PARSER = Sip2::Parser.new
  TRANSFORMER = Sip2::Transformer.new

  def self.parse(data)
    TRANSFORMER.apply(PARSER.parse(data))
  end

  def self.encode(hsh, **encoding_options)
    Sip2::Message.from_hash(hsh).encode(**encoding_options)
  end

end
