#!/usr/bin/env ruby
require 'json'

source="sip2_fields.txt"

system("redo-ifchange #{source}")

require_relative "../environment"

require "sip2/protocol/fields_parser"
system("redo-ifchange #{$LOADED_FEATURES.last}")
require "sip2/protocol/fields_transformer"
system("redo-ifchange #{$LOADED_FEATURES.last}")

parser = Sip2::Protocol::FieldsParser.new
transform = Sip2::Protocol::FieldsTransformer.new

MODULE_TEMPLATE =<<EOS
module Sip2
  module FieldRules

%<rules>s

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
    y_or_space >>
    y_or_space >>
    y_or_space >>
    y_or_space
  )
EOS

HARDCODED_VALUE_RULES = {
  checksum: 'ascii_hex_4',
  circulation_status: '(digit >> digit).as(:int)',
  currency_type: 'match[A-Z].repeat(3,3).as(:str)',
  fee_type: '(non_zero_digit >> digit).as(:int)',
  hold_mode: '(str("+") | str("-") | str("*")).as(:str)',
  hold_type: 'non_zero_digit.as(:int)',
  item_properties_ok: 'any_valid.as(:numerical_bool)',
  language: 'digit.repeat(3,3).as(:int)',
  max_print_width: 'digit.repeat(3,3).as(:int)',
  media_type: 'digit.repeat(3,3).as(:int)',
  ok: 'numerical_bool',
  patron_status: HARDCODED_PATRON_STATUS_RULE,
  payment_type: '(digit >> digit).as(:int)',
  protocol_version: '(digit >> str(".") >> digit >> digit).as(:str)',
  PWD_algorithm: 'any_valid.as(:str)',
  retries_allowed: 'digit.repeat(3,3).as(:int)',
  security_marker: '(digit >> digit).as(:int)',
  sequence_number: 'digit.as(:int)',
  status_code: 'match["012"].as(:int)',
  summary: HARDCODED_SUMMARY_RULE,
  timeout_period: 'digit.repeat(3,3).as(:int)',
  UID_algorithm: 'any_valid.as(:str)',
}

src = File.read(source)
intermediate_tree = parser.parse_with_debug(src)
tree = transform.apply(intermediate_tree)

rules = tree.map do |field|
  name = field[:name].gsub(%r"[-/]", "").gsub(/ +/, "_").to_sym
  code = ""
  pipe = ""
  doc = ""

  if field[:code]
    code = sprintf('str("%s") >> ', field[:code])
    pipe = " >> pipe"
  end

  value_rule = HARDCODED_VALUE_RULES.fetch(name) {
    "digit.repeat(4,4).as(:int)" if name.to_s.match(/_(count|limit)$/)
  }

  if value_rule.nil?
    case field[:type]

    when "variable-length field"

      value_rule = "variable_length_value"

    when /^1-char.* field: Y or N$/

      value_rule = "bool"

    when /^1-char.* field: Y or N or .*U$/

      value_rule = "y_n_or_u.as(:bool)"

    when "18-char, fixed-length field: YYYYMMDDZZZZHHMMSS"

      value_rule = "timestamp"

    else

      value_rule = sprintf('not_implemented("%s")', field[:type])
      doc = sprintf(DOC, field.slice(:type, :type_terminator, :doc).merge(name: name.inspect))
        .gsub(/\n\n\z/, "\n")
        .gsub(/^/, "# ")
        .gsub(/\A/, "\n")
        .gsub(/\n\z/, "\n#")

    end
  end

  sprintf(RULE_TEMPLATE, name: name.inspect, code: code, value_rule: value_rule, pipe: pipe, doc: doc)
end

puts sprintf(MODULE_TEMPLATE, rules: rules.join.gsub(/^/, " "*INDENT)).gsub(/^\s+$/, "")
