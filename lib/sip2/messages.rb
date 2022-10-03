# frozen_string_literal: true
#
# GENERATED FILE. DO NOT EDIT DIRECTLY.

module Sip2
  MESSAGES = [
    {
      code: "01",
      name: "Block Patron",
      symbol: :block_patron,
      ordered_fields: %i[
        card_retained
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        blocked_card_msg
        patron_identifier
        terminal_password
      ],
      # TODO: Move any optional fields for Block Patron here
      optional_delimited_fields: [],
    },
    {
      code: "09",
      name: "Checkin",
      symbol: :checkin,
      ordered_fields: %i[
        no_block
        transaction_date
        return_date
      ],
      required_delimited_fields: %i[
        current_location
        institution_id
        item_identifier
        terminal_password
        item_properties
        cancel
      ],
      # TODO: Move any optional fields for Checkin here
      optional_delimited_fields: [],
    },
    {
      code: "10",
      name: "Checkin Response",
      symbol: :checkin_response,
      ordered_fields: %i[
        ok
        resensitize
        magnetic_media
        alert
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        item_identifier
        permanent_location
        title_identifier
        sort_bin
        patron_identifier
        media_type
        item_properties
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for Checkin Response here
      optional_delimited_fields: [],
    },
    {
      code: "11",
      name: "Checkout",
      symbol: :checkout,
      ordered_fields: %i[
        sc_renewal_policy
        no_block
        transaction_date
        nb_due_date
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        item_identifier
        terminal_password
        patron_password
        item_properties
        fee_acknowledged
        cancel
      ],
      # TODO: Move any optional fields for Checkout here
      optional_delimited_fields: [],
    },
    {
      code: "12",
      name: "Checkout Response",
      symbol: :checkout_response,
      ordered_fields: %i[
        ok
        renewal_ok
        magnetic_media
        desensitize
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        item_identifier
        title_identifier
        due_date
        fee_type
        security_inhibit
        currency_type
        fee_amount
        media_type
        item_properties
        transaction_id
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for Checkout Response here
      optional_delimited_fields: [],
    },
    {
      code: "15",
      name: "Hold",
      symbol: :hold,
      ordered_fields: %i[
        hold_mode
        transaction_date
      ],
      required_delimited_fields: %i[
        expiration_date
        pickup_location
        hold_type
        institution_id
        patron_identifier
        patron_password
        item_identifier
        title_identifier
        terminal_password
        fee_acknowledged
      ],
      # TODO: Move any optional fields for Hold here
      optional_delimited_fields: [],
    },
    {
      code: "16",
      name: "Hold Response",
      symbol: :hold_response,
      ordered_fields: %i[
        ok
        available
        transaction_date
      ],
      required_delimited_fields: %i[
        expiration_date
        queue_position
        pickup_location
        institution_id
        patron_identifier
        item_identifier
        title_identifier
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for Hold Response here
      optional_delimited_fields: [],
    },
    {
      code: "17",
      name: "Item Information",
      symbol: :item_information,
      ordered_fields: %i[
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        item_identifier
        terminal_password
      ],
      # TODO: Move any optional fields for Item Information here
      optional_delimited_fields: [],
    },
    {
      code: "18",
      name: "Item Information Response",
      symbol: :item_information_response,
      ordered_fields: %i[
        circulation_status
        security_marker
        fee_type_fixed
        transaction_date
      ],
      required_delimited_fields: %i[
        hold_queue_length
        due_date
        recall_date
        hold_pickup_date
        item_identifier
        title_identifier
        owner
        currency_type
        fee_amount
        media_type
        permanent_location
        current_location
        item_properties
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for Item Information Response here
      optional_delimited_fields: [],
    },
    {
      code: "19",
      name: "Item Status Update",
      symbol: :item_status_update,
      ordered_fields: %i[
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        item_identifier
        terminal_password
        item_properties
      ],
      # TODO: Move any optional fields for Item Status Update here
      optional_delimited_fields: [],
    },
    {
      code: "20",
      name: "Item Status Update Response",
      symbol: :item_status_update_response,
      ordered_fields: %i[
        item_properties_ok
        transaction_date
      ],
      required_delimited_fields: %i[
        item_identifier
        title_identifier
        item_properties
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for Item Status Update Response here
      optional_delimited_fields: [],
    },
    {
      code: "23",
      name: "Patron Status Request",
      symbol: :patron_status_request,
      ordered_fields: %i[
        language
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        terminal_password
        patron_password
      ],
      # TODO: Move any optional fields for Patron Status Request here
      optional_delimited_fields: [],
    },
    {
      code: "24",
      name: "Patron Status Response",
      symbol: :patron_status_response,
      ordered_fields: %i[
        patron_status
        language
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        personal_name
        valid_patron
        valid_patron_password
        currency_type
        fee_amount
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for Patron Status Response here
      optional_delimited_fields: [],
    },
    {
      code: "25",
      name: "Patron Enable",
      symbol: :patron_enable,
      ordered_fields: %i[
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        terminal_password
        patron_password
      ],
      # TODO: Move any optional fields for Patron Enable here
      optional_delimited_fields: [],
    },
    {
      code: "26",
      name: "Patron Enable Response",
      symbol: :patron_enable_response,
      ordered_fields: %i[
        patron_status
        language
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        personal_name
        valid_patron
        valid_patron_password
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for Patron Enable Response here
      optional_delimited_fields: [],
    },
    {
      code: "29",
      name: "Renew",
      symbol: :renew,
      ordered_fields: %i[
        third_party_allowed
        no_block
        transaction_date
        nb_due_date
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        patron_password
        item_identifier
        title_identifier
        terminal_password
        item_properties
        fee_acknowledged
      ],
      # TODO: Move any optional fields for Renew here
      optional_delimited_fields: [],
    },
    {
      code: "30",
      name: "Renew Response",
      symbol: :renew_response,
      ordered_fields: %i[
        ok
        renewal_ok
        magnetic_media
        desensitize
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        item_identifier
        title_identifier
        due_date
        fee_type
        security_inhibit
        currency_type
        fee_amount
        media_type
        item_properties
        transaction_id
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for Renew Response here
      optional_delimited_fields: [],
    },
    {
      code: "35",
      name: "End Patron Session",
      symbol: :end_patron_session,
      ordered_fields: %i[
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        terminal_password
        patron_password
      ],
      # TODO: Move any optional fields for End Patron Session here
      optional_delimited_fields: [],
    },
    {
      code: "36",
      name: "End Session Response",
      symbol: :end_session_response,
      ordered_fields: %i[
        end_session
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for End Session Response here
      optional_delimited_fields: [],
    },
    {
      code: "37",
      name: "Fee Paid",
      symbol: :fee_paid,
      ordered_fields: %i[
        transaction_date
        fee_type_fixed
        payment_type
      ],
      required_delimited_fields: %i[
        currency_type
        fee_amount
        institution_id
        patron_identifier
        terminal_password
        patron_password
        fee_identifier
        transaction_id
      ],
      # TODO: Move any optional fields for Fee Paid here
      optional_delimited_fields: [],
    },
    {
      code: "38",
      name: "Fee Paid Response",
      symbol: :fee_paid_response,
      ordered_fields: %i[
        payment_accepted
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        transaction_id
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for Fee Paid Response here
      optional_delimited_fields: [],
    },
    {
      code: "63",
      name: "Patron Information",
      symbol: :patron_information,
      ordered_fields: %i[
        language
        transaction_date
        summary
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        terminal_password
        patron_password
        start_item
        end_item
      ],
      # TODO: Move any optional fields for Patron Information here
      optional_delimited_fields: [],
    },
    {
      code: "64",
      name: "Patron Information Response",
      symbol: :patron_information_response,
      ordered_fields: %i[
        patron_status
        language
        transaction_date
        hold_items_count
        overdue_items_count
        charged_items_count
        fine_items_count
        recall_items_count
        unavailable_holds_count
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        personal_name
        hold_items_limit
        overdue_items_limit
        charged_items_limit
        valid_patron
        valid_patron_password
        currency_type
        fee_amount
        fee_limit
        items
        home_address
        email_address
        home_phone_number
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for Patron Information Response here
      optional_delimited_fields: [],
    },
    {
      code: "65",
      name: "Renew All",
      symbol: :renew_all,
      ordered_fields: %i[
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        patron_identifier
        patron_password
        terminal_password
        fee_acknowledged
      ],
      # TODO: Move any optional fields for Renew All here
      optional_delimited_fields: [],
    },
    {
      code: "66",
      name: "Renew All Response",
      symbol: :renew_all_response,
      ordered_fields: %i[
        ok
        renewed_count
        unrenewed_count
        transaction_date
      ],
      required_delimited_fields: %i[
        institution_id
        renewed_items
        unrenewed_items
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for Renew All Response here
      optional_delimited_fields: [],
    },
    {
      code: "93",
      name: "Login",
      symbol: :login,
      ordered_fields: %i[
        uid_algorithm
        pwd_algorithm
      ],
      required_delimited_fields: %i[
        login_user_id
        login_password
        location_code
      ],
      # TODO: Move any optional fields for Login here
      optional_delimited_fields: [],
    },
    {
      code: "94",
      name: "Login Response",
      symbol: :login_response,
      ordered_fields: %i[
        ok
      ],
      required_delimited_fields: [],
      optional_delimited_fields: [],
    },
    {
      code: "96",
      name: "Request SC Resend",
      symbol: :request_sc_resend,
      ordered_fields: [],
      required_delimited_fields: [],
      optional_delimited_fields: [],
    },
    {
      code: "97",
      name: "Request ACS Resend",
      symbol: :request_acs_resend,
      ordered_fields: [],
      required_delimited_fields: [],
      optional_delimited_fields: [],
    },
    {
      code: "98",
      name: "ACS Status",
      symbol: :acs_status,
      ordered_fields: %i[
        online_status
        checkin_ok
        checkout_ok
        acs_renewal_policy
        status_update_ok
        offline_ok
        timeout_period
        retries_allowed
        date_time_sync
        protocol_version
      ],
      required_delimited_fields: %i[
        institution_id
        library_name
        supported_messages
        terminal_location
        screen_message
        print_line
      ],
      # TODO: Move any optional fields for ACS Status here
      optional_delimited_fields: [],
    },
    {
      code: "99",
      name: "SC Status",
      symbol: :sc_status,
      ordered_fields: %i[
        status_code
        max_print_width
        protocol_version
      ],
      required_delimited_fields: [],
      optional_delimited_fields: [],
    },
  ]

  MESSAGES_BY_CODE = MESSAGES
    .group_by { |m| m[:code] }
    .map { |k,v| [k,v.first] }
    .to_h
end
