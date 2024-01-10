require 'dry-types'
require 'dry-struct'
require 'sip2/types'
module Sip2

  format_bool = ->(v) { v ? "Y" : "N" }

  format_bool_nillable = ->(v) { v.nil? ? 'U' : format_bool.(v) }

  format_bool_with_space = ->(v) { v ? "Y" : " " }

  format_int_2 = ->(v) { sprintf('%02d', v) }

  format_int_3 = ->(v) { sprintf('%03d', v) }

  format_int_4 = ->(v) { sprintf('%04d', v) }

  format_int_4_or_blank = ->(v) { v.nil? ? "    " : sprintf("%04d", v) }

  format_string = ->(v) { v.to_s }

  format_coded = ->(code, formatter) {
    ->(v) { sprintf("%s%s|", code, formatter.call(v)) }
  }

  format_coded_array = ->(code, formatter) {
    ->(v) {
      v.map { |el| format_coded.call(code, formatter).call(el) }
    }
  }

  format_error_correction = ->(code, formatter) {
    ->(v) { sprintf("%s%s", code, formatter.call(v)) }
  }

  # TODO: Proper roundtrip of one letter time zones?
  format_timestamp = ->(v) {
    tz = v.utc? ? "Z" : ""
    tz = sprintf("%4s", tz)
    v.strftime("%Y%m%d#{tz}%H%M%S")
  }

  format_timestamp_or_blanks = ->(v) {
    v ? format_timestamp.(v) : sprintf("%18s", "")
  }

  FIELDS = {
    acs_renewal_policy: {
      type: Types::Bool,
      format: format_bool,
    },

    alert: {
      type: Types::Bool,
      format: format_bool,
    },

    available: {
      type: Types::Bool,
      format: format_bool,
    },

    blocked_card_msg: {
      code: "AL",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    cancel: {
      code: "BI",
      type: Types::Bool,
      format: format_bool,
    },

    card_retained: {
      type: Types::Bool,
      format: format_bool,
    },

    charged_items: {
      code: "AU",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    charged_items_count: {
      type: Types::Integer.constrained(included_in: 0..9999).optional,
      format: format_int_4_or_blank,
    },

    charged_items_limit: {
      code: "CB",
      type: Types::Integer.constrained(included_in: 0..9999),
      format: format_int_4,
    },

    checkin_ok: {
      type: Types::Bool,
      format: format_bool,
    },

    checkout_ok: {
      type: Types::Bool,
      format: format_bool,
    },

    checksum: {
      code: "AZ",
      type: Types::String.constrained(format: /^[0-9A-Fa-f]{4,4}$/),
      format: format_string,
    },

    circulation_status: {
      type: Types::Integer.constrained(included_in: 0..99),
      format: format_int_2,
    },

    currency_type: {
      code: "BH",
      type: Types::String.constrained(size: 3),
      format: format_string,
    },

    currency_type_ordered: {
      name: :currency_type,
      type: Types::String.constrained(size: 3),
      format: format_string,
    },

    current_location: {
      code: "AP",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    date_time_sync: {
      type: Types::JSON::Time,
      format: format_timestamp,
    },

    desensitize: {
      type: Types::Bool.optional,
      format: format_bool_nillable,
    },

    due_date: {
      code: "AH",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    email_address: {
      code: "BE",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    end_item: {
      code: "BQ",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    end_session: {
      type: Types::Bool,
      format: format_bool,
    },

    expiration_date: {
      code: "BW",
      type: Types::JSON::Time,
      format: format_timestamp,
    },

    fee_acknowledged: {
      code: "BO",
      type: Types::Bool,
      format: format_bool,
    },

    fee_amount: {
      code: "BV",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    fee_identifier: {
      code: "CG",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    fee_limit: {
      code: "CC",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    fee_type: {
      code: "BT",
      type: Types::Integer.constrained(included_in: 1..99),
      format: format_int_2,
    },

    fee_type_ordered: {
      name: :fee_type,
      type: Types::Integer.constrained(included_in: 1..99),
      format: format_int_2,
    },

    fine_items: {
      code: "AV",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    fine_items_count: {
      type: Types::Integer.constrained(included_in: 0..9999).optional,
      format: format_int_4_or_blank,
    },

    hold_items: {
      code: "AS",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    hold_items_count: {
      type: Types::Integer.constrained(included_in: 0..9999).optional,
      format: format_int_4_or_blank,
    },

    hold_items_limit: {
      code: "BZ",
      type: Types::Integer.constrained(included_in: 0..9999),
      format: format_int_4,
    },

    hold_mode: {
      type: Types::String.constrained(size: 1),
      format: format_string,
    },

    hold_pickup_date: {
      code: "CM",
      type: Types::JSON::Time,
      format: format_timestamp,
    },

    hold_queue_length: {
      code: "CF",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    hold_type: {
      code: "BY",
      type: Types::Integer.constrained(included_in: 1..9),
      format: format_string,
    },

    home_address: {
      code: "BD",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    home_phone_number: {
      code: "BF",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    institution_id: {
      code: "AO",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    item_identifier: {
      code: "AB",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    item_properties: {
      code: "CH",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    item_properties_ok: {
      type: Types::String.constrained(size: 1),
      format: format_string,
    },

    # The :items key is defined *after* later as it refers to other keys.
    # the hash.
    #
    #items: {}

    language: {
      type: Types::Integer.constrained(included_in: (0..999)),
      format: format_int_3,
    },

    library_name: {
      code: "AM",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    location_code: {
      code: "CP",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    login_password: {
      code: "CO",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    login_user_id: {
      code: "CN",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    magnetic_media: {
      type: Types::Bool.optional,
      format: format_bool_nillable,
    },

    max_print_width: {
      type: Types::Integer.constrained(included_in: 0..999),
      format: format_int_3,
    },

    media_type: {
      code: "CK",
      type: Types::Integer.constrained(included_in: 0..999),
      format: format_int_3,
    },

    nb_due_date: {
      type: Types::JSON::Time.optional,
      format: format_timestamp_or_blanks,
    },

    no_block: {
      type: Types::Bool,
      format: format_bool,
    },

    offline_ok: {
      type: Types::Bool,
      format: format_bool,
    },

    ok: {
      type: Types::Bool,
      format: ->(v) { v ? "1" : "0" },
    },

    online_status: {
      type: Types::Bool,
      format: format_bool,
    },

    overdue_items: {
      code: "AT",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    overdue_items_count: {
      type: Types::Integer.constrained(included_in: 0..9999).optional,
      format: format_int_4_or_blank,
    },

    overdue_items_limit: {
      code: "CA",
      type: Types::Integer.constrained(included_in: 0..9999),
      format: format_int_4,
    },

    owner: {
      code: "BG",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    patron_identifier: {
      code: "AA",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    patron_password: {
      code: "AD",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    patron_status: {
      type: {
        charge_privileges_denied: Types::Bool,
        renewal_privileges_denied: Types::Bool,
        recall_privileges_denied: Types::Bool,
        hold_privileges_denied: Types::Bool,
        card_reported_lost: Types::Bool,
        too_many_items_charged: Types::Bool,
        too_many_items_overdue: Types::Bool,
        too_many_renewals: Types::Bool,
        too_many_claims_of_items_returned: Types::Bool,
        too_many_items_lost: Types::Bool,
        excessive_outstanding_fines: Types::Bool,
        excessive_outstanding_fees: Types::Bool,
        recall_overdue: Types::Bool,
        too_many_items_billed: Types::Bool,
      },
      format: ->(v) {
        v.attributes.map { |_,b| format_bool_with_space.call(b) }
      },
    },

    payment_accepted: {
      type: Types::Bool,
      format: format_bool,
    },

    payment_type: {
      type: Types::Integer.constrained(included_in: 0..99),
      format: format_int_2,
    },

    permanent_location: {
      code: "AQ",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    personal_name: {
      code: "AE",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    pickup_location: {
      code: "BS",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    print_line: {
      code: "AG",
      type: Types::Array.of(Types::String.constrained(max_size: 255)),
      format: format_string,
    },

    protocol_version: {
      type: Types::String.constrained(format: /^\d\.\d\d$/),
      format: format_string,
    },

    pwd_algorithm: {
      type: Types::String.constrained(size: 1),
      format: format_string,
    },

    queue_position: {
      code: "BR",
      type: Types::Integer.constrained(gteq: 0).optional,
      format: format_string,
    },

    recall_date: {
      code: "CJ",
      type: Types::JSON::Time,
      format: format_timestamp,
    },

    recall_items: {
      code: "BU",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    recall_items_count: {
      type: Types::Integer.constrained(included_in: 0..9999).optional,
      format: format_int_4_or_blank,
    },

    renewal_ok: {
      type: Types::Bool,
      format: format_bool,
    },

    renewed_count: {
      type: Types::Integer.constrained(included_in: 0..9999),
      format: format_int_4_or_blank,
    },

    renewed_items: {
      code: "BM",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    resensitize: {
      type: Types::Bool,
      format: format_bool,
    },

    retries_allowed: {
      type: Types::Integer.constrained(included_in: 0..999),
      format: format_int_3,
    },

    return_date: {
      type: Types::JSON::Time,
      format: format_timestamp,
    },

    sc_renewal_policy: {
      type: Types::Bool,
      format: format_bool,
    },

    screen_message: {
      code: "AF",
      type: Types::Array.of(Types::String.constrained(max_size: 255)),
      format: format_string,
    },

    security_inhibit: {
      code: "CI",
      type: Types::Bool,
      format: format_bool,
    },

    security_marker: {
      type: Types::Integer.constrained(included_in: 0..99),
      format: format_int_2,
    },

    sequence_number: {
      code: "AY",
      type: Types::Integer.constrained(included_in: 0..9),
      format: format_string,
    },

    sort_bin: {
      code: "CL",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    start_item: {
      code: "BP",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    status_code: {
      type: Types::Integer.constrained(included_in: 0..2),
      format: format_string,
    },

    status_update_ok: {
      type: Types::Bool,
      format: format_bool,
    },

    summary: {
      type: {
        hold_items: Types::Bool,
        overdue_items: Types::Bool,
        charged_items: Types::Bool,
        fine_items: Types::Bool,
        recall_items: Types::Bool,
        unavailable_holds: Types::Bool,
      },
      format: ->(v) {
        v.attributes.map { |_,b| format_bool_with_space.call(b) }.join + " "*4
      },
    },

    supported_messages: {
      code: "BX",
      type: {
        patron_status_request: Types::Bool,
        checkout: Types::Bool,
        checkin: Types::Bool,
        block_patron: Types::Bool,
        sc_acs_status: Types::Bool,
        request_sc_asc_resend: Types::Bool,
        login: Types::Bool,
        patron_information: Types::Bool,
        end_patron_session: Types::Bool,
        fee_paid: Types::Bool,
        item_information: Types::Bool,
        item_status_update: Types::Bool,
        patron_enable: Types::Bool,
        hold: Types::Bool,
        renew: Types::Bool,
        renew_all: Types::Bool,
      },
      format: ->(v) {
        v.attributes.map { |_,b| format_bool.call(b) }.join
      },
    },

    terminal_location: {
      code: "AN",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    terminal_password: {
      code: "AC",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    third_party_allowed: {
      type: Types::Bool,
      format: format_bool,
    },

    timeout_period: {
      type: Types::Integer.constrained(included_in: 0..999),
      format: format_int_3,
    },

    title_identifier: {
      code: "AJ",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    transaction_date: {
      type: Types::JSON::Time,
      format: format_timestamp,
    },

    transaction_id: {
      code: "BK",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    uid_algorithm: {
      type: Types::String.constrained(size: 1),
      format: format_string,
    },

    unavailable_holds_count: {
      type: Types::Integer.constrained(included_in: 0..9999).optional,
      format: format_int_4_or_blank,
    },

    unavailable_hold_items: {
      code: "CD",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    unrenewed_count: {
      type: Types::Integer.constrained(included_in: 0..9999),
      format: format_int_4,
    },

    unrenewed_items: {
      code: "BN",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    valid_patron: {
      code: "BL",
      type: Types::Bool,
      format: format_bool,
    },

    valid_patron_password: {
      code: "CQ",
      type: Types::Bool,
      format: format_bool,
    },

  }

  items_subfields = %i[
    hold_items
    overdue_items
    charged_items
    fine_items
    recall_items
    unavailable_hold_items
  ]

  FIELDS[:items] = {
    type: items_subfields
      .map { |f|
        Class.new(Dry::Struct) do
          transform_keys(&:to_sym)
          attribute f, Types::Array.of(FIELDS.fetch(f).fetch(:type))
        end
      }
      .reduce { |res,type| res | type },
    format: ->(outer) {
      outer.attributes.map { |subfield,ary|
        subfield_info = FIELDS.fetch(subfield)
        formatter = subfield_info.fetch(:format)
        ary.map { |inner| formatter.call(inner) }.join
      }.join
    }
  }

  FIELDS.each do |k,v|
    code = v.fetch(:code,"")
    original_formatter = v.fetch(:format)

    final_formatter =
      if [:sequence_number, :checksum].include?(k)
        format_error_correction.call(code, original_formatter)
      elsif [:print_line, :screen_message].include?(k)
        format_coded_array.call(code, original_formatter)
      elsif code != ""
        format_coded.call(code, original_formatter)
      else
        original_formatter
      end

    FIELDS[k] = v.merge(format: final_formatter)
  end


end
