require_relative 'spec_helper'
require_relative 'fixture_helper'

include FixtureHelper

require 'sip2'

describe Sip2 do

  # Note:
  #
  # This libraray aims to round trip all data in Sip2 messages to and from JSON
  # (or a hash representation). But since delimited fields can come in any
  # order, two Sip2 representations of the exact same data does not need to be
  # identical. This library *makes no attempt at preserving the order* but just
  # all data.
  #
  # But this makes it hard to verify that the round trip actually works. All we
  # can compare are the strings, which possibly different order of the fields.
  # And even if a Sip2 message string initially written by this library might
  # round trip identically through parse >> encode, that is an implementation
  # detail and not guaranteed.
  #
  # Since ruby doesn't consider key order for hashes when comparing for
  # equality, round trips from the hash representation through `encode >> parse`
  # *can* be verified, so this is what we specify.
  #
  # But our fixtures are Sip2 messages, so we actually round trip twice, `parse
  # >> encode >> parse`, but we only verify the last roundtrip.
  #
  describe "round trip" do
    describe "Known messages" do
      KNOWN_MESSAGES_FIXTURE_CODES.each do |code|

        describe code do

          msg = sip2_fixture(code)

          it "round trips through (encode >> parse)" do
            hsh = Sip2.parse(msg).first

            assert_equal hsh, Sip2.parse(Sip2.encode(hsh)).first
          end
        end
      end
    end

    describe "Unknown messages" do
      UNKNOWN_MESSAGES_FIXTURE_CODES.each do |code|

        describe code do

          msg = sip2_fixture(code)

          it "round trips through (encode >> parse)" do
            hsh = Sip2.parse(msg).first

            assert_equal hsh, Sip2.parse(Sip2.encode(hsh)).first
          end

        end
      end
    end

    describe "Known messages with unexpected fields" do
      MESSAGES_WITH_EXTRA_FIELDS_FIXTURE_CODES.each do |code|
        describe code do

          msg = sip2_fixture(code)

          it "round trips through (encode >> parse)" do
            hsh = Sip2.parse(msg).first

            assert_equal hsh, Sip2.parse(Sip2.encode(hsh)).first
          end

        end
      end
    end
  end
end

