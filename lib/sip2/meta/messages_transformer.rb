require 'parslet'
require 'parslet/convenience'


require 'sip2/meta/fields_constants'

module Sip2
  module Meta

    class MessagesTransformer < Parslet::Transform

      include FieldsConstants

      rule(str: simple(:x)) { String(x) }

      rule(str: sequence(:x)) { x.empty? ? "" : x }

      rule(sym: simple(:x)) {
        String(x).downcase.gsub(%r"[-/]", "").gsub(/ +/, "_").to_sym
      }

      rule(sym: sequence(:x)) {
        x.join("_").downcase.gsub(%r"[-/]", "").gsub(/ +/, "_").gsub(/_+/, "_")
      }


      rule(field_names: sequence(:x)) {
        if (fee_type_pos = x.index("fee_type"))
          id_pos = x.index("item_identifier") || x.index("patron_identifier")
          if fee_type_pos < id_pos
            x[fee_type_pos] = "fee_type_fixed"
          end
        end
        ordered = x.reject { |el| FIELD_HAS_CODE[el] }
        delimited = x.select { |el| FIELD_HAS_CODE[el] }
        {
          ordered: ordered,
          delimited: delimited
        }
      }


    end

  end
end
