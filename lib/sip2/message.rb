require 'sip2/fields'
require 'sip2/messages'
require 'sip2/message/base_message'

module Sip2
  module Message

    BY_CODE = {}
    BY_SYMBOL = {}

    def self.[](code)
      BY_CODE[code]
    end

    def self.from_hash(data)
      code = data.fetch(:message_code)
      klass = self[code]
      klass.new(data)
    end

    MESSAGES.each do |msg|

      code = msg.fetch(:code)
      name = msg.fetch(:name)
      symbol = msg.fetch(:symbol)

      class_name = symbol.to_s.split("_").map(&:capitalize).join

      ordered_fields = msg.fetch(:ordered_fields)
      required_delimited_fields = msg.fetch(:required_delimited_fields)
      optional_delimited_fields = msg.fetch(:optional_delimited_fields)

      struct = Class.new(Sip2::Message::BaseMessage) do
        self::CODE = code
        self::NAME = name

        attribute :message_code, Types::String.constrained(eql: code).default(code)
        attribute :message_name, Types::String.constrained(eql: name).default(name)

        @ordered_fields = ordered_fields
        @required_delimited_fields = required_delimited_fields
        @optional_delimited_fields = optional_delimited_fields

        (ordered_fields + required_delimited_fields).each do |field_name|
          field_info = Sip2::FIELDS.fetch(field_name)
          attribute field_name, field_info.fetch(:type) 
        end

        optional_delimited_fields.each do |field_name|
          field_info = Sip2::FIELDS.fetch(field_name)
          attribute? field_name, field_info.fetch(:type) 
        end

      end

      BY_CODE[code] = struct
      BY_SYMBOL[symbol] = struct
      Message.const_set(class_name, struct)

    end

    BY_CODE.freeze
    BY_SYMBOL.freeze
  end
end
