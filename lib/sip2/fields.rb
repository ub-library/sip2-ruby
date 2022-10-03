require 'dry-types'
module Sip2
  module Types
    include Dry.Types()
  end

  format_bool = ->(v) { v ? "Y" : "N" }

  format_bool_nillable = ->(v) { v.nil? ? 'U' : format_bool.(v) }

  format_bool_with_space = ->(v) { v ? "Y" : " " }

  format_int_2 = ->(v) { sprintf('%02d', v) }

  format_int_3 = ->(v) { sprintf('%03d', v) }

  format_int_4 = ->(v) { sprintf('%04d', v) }

  format_int_4_or_blank = ->(v) { v.nil? ? "    " : sprintf("%04d", v) }

  format_int_4 = ->(v) { sprintf('%04d', v) }

  format_int_4_or_blank = ->(v) { v.nil? ? "    " : sprintf("%04d", v) }

  format_bool_nillable = ->(v) { v.nil? ? 'U' : format_bool.(v) }

  format_string = ->(v) { v.to_s }

  # TODO: Proper roundtrip of one letter time zones?
  format_timestamp = ->(v) {
    tz = sprintf("%4s", v.utc? ? "Z" : String(v.zone))
    if tz == Time.now.getlocal.zone
      tz = sprintf("%4s","")
    end
    v.strftime("%Y%m%d#{tz}%H%M%S")
  }

  format_timestamp_or_blanks = ->(v) {
    v ? format_timestamp.(v) : sprintf("%18s", "")
  }

  FIELDS = {
    acs_renewal_policy: {
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    alert: {
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    available: {
      code: "",
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
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    charged_items: {
      code: "AU",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    charged_items_count: {
      code: "",
      type: Types::Integer.constrained(included_in: 0..9999).optional,
      format: format_int_4_or_blank,
    },

    charged_items_limit: {
      code: "CB",
      type: Types::Integer.constrained(included_in: 0..9999),
      format: format_int_4,
    },

    checkin_ok: {
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    checkout_ok: {
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    checksum: {
      code: "AZ",
      type: Types::String.constrained(format: /^[0-9A-Fa-f]{4,4}$/),
      format: format_string,
    },

    circulation_status: {
      code: "",
      type: Types::Integer.constrained(included_in: 0..99),
      format: format_int_2,
    },

    currency_type: {
      code: "BH",
      type: Types::String.constrained(size: 3),
      format: format_string,
    },

    current_location: {
      code: "AP",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    date_time_sync: {
      code: "",
      type: Types::Time,
      format: format_timestamp,
    },

    desensitize: {
      code: "",
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
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    expiration_date: {
      code: "BW",
      type: Types::Time,
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

    fee_type_fixed: {
      code: "",
      type: Types::Integer.constrained(included_in: 1..99),
      format: format_int_2,
    },

    fine_items: {
      code: "AV",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    fine_items_count: {
      code: "",
      type: Types::Integer.constrained(included_in: 0..9999).optional,
      format: format_int_4_or_blank,
    },

    hold_items: {
      code: "AS",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    hold_items_count: {
      code: "",
      type: Types::Integer.constrained(included_in: 0..9999).optional,
      format: format_int_4_or_blank,
    },

    hold_items_limit: {
      code: "BZ",
      type: Types::Integer.constrained(included_in: 0..9999),
      format: format_int_4,
    },

    hold_mode: {
      code: "",
      type: Types::String.constrained(size: 1),
      format: format_string,
    },

    hold_pickup_date: {
      code: "CM",
      type: Types::Time,
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
      code: "",
      type: Types::String.constrained(size: 1),
      format: format_string,
    },

    # TODO: Handle nested hash
    items: {
      type: Types::Hash.schema(
        charged_items: Types::String.constrained(max_size: 255),
      )
    },

    language: {
      code: "",
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
      code: "",
      type: Types::Bool.optional,
      format: format_bool_nillable,
    },

    max_print_width: {
      code: "",
      type: Types::Integer.constrained(included_in: 0..999),
      format: format_int_3,
    },

    media_type: {
      code: "CK",
      type: Types::Integer.constrained(included_in: 0..999),
      format: format_int_3,
    },

    nb_due_date: {
      code: "",
      type: Types::Time.optional,
      format: format_timestamp_or_blanks,
    },

    no_block: {
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    offline_ok: {
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    ok: {
      code: "",
      type: Types::Bool,
      format: ->(v) { v ? "1" : "0" },
    },

    online_status: {
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    overdue_items: {
      code: "AT",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    overdue_items_count: {
      code: "",
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

    # TODO: Handle nested schema
    patron_status: {
      code: "",
      type: Types::String.constrained(size: 14),
      format: format_string,
    },

    payment_accepted: {
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    payment_type: {
      code: "",
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
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    protocol_version: {
      code: "",
      type: Types::String.constrained(format: /^\d\.\d\d$/),
      format: format_string,
    },

    pwd_algorithm: {
      code: "",
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
      type: Types::Time,
      format: format_timestamp,
    },

    recall_items: {
      code: "BU",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    recall_items_count: {
      code: "",
      type: Types::Integer.constrained(included_in: 0..9999).optional,
      format: format_int_4_or_blank,
    },

    renewal_ok: {
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    renewed_count: {
      code: "",
      type: Types::Integer.constrained(included_in: 0..9999),
      format: format_int_4_or_blank,
    },

    renewed_items: {
      code: "BM",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    resensitize: {
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    retries_allowed: {
      code: "",
      type: Types::Integer.constrained(included_in: 0..999),
      format: format_int_3,
    },

    return_date: {
      code: "",
      type: Types::Time,
      format: format_timestamp,
    },

    sc_renewal_policy: {
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    screen_message: {
      code: "AF",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    security_inhibit: {
      code: "CI",
      type: Types::Bool,
      format: format_bool,
    },

    security_marker: {
      code: "",
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
      code: "",
      type: Types::Integer.constrained(included_in: 0..2),
      format: format_string,
    },

    status_update_ok: {
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    # TODO: Handled nested hash
    summary: {
      code: "",
      type: Types::String.constrained(size: 10),
      format: format_string,
    },

    supported_messages: {
      code: "BX",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
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
      code: "",
      type: Types::Bool,
      format: format_bool,
    },

    timeout_period: {
      code: "",
      type: Types::Integer.constrained(included_in: 0..999),
      format: format_int_3,
    },

    title_identifier: {
      code: "AJ",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    transaction_date: {
      code: "",
      type: Types::Time,
      format: format_timestamp,
    },

    transaction_id: {
      code: "BK",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    uid_algorithm: {
      code: "",
      type: Types::String.constrained(size: 1),
      format: format_string,
    },

    unavailable_holds_count: {
      code: "",
      type: Types::Integer.constrained(included_in: 0..9999).optional,
      format: format_int_4_or_blank,
    },

    unavailable_hold_items: {
      code: "CD",
      type: Types::String.constrained(max_size: 255),
      format: format_string,
    },

    unrenewed_count: {
      code: "",
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

end
