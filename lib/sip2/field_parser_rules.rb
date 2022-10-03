require 'parslet'
require 'sip2/parser_atoms.rb'

module Sip2
  module FieldParserRules
    include Parslet

    include Sip2::ParserAtoms

    rule(:acs_renewal_policy) {
      bool.as(:acs_renewal_policy)
    }

    rule(:alert) {
      bool.as(:alert)
    }

    rule(:available) {
      bool.as(:available)
    }

    rule(:blocked_card_msg) {
      str("AL") >> variable_length_value.as(:blocked_card_msg) >> pipe
    }

    rule(:cancel) {
      str("BI") >> bool.as(:cancel) >> pipe
    }

    rule(:card_retained) {
      bool.as(:card_retained)
    }

    rule(:charged_items) {
      str("AU") >> variable_length_value.as(:charged_items) >> pipe
    }

    rule(:charged_items_count) {
      four_digits_or_blanks.as(:charged_items_count)
    }

    rule(:charged_items_limit) {
      str("CB") >> digit.repeat(4,4).as(:int).as(:charged_items_limit) >> pipe
    }

    rule(:checkin_ok) {
      bool.as(:checkin_ok)
    }

    rule(:checkout_ok) {
      bool.as(:checkout_ok)
    }

    rule(:checksum) {
      str("AZ") >> hex_digit.repeat(4,4).as(:str).as(:checksum)
    }

    rule(:circulation_status) {
      (digit >> digit).as(:int).as(:circulation_status)
    }

    rule(:currency_type) {
      str("BH") >> match["A-Z"].repeat(3,3).as(:str).as(:currency_type) >> pipe
    }

    rule(:current_location) {
      str("AP") >> variable_length_value.as(:current_location) >> pipe
    }

    rule(:date_time_sync) {
      timestamp.as(:date_time_sync)
    }

    rule(:desensitize) {
      nillable_bool.as(:desensitize)
    }

    rule(:due_date) {
      str("AH") >> variable_length_value.as(:due_date) >> pipe
    }

    rule(:email_address) {
      str("BE") >> variable_length_value.as(:email_address) >> pipe
    }

    rule(:end_item) {
      str("BQ") >> variable_length_value.as(:end_item) >> pipe
    }

    rule(:end_session) {
      bool.as(:end_session)
    }

    rule(:expiration_date) {
      str("BW") >> timestamp.as(:expiration_date) >> pipe
    }

    rule(:fee_acknowledged) {
      str("BO") >> bool.as(:fee_acknowledged) >> pipe
    }

    rule(:fee_amount) {
      str("BV") >> variable_length_value.as(:fee_amount) >> pipe
    }

    rule(:fee_identifier) {
      str("CG") >> variable_length_value.as(:fee_identifier) >> pipe
    }

    rule(:fee_limit) {
      str("CC") >> variable_length_value.as(:fee_limit) >> pipe
    }

    rule(:fee_type) {
      str("BT") >> ((zero >> natural) | (natural >> digit)).as(:int).as(:fee_type) >> pipe
    }

    rule(:fee_type_fixed) {
      ((zero >> natural) | (natural >> digit)).as(:int).as(:fee_type_fixed)
    }

    rule(:fine_items) {
      str("AV") >> variable_length_value.as(:fine_items) >> pipe
    }

    rule(:fine_items_count) {
      four_digits_or_blanks.as(:fine_items_count)
    }

    rule(:hold_items) {
      str("AS") >> variable_length_value.as(:hold_items) >> pipe
    }

    rule(:hold_items_count) {
      four_digits_or_blanks.as(:hold_items_count)
    }

    rule(:hold_items_limit) {
      str("BZ") >> digit.repeat(4,4).as(:int).as(:hold_items_limit) >> pipe
    }

    rule(:hold_mode) {
      (str("+") | str("-") | str("*")).as(:str).as(:hold_mode)
    }

    rule(:hold_pickup_date) {
      str("CM") >> timestamp.as(:hold_pickup_date) >> pipe
    }

    rule(:hold_queue_length) {
      str("CF") >> variable_length_value.as(:hold_queue_length) >> pipe
    }

    rule(:hold_type) {
      str("BY") >> natural.as(:int).as(:hold_type) >> pipe
    }

    rule(:home_address) {
      str("BD") >> variable_length_value.as(:home_address) >> pipe
    }

    rule(:home_phone_number) {
      str("BF") >> variable_length_value.as(:home_phone_number) >> pipe
    }

    rule(:institution_id) {
      str("AO") >> variable_length_value.as(:institution_id) >> pipe
    }

    rule(:item_identifier) {
      str("AB") >> variable_length_value.as(:item_identifier) >> pipe
    }

    rule(:item_properties) {
      str("CH") >> variable_length_value.as(:item_properties) >> pipe
    }

    rule(:item_properties_ok) {
      any_valid.as(:numerical_bool).as(:item_properties_ok)
    }

    rule(:items) {
      (
        hold_items.repeat(1).as(:hold_items) |
        overdue_items.repeat(1).as(:overdue_items) |
        charged_items.repeat(1).as(:charged_items) |
        fine_items.repeat(1).as(:fine_items) |
        recall_items.repeat(1).as(:recall_items) |
        unavailable_hold_items.repeat(1).as(:unavailable_hold_items)
      ).as(:items)
    }

    rule(:language) {
      digit.repeat(3,3).as(:int).as(:language)
    }

    rule(:library_name) {
      str("AM") >> variable_length_value.as(:library_name) >> pipe
    }

    rule(:location_code) {
      str("CP") >> variable_length_value.as(:location_code) >> pipe
    }

    rule(:login_password) {
      str("CO") >> variable_length_value.as(:login_password) >> pipe
    }

    rule(:login_user_id) {
      str("CN") >> variable_length_value.as(:login_user_id) >> pipe
    }

    rule(:magnetic_media) {
      nillable_bool.as(:magnetic_media)
    }

    rule(:max_print_width) {
      digit.repeat(3,3).as(:int).as(:max_print_width)
    }

    rule(:media_type) {
      str("CK") >> digit.repeat(3,3).as(:int).as(:media_type) >> pipe
    }

    rule(:nb_due_date) {
      (timestamp | space.repeat(18,18).as(:nil)).as(:nb_due_date)
    }

    rule(:no_block) {
      bool.as(:no_block)
    }

    rule(:offline_ok) {
      bool.as(:offline_ok)
    }

    rule(:ok) {
      numerical_bool.as(:ok)
    }

    rule(:online_status) {
      bool.as(:online_status)
    }

    rule(:overdue_items) {
      str("AT") >> variable_length_value.as(:overdue_items) >> pipe
    }

    rule(:overdue_items_count) {
      four_digits_or_blanks.as(:overdue_items_count)
    }

    rule(:overdue_items_limit) {
      str("CA") >> digit.repeat(4,4).as(:int).as(:overdue_items_limit) >> pipe
    }

    rule(:owner) {
      str("BG") >> variable_length_value.as(:owner) >> pipe
    }

    rule(:patron_identifier) {
      str("AA") >> variable_length_value.as(:patron_identifier) >> pipe
    }

    rule(:patron_password) {
      str("AD") >> variable_length_value.as(:patron_password) >> pipe
    }

    rule(:patron_status) {
      (
        bool_with_space.as(:charge_privileges_denied) >>
        bool_with_space.as(:renewal_privileges_denied) >>
        bool_with_space.as(:recall_privileges_denied) >>
        bool_with_space.as(:hold_privileges_denied) >>
        bool_with_space.as(:card_reported_lost) >>
        bool_with_space.as(:too_many_items_charged) >>
        bool_with_space.as(:too_many_items_overdue) >>
        bool_with_space.as(:too_many_renewals) >>
        bool_with_space.as(:too_many_claims_of_items_returned) >>
        bool_with_space.as(:too_many_items_lost) >>
        bool_with_space.as(:excessive_outstanding_fines) >>
        bool_with_space.as(:excessive_outstanding_fees) >>
        bool_with_space.as(:recall_overdue) >>
        bool_with_space.as(:too_many_items_billed)
      ).as(:patron_status)
    }

    rule(:payment_accepted) {
      bool.as(:payment_accepted)
    }

    rule(:payment_type) {
      (digit >> digit).as(:int).as(:payment_type)
    }

    rule(:permanent_location) {
      str("AQ") >> variable_length_value.as(:permanent_location) >> pipe
    }

    rule(:personal_name) {
      str("AE") >> variable_length_value.as(:personal_name) >> pipe
    }

    rule(:pickup_location) {
      str("BS") >> variable_length_value.as(:pickup_location) >> pipe
    }

    rule(:print_line) {
      str("AG") >> variable_length_value.as(:print_line) >> pipe
    }

    rule(:protocol_version) {
      (digit >> str(".") >> digit >> digit).as(:str).as(:protocol_version)
    }

    rule(:pwd_algorithm) {
      any_valid.as(:str).as(:pwd_algorithm)
    }

    rule(:queue_position) {
      str("BR") >> digit.repeat.as(:int).as(:queue_position) >> pipe
    }

    rule(:recall_date) {
      str("CJ") >> timestamp.as(:recall_date) >> pipe
    }

    rule(:recall_items) {
      str("BU") >> variable_length_value.as(:recall_items) >> pipe
    }

    rule(:recall_items_count) {
      four_digits_or_blanks.as(:recall_items_count)
    }

    rule(:renewal_ok) {
      bool.as(:renewal_ok)
    }

    rule(:renewed_count) {
      digit.repeat(4,4).as(:int).as(:renewed_count)
    }

    rule(:renewed_items) {
      str("BM") >> variable_length_value.as(:renewed_items) >> pipe
    }

    rule(:resensitize) {
      bool.as(:resensitize)
    }

    rule(:retries_allowed) {
      digit.repeat(3,3).as(:int).as(:retries_allowed)
    }

    rule(:return_date) {
      timestamp.as(:return_date)
    }

    rule(:sc_renewal_policy) {
      bool.as(:sc_renewal_policy)
    }

    rule(:screen_message) {
      str("AF") >> variable_length_value.as(:screen_message) >> pipe
    }

    rule(:security_inhibit) {
      str("CI") >> bool.as(:security_inhibit) >> pipe
    }

    rule(:security_marker) {
      (digit >> digit).as(:int).as(:security_marker)
    }

    rule(:sequence_number) {
      str("AY") >> digit.as(:int).as(:sequence_number)
    }

    rule(:sort_bin) {
      str("CL") >> variable_length_value.as(:sort_bin) >> pipe
    }

    rule(:start_item) {
      str("BP") >> variable_length_value.as(:start_item) >> pipe
    }

    rule(:status_code) {
      match["012"].as(:int).as(:status_code)
    }

    rule(:status_update_ok) {
      bool.as(:status_update_ok)
    }

    rule(:summary) {
      (
        bool_with_space.as(:hold_items) >>
        bool_with_space.as(:overdue_items) >>
        bool_with_space.as(:charged_items) >>
        bool_with_space.as(:fine_items) >>
        bool_with_space.as(:recall_items) >>
        bool_with_space.as(:unavailable_holds) >>
        match["Y "].repeat(4,4)
      ).as(:summary)
    }

    rule(:supported_messages) {
      str("BX") >> variable_length_value.as(:supported_messages) >> pipe
    }

    rule(:terminal_location) {
      str("AN") >> variable_length_value.as(:terminal_location) >> pipe
    }

    rule(:terminal_password) {
      str("AC") >> variable_length_value.as(:terminal_password) >> pipe
    }

    rule(:third_party_allowed) {
      bool.as(:third_party_allowed)
    }

    rule(:timeout_period) {
      digit.repeat(3,3).as(:int).as(:timeout_period)
    }

    rule(:title_identifier) {
      str("AJ") >> variable_length_value.as(:title_identifier) >> pipe
    }

    rule(:transaction_date) {
      timestamp.as(:transaction_date)
    }

    rule(:transaction_id) {
      str("BK") >> variable_length_value.as(:transaction_id) >> pipe
    }

    rule(:uid_algorithm) {
      any_valid.as(:str).as(:uid_algorithm)
    }

    rule(:unavailable_holds_count) {
      four_digits_or_blanks.as(:unavailable_holds_count)
    }

    rule(:unavailable_hold_items) {
      str("CD") >> variable_length_value.as(:unavailable_hold_items) >> pipe
    }

    rule(:unrenewed_count) {
      digit.repeat(4,4).as(:int).as(:unrenewed_count)
    }

    rule(:unrenewed_items) {
      str("BN") >> variable_length_value.as(:unrenewed_items) >> pipe
    }

    rule(:valid_patron) {
      str("BL") >> bool.as(:valid_patron) >> pipe
    }

    rule(:valid_patron_password) {
      str("CQ") >> bool.as(:valid_patron_password) >> pipe
    }
  end
end
