require 'parslet'
require 'parslet/convenience'

module Sip2
  module Meta

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

      rule(:not_type_end) {
        type_terminator.absent? >> newline.absent? >> any
      }

      rule(:empty_line) { spaces.maybe >> newline }

      rule(:digit) { match["0-9"] }

      rule(:lowercase) { match["a-z"] }

      rule(:name_uppercase_part) {
        ( match["A-Z"].repeat(1,3) >> space )
      }

      rule(:name_lowercase_part) {
        lowercase >> ( lowercase | dash | ( space >> (lowercase | slash) ) ).repeat
      }

      rule(:name) {
        ( name_uppercase_part.maybe >> name_lowercase_part)
          .as(:sym).as(:name)
      }

      rule(:code) {
        match["A-Z"].repeat(2,2).as(:str).as(:code)
      }

      rule(:flf_indicator) {
        str("-char") >>
        str(",").maybe >>
        space >>
        (str("fixed-length ") | str("fixed length ")).maybe >>
        str("field") >>
        str(":").maybe >>
        space.maybe
      }

      rule(:fixed_length_field) {
        (
          digit.repeat(1,2).as(:int).as(:flf_length) >>
          flf_indicator >>
          not_type_end.repeat.as(:str).as(:flf_constraint)
        )
      }

      rule(:variable_length_field) {
        str("variable-length field").as(:variable_length_field)
      }

      rule(:fixed_length_checksum) {
        digit.repeat(1,2).as(:int).as(:flf_length) >>
        str("-char, fixed-length message ") >>
        str("checksum").as(:flf_constraint) >>
        str(", ")
      }

      rule(:unclassified_field) {
        not_type_end.repeat(1).as(:str)
      }

      rule(:type) {
        (
          variable_length_field | fixed_length_field | fixed_length_checksum | unclassified_field
        ).as(:type) >>
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
