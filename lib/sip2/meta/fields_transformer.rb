require 'parslet'
require 'parslet/convenience'

module Sip2
  module Meta

    class FieldsTransformer < Parslet::Transform

      rule(int: simple(:x)) { Integer(x) }

      rule(str: simple(:x)) { String(x) }

      rule(sym: simple(:x)) {
        String(x).downcase.gsub(%r"[-/]", "").gsub(/ +/, "_").to_sym
      }

      rule(str: sequence(:x)) { x.empty? ? "" : x }

      rule(flf_length: simple(:length), flf_constraint: simple(:constraint)) {
        case constraint
        when "Y or N"
          "bool"
        when "Y or N or U", "Y or N or (obsolete)U"
          "nillable_bool"
        when "(00 thru 99)"
          "(digit >> digit).as(:int)"
        when "(01 thru 99)"
          "(digit >> digit).as(:natural)"
        when "(1 thru 9)"
          "natural"
        when "0 or 1"
          "numerical_bool"
        when "0 or 1 or 2"
          'match["012"].as(:int)'
        when "YYYYMMDDZZZZHHMMSS"
          'timestamp'
        when "x.xx"
          '(digit >> str(".") >> digit >> digit).as(:str)'
        when "checksum"
          "hex_digit.repeat(#{length},#{length}).as(:str)"
        else
          case length
          when 4
            "digit.repeat(4,4).as(:int)"
          when 1
            "any_valid.as(:str)"
          else
            "any_valid.repeat(#{length}, #{length}).as(:str)"
          end
        end
      }

      rule(variable_length_field: simple(:x)) {
        "variable_length_value"
      }

      rule(lines: simple(:x)) { x }

      rule(lines: sequence(:lines)) { 
        indent = lines[1..-1]              # First line is unindented
          .reject { |l| l.match(/^\b*$/) } # Skip blank lines
          .map { |l| l.match(/^( *)/)[1] } # Find indents
          .min                             # Keep the shortest

        if indent
          lines.join.gsub(/^#{indent}/, "")
        else
          lines.join # Equivalent but faster(?)
        end
      }

    end

  end
end
