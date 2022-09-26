#!/usr/bin/env ruby
require 'json'
require 'pp'

project_root = "../.."
require_relative "#{project_root}/environment"

source="#{project_root}/doc/sip2_messages.json"
system("redo-ifchange #{source}")

MODULE_TEMPLATE =<<EOS
module Sip2
  MESSAGE_TYPES = {

%s
  }
end
EOS
INDENT=4

MESSAGE_TEMPLATE =<<EOS
"%<code>s" => {
  name: "%<name>s",
  symbol: :%<symbol>s
},
EOS

messages = JSON.parse(File.read(source))
message_lines = messages
  .sort_by { |m| m["message_code"] }
  .map { |m|
    code = m.fetch("message_code").to_s
    name = m.fetch("message_name").fetch("text")
    symbol = m.fetch("message_name").fetch("code")
    sprintf(MESSAGE_TEMPLATE, code: code, name: name, symbol: symbol)
  }
  .join
  .gsub(/^/, " "*INDENT)

puts sprintf(MODULE_TEMPLATE, message_lines)
