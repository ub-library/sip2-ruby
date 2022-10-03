require 'dry-struct'
require 'sip2/fields'
module Sip2
  module Types
    include Dry.Types()
  end

  module Message
    class BaseMessage < Dry::Struct

      schema schema.strict

      class << self

        def ordered_fields
          @ordered_fields
        end

        def delimited_fields
          @delimited_fields ||=
            @required_delimited_fields + @optional_delimited_fields
        end

      end

      def fields
        self.class.fields
      end

      def ordered_fields
        self.class.ordered_fields
      end

      def delimited_fields
        self.class.delimited_fields
      end

      def format_field(field_name)
        field_info = Sip2::FIELDS.fetch(field_name)
        code = field_info[:code]
        format = field_info.fetch(:format)

        if code != ""
          if self.attributes.key?(field_name)
            sprintf("%<code>s%<value>s|",
                    code: code,
                    value: format.call(self[field_name])
            )
          else
            ""
          end
        else
          format.call(self[field_name])
        end
      end

      def to_sip2
        sprintf("%<code>s%<ordered_fields>s%<delimited_fields>s\r",
                code: self.class::CODE,
                ordered_fields:
                  ordered_fields.map { |f| format_field(f) }.join,
                delimited_fields:
                  delimited_fields.map { |f| format_field(f) }.join,
               )
      end


    end
  end
end
