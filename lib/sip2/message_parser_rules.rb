require 'parslet'
require 'sip2/field_parser_rules'

module Sip2
  module MessageParserRules
    include Parslet

    include Sip2::FieldParserRules

    rule(:eom) { str("\r") }
    rule(:newline) { str("\n") }

    rule(:empty_hash) {
      str("").as(:empty_hash)
    }

    rule(:no_ordered_fields) {
      empty_hash.as(:ordered_fields)
    }

    rule(:no_delimited_fields) {
      empty_hash.as(:delimited_fields)
    }

    rule(:error_detection) {
      ( (sequence_number >> checksum) | empty_hash ).as(:error_detection)
    }

    rule(:checksum_only) {
      ( checksum | empty_hash ).as(:error_detection)
    }

    # Block Patron (01)
    rule(:block_patron) {
      str("01").as(:str).as(:message_code).as(:message_identifiers) >>
        (card_retained >> transaction_date).as(:ordered_fields) >>
        (institution_id | blocked_card_msg | patron_identifier | terminal_password).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Checkin (09)
    rule(:checkin) {
      str("09").as(:str).as(:message_code).as(:message_identifiers) >>
        (no_block >> transaction_date >> return_date).as(:ordered_fields) >>
        (current_location | institution_id | item_identifier | terminal_password | item_properties | cancel).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Checkin Response (10)
    rule(:checkin_response) {
      str("10").as(:str).as(:message_code).as(:message_identifiers) >>
        (ok >> resensitize >> magnetic_media >> alert >> transaction_date).as(:ordered_fields) >>
        (institution_id | item_identifier | permanent_location | title_identifier | sort_bin | patron_identifier | media_type | item_properties | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Checkout (11)
    rule(:checkout) {
      str("11").as(:str).as(:message_code).as(:message_identifiers) >>
        (sc_renewal_policy >> no_block >> transaction_date >> nb_due_date).as(:ordered_fields) >>
        (institution_id | patron_identifier | item_identifier | terminal_password | patron_password | item_properties | fee_acknowledged | cancel).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Checkout Response (12)
    rule(:checkout_response) {
      str("12").as(:str).as(:message_code).as(:message_identifiers) >>
        (ok >> renewal_ok >> magnetic_media >> desensitize >> transaction_date).as(:ordered_fields) >>
        (institution_id | patron_identifier | item_identifier | title_identifier | due_date | fee_type | security_inhibit | currency_type | fee_amount | media_type | item_properties | transaction_id | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Hold (15)
    rule(:hold) {
      str("15").as(:str).as(:message_code).as(:message_identifiers) >>
        (hold_mode >> transaction_date).as(:ordered_fields) >>
        (expiration_date | pickup_location | hold_type | institution_id | patron_identifier | patron_password | item_identifier | title_identifier | terminal_password | fee_acknowledged).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Hold Response (16)
    rule(:hold_response) {
      str("16").as(:str).as(:message_code).as(:message_identifiers) >>
        (ok >> available >> transaction_date).as(:ordered_fields) >>
        (expiration_date | queue_position | pickup_location | institution_id | patron_identifier | item_identifier | title_identifier | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Item Information (17)
    rule(:item_information) {
      str("17").as(:str).as(:message_code).as(:message_identifiers) >>
        (transaction_date).as(:ordered_fields) >>
        (institution_id | item_identifier | terminal_password).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Item Information Response (18)
    rule(:item_information_response) {
      str("18").as(:str).as(:message_code).as(:message_identifiers) >>
        (circulation_status >> security_marker >> fee_type_fixed >> transaction_date).as(:ordered_fields) >>
        (hold_queue_length | due_date | recall_date | hold_pickup_date | item_identifier | title_identifier | owner | currency_type | fee_amount | media_type | permanent_location | current_location | item_properties | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Item Status Update (19)
    rule(:item_status_update) {
      str("19").as(:str).as(:message_code).as(:message_identifiers) >>
        (transaction_date).as(:ordered_fields) >>
        (institution_id | item_identifier | terminal_password | item_properties).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Item Status Update Response (20)
    rule(:item_status_update_response) {
      str("20").as(:str).as(:message_code).as(:message_identifiers) >>
        (item_properties_ok >> transaction_date).as(:ordered_fields) >>
        (item_identifier | title_identifier | item_properties | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Patron Status Request (23)
    rule(:patron_status_request) {
      str("23").as(:str).as(:message_code).as(:message_identifiers) >>
        (language >> transaction_date).as(:ordered_fields) >>
        (institution_id | patron_identifier | terminal_password | patron_password).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Patron Status Response (24)
    rule(:patron_status_response) {
      str("24").as(:str).as(:message_code).as(:message_identifiers) >>
        (patron_status >> language >> transaction_date).as(:ordered_fields) >>
        (institution_id | patron_identifier | personal_name | valid_patron | valid_patron_password | currency_type | fee_amount | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Patron Enable (25)
    rule(:patron_enable) {
      str("25").as(:str).as(:message_code).as(:message_identifiers) >>
        (transaction_date).as(:ordered_fields) >>
        (institution_id | patron_identifier | terminal_password | patron_password).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Patron Enable Response (26)
    rule(:patron_enable_response) {
      str("26").as(:str).as(:message_code).as(:message_identifiers) >>
        (patron_status >> language >> transaction_date).as(:ordered_fields) >>
        (institution_id | patron_identifier | personal_name | valid_patron | valid_patron_password | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Renew (29)
    rule(:renew) {
      str("29").as(:str).as(:message_code).as(:message_identifiers) >>
        (third_party_allowed >> no_block >> transaction_date >> nb_due_date).as(:ordered_fields) >>
        (institution_id | patron_identifier | patron_password | item_identifier | title_identifier | terminal_password | item_properties | fee_acknowledged).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Renew Response (30)
    rule(:renew_response) {
      str("30").as(:str).as(:message_code).as(:message_identifiers) >>
        (ok >> renewal_ok >> magnetic_media >> desensitize >> transaction_date).as(:ordered_fields) >>
        (institution_id | patron_identifier | item_identifier | title_identifier | due_date | fee_type | security_inhibit | currency_type | fee_amount | media_type | item_properties | transaction_id | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # End Patron Session (35)
    rule(:end_patron_session) {
      str("35").as(:str).as(:message_code).as(:message_identifiers) >>
        (transaction_date).as(:ordered_fields) >>
        (institution_id | patron_identifier | terminal_password | patron_password).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # End Session Response (36)
    rule(:end_session_response) {
      str("36").as(:str).as(:message_code).as(:message_identifiers) >>
        (end_session >> transaction_date).as(:ordered_fields) >>
        (institution_id | patron_identifier | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Fee Paid (37)
    rule(:fee_paid) {
      str("37").as(:str).as(:message_code).as(:message_identifiers) >>
        (transaction_date >> fee_type_fixed >> payment_type).as(:ordered_fields) >>
        (currency_type | fee_amount | institution_id | patron_identifier | terminal_password | patron_password | fee_identifier | transaction_id).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Fee Paid Response (38)
    rule(:fee_paid_response) {
      str("38").as(:str).as(:message_code).as(:message_identifiers) >>
        (payment_accepted >> transaction_date).as(:ordered_fields) >>
        (institution_id | patron_identifier | transaction_id | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Patron Information (63)
    rule(:patron_information) {
      str("63").as(:str).as(:message_code).as(:message_identifiers) >>
        (language >> transaction_date >> summary).as(:ordered_fields) >>
        (institution_id | patron_identifier | terminal_password | patron_password | start_item | end_item).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Patron Information Response (64)
    rule(:patron_information_response) {
      str("64").as(:str).as(:message_code).as(:message_identifiers) >>
        (patron_status >> language >> transaction_date >> hold_items_count >> overdue_items_count >> charged_items_count >> fine_items_count >> recall_items_count >> unavailable_holds_count).as(:ordered_fields) >>
        (institution_id | patron_identifier | personal_name | hold_items_limit | overdue_items_limit | charged_items_limit | valid_patron | valid_patron_password | currency_type | fee_amount | fee_limit | items | home_address | email_address | home_phone_number | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Renew All (65)
    rule(:renew_all) {
      str("65").as(:str).as(:message_code).as(:message_identifiers) >>
        (transaction_date).as(:ordered_fields) >>
        (institution_id | patron_identifier | patron_password | terminal_password | fee_acknowledged).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Renew All Response (66)
    rule(:renew_all_response) {
      str("66").as(:str).as(:message_code).as(:message_identifiers) >>
        (ok >> renewed_count >> unrenewed_count >> transaction_date).as(:ordered_fields) >>
        (institution_id | renewed_items | unrenewed_items | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Login (93)
    rule(:login) {
      str("93").as(:str).as(:message_code).as(:message_identifiers) >>
        (uid_algorithm >> pwd_algorithm).as(:ordered_fields) >>
        (login_user_id | login_password | location_code).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # Login Response (94)
    rule(:login_response) {
      str("94").as(:str).as(:message_code).as(:message_identifiers) >>
        (ok).as(:ordered_fields) >>
        no_delimited_fields >>
        error_detection >>
        eom
    }

    # Request SC Resend (96)
    rule(:request_sc_resend) {
      str("96").as(:str).as(:message_code).as(:message_identifiers) >>
        no_ordered_fields >>
        no_delimited_fields >>
        checksum_only >>
        eom
    }

    # Request ACS Resend (97)
    rule(:request_acs_resend) {
      str("97").as(:str).as(:message_code).as(:message_identifiers) >>
        no_ordered_fields >>
        no_delimited_fields >>
        checksum_only >>
        eom
    }

    # ACS Status (98)
    rule(:acs_status) {
      str("98").as(:str).as(:message_code).as(:message_identifiers) >>
        (online_status >> checkin_ok >> checkout_ok >> acs_renewal_policy >> status_update_ok >> offline_ok >> timeout_period >> retries_allowed >> date_time_sync >> protocol_version).as(:ordered_fields) >>
        (institution_id | library_name | supported_messages | terminal_location | screen_message | print_line).repeat.as(:merge_repeat).as(:delimited_fields) >>
        error_detection >>
        eom
    }

    # SC Status (99)
    rule(:sc_status) {
      str("99").as(:str).as(:message_code).as(:message_identifiers) >>
        (status_code >> max_print_width >> protocol_version).as(:ordered_fields) >>
        no_delimited_fields >>
        error_detection >>
        eom
    }

    rule(:messages) {
      ((
        block_patron |
        checkin |
        checkin_response |
        checkout |
        checkout_response |
        hold |
        hold_response |
        item_information |
        item_information_response |
        item_status_update |
        item_status_update_response |
        patron_status_request |
        patron_status_response |
        patron_enable |
        patron_enable_response |
        renew |
        renew_response |
        end_patron_session |
        end_session_response |
        fee_paid |
        fee_paid_response |
        patron_information |
        patron_information_response |
        renew_all |
        renew_all_response |
        login |
        login_response |
        request_sc_resend |
        request_acs_resend |
        acs_status |
        sc_status
      ) >> newline.maybe).repeat(1)
    }

  end
end
