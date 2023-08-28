require 'dry-struct'
require 'sip2/types'
module Sip2

  module Message
    class UnknownMessage < Dry::Struct

      schema schema.strict

      transform_keys(&:to_sym)

      attribute :message_code, Types::String.constrained(format: /^[A-Za-z0-9]{2,2}$/)
      attribute :message_name, Types::String.default("Unknown Message".freeze)
      attribute :message_data, Types::String

      def encode
        to_s
      end

      def to_s
        sprintf("%s%s\r", message_code, message_data)
      end

    end
  end
end
