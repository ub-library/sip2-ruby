require_relative 'spec_helper'
require_relative 'fixture_helper'

include FixtureHelper

require 'sip2'
require 'sip2/message'

describe Sip2 do

  # Note:
  #
  # The libraray aims to round trip all data in Sip2 messages to and from JSON.
  # But the some the order of some delimited fields might differ after a
  # roundtrip Sip2 -> JSON -> Sip2. This is OK, since the order of the delimited
  # fields are not specified, and this library makes no attempt at preserving
  # the order. But it makes it hard to verify that the round trip preserves all
  # data since all we have to compare are the strings. And even if a Sip2
  # message string written by this library might round trip identically through
  # the hash representatino and back to string, that is an implementation detail
  # and not something we should specify.
  #
  # Since ruby doesn't consider key order for hashes on comparison, round trips
  # from a hash representation to string and back to the hash representation
  # again can be verified even if the order of fields might differ, so this is
  # what we specify. But our fixtures are sip2 messages, so we actually
  # round trip twice: String -> Hash -> String -> Hash
  #
  describe "round trip" do describe "Known messages" do
    KNOWN_MESSAGES_FIXTURE_CODES.each do |code|

        describe code do

          msg = sip2_fixture(code)

          it "round trips the message from hash -> to_s -> hash" do
            hsh1 = Sip2.parse(msg).first
            msg2 = Sip2::Message.from_hash(hsh1).to_s
            hsh2 = Sip2.parse(msg2).first

            assert_equal hsh1, hsh2
          end
        end
      end
    end

    describe "Unknown messages" do
      UNKNOWN_MESSAGES_FIXTURE_CODES.each do |code|

        describe code do

          msg = sip2_fixture(code)

          it "round trips the message from hash -> to_s -> hash" do
            hsh1 = Sip2.parse(msg).first
            msg2 = Sip2::Message.from_hash(hsh1).to_s
            hsh2 = Sip2.parse(msg2).first

            assert_equal hsh1, hsh2
          end
        end
      end
    end
  end
end

