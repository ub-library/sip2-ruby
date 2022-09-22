require 'parslet'
require 'parslet/convenience'

module Sip2
  module Meta

    class MessagesParser < Parslet::Parser

      rule(:newline) { str("\n") }
      rule(:space) { str(" ") }
      rule(:spaces) { space.repeat(1) }

      rule(:dash) { str("-") }
      rule(:slash) { str("/") }
      rule(:period) { str(".") }
      rule(:semicolon) { str(";") }

      rule(:eof) { any.absent? }
      rule(:not_eof) { any.absent? >> any }
      rule(:eol) { (newline.absent?).absent? }

      rule(:empty_line) { spaces.maybe >> newline }
      rule(:non_empty_line) {
        spaces.maybe >>
        (
        (
          newline.absent? >>
          space.absent? >>
          any
        ) >>
        spaces.maybe).repeat(1) >>
        newline
      }

      rule(:digit) { match["0-9"] }
      rule(:lowercase) { match["a-z"] }
      rule(:uppercase) { match["A-Z"] }
      rule(:letter) { lowercase | uppercase }

      rule(:message_code) { match("[0-9]").repeat(2,2) }
      rule(:field_start) { str("<") }
      rule(:field_end) { str(">") }

      rule(:field_name) {
        (
          spaces.maybe >>
          (letter | dash | slash ).repeat(1).as(:field_name_part) >>
          (spaces.maybe >> newline.maybe >> spaces.maybe)
        ).repeat(1)
      }

      rule(:fields) {
        (field_start >> field_name.as(:field_name) >> field_end).repeat
      }

      rule(:message_format) {
        spaces.maybe >>
        message_code.as(:message_code) >>
        fields.as(:fields) >>
        newline
      }

      rule(:v2) { str("2.00") }

      rule(:message_name_part) {
        uppercase.repeat(2) | (uppercase >> lowercase.repeat(1))
      }

      rule(:message_name) {
        (spaces.maybe >> v2.maybe >> spaces.maybe) >>
        (message_name_part >> (space.maybe >> message_name_part).repeat).as(:message_name) >>
        spaces.maybe >>
        newline
      }

      rule(:rest_of_line) { (newline.absent? >> any).repeat >> newline }

      rule(:garbage_line) {
        message_name.absent? >>
        message_format.absent? >>
        rest_of_line
      }

      rule(:message) {
        garbage_line.repeat >>
        message_name >>
        garbage_line.repeat >>
        message_format >>
        garbage_line.repeat
      }

      rule(:messages) { message.repeat(1) }

      root(:messages)

    end
  end
end
