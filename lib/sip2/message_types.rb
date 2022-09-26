module Sip2
  MESSAGE_TYPES = {

    "01" => {
      name: "Block Patron",
      symbol: :block_patron
    },
    "09" => {
      name: "Checkin",
      symbol: :checkin
    },
    "10" => {
      name: "Checkin Response",
      symbol: :checkin_response
    },
    "11" => {
      name: "Checkout",
      symbol: :checkout
    },
    "12" => {
      name: "Checkout Response",
      symbol: :checkout_response
    },
    "15" => {
      name: "Hold",
      symbol: :hold
    },
    "16" => {
      name: "Hold Response",
      symbol: :hold_response
    },
    "17" => {
      name: "Item Information",
      symbol: :item_information
    },
    "18" => {
      name: "Item Information Response",
      symbol: :item_information_response
    },
    "19" => {
      name: "Item Status Update",
      symbol: :item_status_update
    },
    "20" => {
      name: "Item Status Update Response",
      symbol: :item_status_update_response
    },
    "23" => {
      name: "Patron Status Request",
      symbol: :patron_status_request
    },
    "24" => {
      name: "Patron Status Response",
      symbol: :patron_status_response
    },
    "25" => {
      name: "Patron Enable",
      symbol: :patron_enable
    },
    "26" => {
      name: "Patron Enable Response",
      symbol: :patron_enable_response
    },
    "29" => {
      name: "Renew",
      symbol: :renew
    },
    "30" => {
      name: "Renew Response",
      symbol: :renew_response
    },
    "35" => {
      name: "End Patron Session",
      symbol: :end_patron_session
    },
    "36" => {
      name: "End Session Response",
      symbol: :end_session_response
    },
    "37" => {
      name: "Fee Paid",
      symbol: :fee_paid
    },
    "38" => {
      name: "Fee Paid Response",
      symbol: :fee_paid_response
    },
    "63" => {
      name: "Patron Information",
      symbol: :patron_information
    },
    "64" => {
      name: "Patron Information Response",
      symbol: :patron_information_response
    },
    "65" => {
      name: "Renew All",
      symbol: :renew_all
    },
    "66" => {
      name: "Renew All Response",
      symbol: :renew_all_response
    },
    "93" => {
      name: "Login",
      symbol: :login
    },
    "94" => {
      name: "Login Response",
      symbol: :login_response
    },
    "96" => {
      name: "Request SC Resend",
      symbol: :request_sc_resend
    },
    "97" => {
      name: "Request ACS Resend",
      symbol: :request_acs_resend
    },
    "98" => {
      name: "ACS Status",
      symbol: :acs_status
    },
    "99" => {
      name: "SC Status",
      symbol: :sc_status
    },

  }
end
