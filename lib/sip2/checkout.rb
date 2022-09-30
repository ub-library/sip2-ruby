# frozen_string_literal: true
require 'dry-struct'
require 'sip2/fields'

module Sip2
  module Types
    include Dry.Types()
  end

  class Checkout < Dry::Struct

    @fields = []
    class << self

      def field(f)
        field = Sip2::FIELDS.fetch(f)
        @fields << field.merge(symbol: f)

        attribute f, field[:type] 
      end

      def field?(f)
        field = Sip2::FIELDS.fetch(f)
        @fields << field.merge(symbol: f)
        attribute? f, field[:type] 
      end

      def fields
        @fields
      end

    end

    schema schema.strict

    CODE = "11"
    NAME = "Checkout"

    attribute? :message_code, Types::String.default(CODE)
    attribute? :message_name, Types::String.default(NAME)

    field :sc_renewal_policy
    field :no_block
    field :transaction_date
    field :nb_due_date

    field :institution_id
    field :patron_identifier
    field :item_identifier
    field :terminal_password
    field :patron_password
    field :fee_acknowledged

    DELIMITED_FIELD_FMT = "%<code>s%<value>s|"

    def fields
      self.class.fields
    end

    def to_sip2
      ordered_fields = fields
        .select { |f| f[:code] == "" }
        .map { |f| f.fetch(:format).call(self[f.fetch(:symbol)]) }
      delimited_fields = fields
        .reject { |f| f[:code] == "" }
        .map { |f|
          sprintf("%<code>s%<value>s|",
                  code: f.fetch(:code),
                  value: f.fetch(:format).call(self[f.fetch(:symbol)])
          )
      }
      sprintf("%<code>s%<ordered_fields>s%<delimited_fields>s\r",
              code: CODE,
              ordered_fields: ordered_fields.join,
              delimited_fields: delimited_fields.join,
             )
    end

  end
end
#    rule(:checkout) {
#      str("11").as(:str).as(:message_code).as(:message_identifiers) >>
#        (sc_renewal_policy >> no_block >> transaction_date >> nb_due_date).as(:ordered_fields) >>
#        (institution_id | patron_identifier | item_identifier | terminal_password | patron_password | item_properties | fee_acknowledged | cancel).repeat.as(:merge_repeat).as(:delimited_fields) >>
#        error_detection >>
#        eom
#    }
