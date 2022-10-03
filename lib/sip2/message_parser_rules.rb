require 'parslet'
require 'sip2/field_parser_rules'
require 'sip2/messages'

module Sip2
  module MessageParserRules
    include Parslet

    include Sip2::FieldParserRules

    rule(:newline) { str("\n") }

    rule(:empty_hash) {
      str("").as(:empty_hash)
    }

    rule(:no_ordered_fields) {
      empty_hash.as(:ordered_fields)
    }

    rule(:no_delimited_fields) {
      empty_hash.as(:delimited_fields)
    }

    rule(:error_detection) {
      ( (sequence_number >> checksum) | empty_hash ).as(:error_detection)
    }

    rule(:checksum_only) {
      ( checksum | empty_hash ).as(:error_detection)
    }

    rule(:known_message_id) {
      Sip2::MESSAGES_BY_CODE.keys.map { |s| str(s) }.inject { |res,a| res | a }
    }

    # A *command identifier* is defined as "two ASCII-characters". Theoretically
    # that means any ASCII-character except for the NULL-character (which is
    # disallowed) and carriage return (which might only be used as message
    # terminator).
    #
    # However, all existing messages have two digit identifiers. It is highly
    # unlikely that punctuation will be used as command identifiers. For
    # simplicity we reduce the accepted character range to digits and letters.
    #
    rule(:unknown_message_id) {
      known_message_id.absent? >> match["0-9A-Za-z"].repeat(2,2)
    }

    MESSAGES.each do |msg|
      ordered = msg.fetch(:ordered_fields)
      required_delimited = msg.fetch(:required_delimited_fields)
      optional_delimited = msg.fetch(:optional_delimited_fields)
      delimited = required_delimited + optional_delimited

      rule(msg[:symbol]) {
        str(msg[:code]).as(:str).as(:message_code).as(:message_identifiers) >>
        (
          if ordered.any?
            ordered
              .map { |f| self.send(f) }
              .reduce { |res,atom| res >> atom }
          else
            empty_hash
          end
        ).as(:ordered_fields) >>
        (
          if delimited.any?
            delimited
              .map { |f| self.send(f) }
              .reduce { |res,atom| res | atom }
              .repeat.as(:merge_repeat)
          else
            empty_hash
          end
        ).as(:delimited_fields) >>
        (
          if [:request_sc_resend, :request_asc_resend].include?(msg[:symbol])
            checksum_only
          else
            error_detection
          end
        ) >>
        eom
      }
    end

    # Messages with unknown ID:s should be accepted and ignored
    rule(:unknown_message) {
      (unknown_message_id >> (eom.absent? >> any).repeat).as(:str).as(:unknown_message) >> eom
    }

    rule(:known_message) {
      MESSAGES
        .map { |msg| self.send(msg[:symbol]) }
        .reduce { |res,atom| res | atom }
    }

    rule(:messages) {
      (( known_message | unknown_message) >> newline.maybe).repeat
    }

  end
end
