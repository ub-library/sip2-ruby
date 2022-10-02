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

        def inherited(subclass)
          subclass.instance_eval {
            @fields = []
          }
          super
        end

        def field(f)
          field = Sip2::FIELDS.fetch(f)
          @fields << field.merge(symbol: f)

          attribute f, field[:type] 
        end

        def field?(field)
          field_info = Sip2::FIELDS.fetch(field)
          @fields << field_info.merge(symbol: field)
          attribute? field, field_info[:type] 
        end

        def fields
          @fields
        end

        def ordered_fields
          @ordered_fields ||= fields.select { |f| f[:code] == "" }
        end

        def delimited_fields
          @delimited_fields ||= fields.reject { |f| f[:code] == "" }
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

      def format_field(field_info)
        code = field_info[:code]
        field_name = field_info.fetch(:symbol)
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
