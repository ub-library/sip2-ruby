require 'dry-struct'
require 'sip2/types'
require 'sip2/fields'
module Sip2

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

      def checksum_field(message, checksum_encoder: nil)
        msg =
          if checksum_encoder
            checksum_encoder.call(message)
          else
            message
          end
        CHECKSUM_CODE + checksum(msg + CHECKSUM_CODE)
      end

      def sequence_number_field
        if attributes.has_key?(:sequence_number)
          SEQUENCE_NUMBER_FORMAT.call(self[:sequence_number])
        else
          ""
        end
      end

      def error_detection_fields(message, **checksum_options)
        if attributes.has_key?(:checksum)
          sequence_number = sequence_number_field
          sequence_number + checksum_field(message + sequence_number, **checksum_options)
        else
          ""
        end
      end

      def encode(add_error_detection: true, checksum_encoder: nil)
        message = sprintf(
          "%<code>s%<ordered_fields>s%<delimited_fields>s",
          code: self.class::CODE,
          ordered_fields:
            ordered_fields.map { |f| format_field(f) }.join,
          delimited_fields:
            delimited_fields.map { |f| format_field(f) }.join,
        )
        error_detection =
          if add_error_detection 
            error_detection_fields(message, checksum_encoder: checksum_encoder)
          else
            ""
          end
        sprintf("%s%s\r", message, error_detection)
      end

      def to_s
        encode
      end
    end
  end
end
