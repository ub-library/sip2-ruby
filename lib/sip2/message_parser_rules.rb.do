#!/usr/bin/env ruby
require 'json'
require 'pp'

project_root = "../.."
require_relative "#{project_root}/environment"

source="#{project_root}/doc/sip2_messages.txt"
system("redo-ifchange #{source}")

require "sip2/meta/messages_parser"
system("redo-ifchange #{$LOADED_FEATURES.last}")

require "sip2/meta/messages_transformer"
system("redo-ifchange #{$LOADED_FEATURES.last}")

require "sip2/meta/fields_constants"
system("redo-ifchange #{$LOADED_FEATURES.last}")

parser = Sip2::Meta::MessagesParser.new
transform = Sip2::Meta::MessagesTransformer.new

MODULE_TEMPLATE =<<EOS
# GENERATED FILE - DO NOT EDIT!
require 'parslet'
require 'sip2/field_parser_rules'

module Sip2
  module MessageParserRules
    include Parslet

    include Sip2::FieldParserRules

    rule(:eom) { str("\\r") }
    rule(:newline) { str("\\n") }

%<rules>s

%<messages_rule>s

  end
end
EOS
INDENT=4

RULE_TEMPLATE =<<EOS

# %<doc>s
rule(:%<name>s) {
  %<code>s
    %<ordered_fields>s
    %<delimited_fields>s
    %<eom>s
}
EOS

MESSAGES_RULE_TEMPLATE =<<EOS
rule(:messages) {
  ((
%s
  ) >> newline.maybe).repeat(1)
}
EOS

DOC_TEMPLATE = "%s (%s)"
CODE_TEMPLATE = 'str("%s").as(:str).as(:message_code).as(:message_identifiers) >>'
ORDERED_FIELDS_TEMPLATE = "(%s).as(:ordered_fields) >>"
DELIMITED_FIELDS_TEMPLATE = "(%s).repeat.as(:merge_repeat).as(:delimited_fields) >>"

src = File.read(source)
intermediate_tree = parser.parse(src)
tree = transform.apply(intermediate_tree)

rules = tree.sort_by { |m| m[:message_code] }.map do |message|
  message_name = message.fetch(:message_name)
  name = message_name.fetch(:code)

  fields = message.fetch(:fields)
  message_code = message.fetch(:message_code)

  doc = sprintf(DOC_TEMPLATE, message_name.fetch(:text), message_code)

  code = sprintf(CODE_TEMPLATE, message_code)

  ordered_fields = fields.fetch(:ordered)

  ordered_fields_formatted = 
    if ordered_fields.any?
      sprintf(ORDERED_FIELDS_TEMPLATE, ordered_fields.join(" >> "))
    else
      ""
    end

  delimited_fields = fields.fetch(:delimited)

  delimited_fields_formatted = 
    if delimited_fields.any?
      sprintf(DELIMITED_FIELDS_TEMPLATE, delimited_fields.join(" | "))
    else
      ""
    end


  sprintf(RULE_TEMPLATE,
          doc: doc,
          name: name,
          code: code,
          ordered_fields: ordered_fields_formatted,
          delimited_fields: delimited_fields_formatted,
          eom: "eom"
  ).gsub(/^\s+$\n/, "")
end

messages_rule = tree
  .sort_by { |m| m[:message_code] }
  .map { |m| m.fetch(:message_name).fetch(:code) }
  .join(" |\n")
  .gsub(/^/, " "*INDENT)
  .yield_self { |messages| sprintf(MESSAGES_RULE_TEMPLATE, messages) }

puts sprintf(MODULE_TEMPLATE,
             rules: rules.join.gsub(/^/, " "*INDENT),
             messages_rule: messages_rule.gsub(/^/, " "*INDENT),
            ).gsub(/^\s+$/, "")
