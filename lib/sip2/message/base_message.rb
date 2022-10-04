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
        format = field_info.fetch(:format)

        if self.attributes.key?(field_name)
          format.call(self[field_name])
        else
          ""
        end
      end

      # TODO: Calculate the real checksum
      def append_checksum(message)
        unless self.class.instance_variable_get("@warned_about_checksum")
          warn "*** CHECKSUM NOT IMPLEMENTED! Will reuse old checksums ..."
          self.class.instance_variable_set("@warned_about_checksum", true)
        end
        field_info = Sip2::FIELDS.fetch(:checksum)
        checksum = field_info.fetch(:format).call(self[:checksum])

        sprintf("%s%s", message, checksum)
      end

      def append_error_detection(message)
        if attributes.has_key?(:checksum)

          if attributes.has_key?(:sequence_number)
            field_info = Sip2::FIELDS.fetch(:sequence_number)
            sequence_number = field_info.fetch(:format).call(self[:sequence_number])
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
