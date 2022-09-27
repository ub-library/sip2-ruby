require 'parslet'
require 'parslet/convenience'

require 'sip2/message_types'
module Sip2

  class Transformer < Parslet::Transform

    rule(nil: simple(:_)) { nil }

    rule(int: simple(:x)) { Integer(x) }

    rule(str: simple(:x)) { String(x) }

    rule(str: sequence(:x)) { x.empty? ? "" : x }

    rule(bool: simple(:x)) { 
      case x
      when "Y", "1"
        true
      when "U"
        nil
      else
        false
      end
    }

    rule(tz: simple(:x)) {
      tz = String(x).strip
      tz unless tz.empty?
    }

    rule(
      year: simple(:year),
      month: simple(:month),
      day: simple(:day),
      zone: simple(:zone),
      hour: simple(:hour),
      minute: simple(:minute),
      second: simple(:second)
    ) {
      Time.new(year, month, day, hour, minute, second, zone)
    }

    rule(message_code: simple(:x)) {
      message_type = MESSAGE_TYPES.fetch(x)
      {
        message_code: x,
        message_name: message_type.fetch(:name),
#        message_symbol: message_type.fetch(:symbol)
      }
    }

    rule(merge_repeat: subtree(:x)) {
      x.each_with_object({}) { |el, hsh| hsh.merge!(el) }
    }

    %i[hold_items overdue_items charged_items fine_items recall_items unavailable_hold_items].each do |sym|
      rule(sym => simple(:x)) { x }
    end

    rule(
      message_identifiers: subtree(:ids),
      ordered_fields: subtree(:ordered)
    ) {
      ids.merge(ordered)
    }

    rule(
      message_identifiers: subtree(:ids),
      ordered_fields: subtree(:ordered),
      delimited_fields: subtree(:delimited)
    ) {
      ids.merge(ordered).merge(delimited)
    }


  end

end