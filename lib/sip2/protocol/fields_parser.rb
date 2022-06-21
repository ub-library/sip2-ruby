require 'parslet'
require 'parslet/convenience'

module Sip2
  module Protocol

    class FieldsParser < Parslet::Parser

      rule(:newline) { str("\n") }
      rule(:space) { str(" ") }
      rule(:spaces) { space.repeat(1) }

      rule(:dash) { str("-") }
      rule(:slash) { str("/") }
      rule(:period) { str(".") }
      rule(:semicolon) { str(";") }

      rule(:eof) { any.absent? }
      rule(:eol) { (newline.absent?).absent? }

      rule(:type_terminator) { (period | semicolon) >> (space | eol) }

      rule(:empty_line) { spaces.maybe >> newline }

      rule(:lowercase) { match["a-z"] }

      rule(:name_uppercase_part) {
        ( match["A-Z"].repeat(1,3) >> space )
      }

      rule(:name_lowercase_part) {
        lowercase >> ( lowercase | dash | ( space >> (lowercase | slash) ) ).repeat
      }

      rule(:name) {
        ( name_uppercase_part.maybe >> name_lowercase_part)
          .as(:str).as(:name)
      }

      rule(:code) {
        match["A-Z"].repeat(2,2).as(:str).as(:code)
      }

      rule(:type) {
        (
          (type_terminator.absent? >> newline.absent? >> any).repeat(1)
        ).as(:str).as(:type) >>
        type_terminator.maybe.as(:str).as(:type_terminator)
      }

      rule(:rest_of_line) { (newline.absent? >> any).repeat >> newline }
      rule(:doc_line) { (name.absent? >> eof.absent? >> rest_of_line).as(:str) }
      rule(:doc_lines) { ( empty_line | doc_line ).repeat }
      rule(:doc) { (rest_of_line.as(:str) >> doc_lines).as(:lines).as(:doc) } #.as(:str).as(:doc) }
      rule(:field) { name >> spaces.maybe >> code.maybe >> spaces.maybe >> type >> doc }
      rule(:fields) { newline.repeat >> field.repeat }
      root(:fields)
    end
  end
end
