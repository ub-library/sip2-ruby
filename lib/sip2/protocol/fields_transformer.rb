require 'parslet'
require 'parslet/convenience'

module Sip2
  module Protocol

    class FieldsTransformer < Parslet::Transform

      rule(str: simple(:x)) { String(x) }

      rule(str: sequence(:x)) { x.empty? ? "" : x }

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
