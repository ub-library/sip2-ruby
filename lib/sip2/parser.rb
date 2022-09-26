require 'parslet'
require 'parslet/convenience'

require 'sip2/message_parser_rules'
require 'sip2/field_parser_rules'

module Sip2
  class Parser < Parslet::Parser
    include Sip2::MessageParserRules

    root(:messages)

  end
end
