require 'dry-struct'
require 'sip2/fields'
module Sip2
  module Types
    include Dry.Types()
  end

  module Message
    class BaseMessage < Dry::Struct

      SEQUENCE_NUMBER_FORMAT = Sip2::FIELDS.fetch(:sequence_number).fetch(:format)
      CHECKSUM_CODE = Sip2::FIELDS.fetch(:checksum).fetch(:code)

      schema schema.strict

      transform_keys(&:to_sym)

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
        format = field_info.fetch(:format)

        if self.attributes.key?(field_name)
          format.call(self[field_name])
        else
          ""
        end
      end

      def checksum(msg)
        # Add each character as an unsigned binary number
        sum = msg.codepoints.sum

        # Take the lower 16 bits of the total
        sum16 = sum & 0xFFFF

        # Perform a 2's complement
        comp2 = (sum16 ^ 0xFFFF) + 1

        # The checksum field is the result represented by four hex digits
        sprintf("%04X", comp2)
      end

      # TODO: Calculate the real checksum
      def append_checksum(message)
        message_and_code = message + CHECKSUM_CODE

        checksum = checksum(message_and_code)

        sprintf("%s%s", message_and_code, checksum)
      end

      def append_error_detection(message)
        if attributes.has_key?(:checksum)

          if attributes.has_key?(:sequence_number)
            sequence_number = SEQUENCE_NUMBER_FORMAT.call(self[:sequence_number])
          else
            sequence_number = ""
          end

          append_checksum(sprintf("%s%s", message, sequence_number))
        else
          message
        end

      end

      def to_s
        message = sprintf(
          "%<code>s%<ordered_fields>s%<delimited_fields>s",
          code: self.class::CODE,
          ordered_fields:
            ordered_fields.map { |f| format_field(f) }.join,
          delimited_fields:
            delimited_fields.map { |f| format_field(f) }.join,
        )
        message_with_error_detection = append_error_detection(message)
        sprintf("%s\r", message_with_error_detection)
      end


    end
  end
end
