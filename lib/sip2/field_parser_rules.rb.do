#!/usr/bin/env ruby
require 'json'

project_root = "../.."

require_relative "#{project_root}/environment"

source="#{project_root}/doc/sip2_fields.txt"

system("redo-ifchange #{source}")

require "sip2/meta/fields_parser"
system("redo-ifchange #{$LOADED_FEATURES.last}")
require "sip2/meta/fields_transformer"
system("redo-ifchange #{$LOADED_FEATURES.last}")

parser = Sip2::Meta::FieldsParser.new
transform = Sip2::Meta::FieldsTransformer.new

MODULE_TEMPLATE =<<EOS
# GENERATED FILE - DO NOT EDIT!
require 'parslet'
require 'sip2/parser_atoms.rb'

module Sip2
  module FieldParserRules
    include Parslet

    include Sip2::ParserAtoms

%<rules>s

    rule(:fee_type_fixed) {
      ((zero >> natural) | (natural >> digit)).as(:int).as(:fee_type_fixed)
    }

    }
  end
end
EOS
INDENT=4

RULE_TEMPLATE =<<EOS
%<doc>s
rule(%<name>s) {
  %<code>s%<value_rule>s.as(%<name>s)%<pipe>s
}
EOS

DOC =<<EOS
TODO: Parser for %<name>s

%<type>s%<type_terminator>s%<doc>s
EOS

HARDCODED_PATRON_STATUS_RULE =<<EOS.chomp
(
    bool_with_space.as(:charge_privileges_denied) >>
    bool_with_space.as(:renewal_privileges_denied) >>
    bool_with_space.as(:recall_privileges_denied) >>
    bool_with_space.as(:hold_privileges_denied) >>
    bool_with_space.as(:card_reported_lost) >>
    bool_with_space.as(:too_many_items_charged) >>
    bool_with_space.as(:too_many_items_overdue) >>
    bool_with_space.as(:too_many_renewals) >>
    bool_with_space.as(:too_many_claims_of_items_returned) >>
    bool_with_space.as(:too_many_items_lost) >>
    bool_with_space.as(:excessive_outstanding_fines) >>
    bool_with_space.as(:excessive_outstanding_fees) >>
    bool_with_space.as(:recall_overdue) >>
    bool_with_space.as(:too_many_items_billed)
  )
EOS

HARDCODED_SUMMARY_RULE =<<EOS.chomp
(
    bool_with_space.as(:hold_items) >>
    bool_with_space.as(:overdue_items) >>
    bool_with_space.as(:charged_items) >>
    bool_with_space.as(:fine_items) >>
    bool_with_space.as(:recall_items) >>
    bool_with_space.as(:unavailable_holds) >>
    match["Y "].repeat(4,4)
  )
EOS

HARDCODED_VALUE_RULES = {
  currency_type: 'match["A-Z"].repeat(3,3).as(:str)',
  hold_mode: '(str("+") | str("-") | str("*")).as(:str)',
  item_properties_ok: 'any_valid.as(:numerical_bool)',
  language: 'digit.repeat(3,3).as(:int)',
  max_print_width: 'digit.repeat(3,3).as(:int)',
  media_type: 'digit.repeat(3,3).as(:int)',
  nb_due_date: '(timestamp | space.repeat(18,18).as(:nil))',
  patron_status: HARDCODED_PATRON_STATUS_RULE,
  retries_allowed: 'digit.repeat(3,3).as(:int)',
  sequence_number: 'digit.as(:int)',
  summary: HARDCODED_SUMMARY_RULE,
  timeout_period: 'digit.repeat(3,3).as(:int)',
}

src = File.read(source)
intermediate_tree = parser.parse_with_debug(src)
tree = transform.apply(intermediate_tree)

rules = tree.map do |field|
  name = field[:name]
  code = ""
  pipe = ""
  doc = ""

  if field[:code]
    code = sprintf('str("%s") >> ', field[:code])
    pipe = " >> pipe"
  end

  value_rule = HARDCODED_VALUE_RULES.fetch(name) {
    field[:type] unless field[:type].empty?
  }

  if value_rule.nil?
    value_rule = sprintf('not_implemented("%s")', field[:type])
    doc = sprintf(DOC, field.slice(:type, :type_terminator, :doc).merge(name: name.inspect))
      .gsub(/\n\n\z/, "\n")
      .gsub(/^/, "# ")
      .gsub(/\A/, "\n")
      .gsub(/\n\z/, "\n#")
  end

  sprintf(RULE_TEMPLATE, name: name.inspect, code: code, value_rule: value_rule, pipe: pipe, doc: doc)
end

puts sprintf(MODULE_TEMPLATE, rules: rules.join.gsub(/^/, " "*INDENT)).gsub(/^\s+$/, "")
