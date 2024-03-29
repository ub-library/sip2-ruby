require_relative 'spec_helper'
require_relative 'fixture_helper'

include FixtureHelper

require 'sip2'

describe Sip2 do

  describe "::parse" do
    describe "Known messages" do
      KNOWN_MESSAGES_FIXTURE_CODES.each do |code|

        describe code do

          msg = sip2_fixture(code)

          it "accepts the message" do
            assert_kind_of Array, Sip2.parse(msg)
            assert_kind_of Hash, Sip2.parse(msg).first
          end

          it "sets :message_code to the message code" do
            assert_equal code, Sip2.parse(msg).first[:message_code]
          end

          it "set :message_name" do
            assert_kind_of String, Sip2.parse(msg).first[:message_name]
          end
        end
      end
    end

    describe "Unknown message" do
      UNKNOWN_MESSAGES_FIXTURE_CODES.each do |code|

        describe code do

          msg = sip2_fixture(code)

          it "accepts the message" do
            assert_kind_of Array, Sip2.parse(msg)
            assert_kind_of Hash, Sip2.parse(msg).first
          end

          it "sets :message_code to the message code" do
            assert_equal code, Sip2.parse(msg).first[:message_code]
          end

          it "sets :message_name to 'Unknown Message'" do
            assert_equal "Unknown Message", Sip2.parse(msg).first[:message_name]
          end

          it "sets :message_data to what's between the code and the terminator" do
            expected = msg.sub(/^#{Regexp.escape(code)}/, "").chomp
            assert_equal(expected, Sip2.parse(msg).first[:message_data])
          end
        end
      end
    end

    describe "Invalid message" do
      it "does not accept invalid message identifiers" do
        ["", "X", "!Y", "!Yfoo"].each do |msg|
          assert_raises(Parslet::ParseFailed) {
            Sip2.parse(sprintf("%s\r", msg))
          }
        end
      end

      it "does not acceptg valid message identifiers with invalid data" do
        ["98", "99abc"].each do |msg|
          assert_raises(Parslet::ParseFailed) {
            Sip2.parse(sprintf("%s\r", msg))
          }
        end
      end

      it "requires the message terminator for both known and unknown messages" do
        ["XXfoo", "9900302.00"].each do |msg|
          assert_kind_of Array, Sip2.parse(sprintf("%s\r", msg))
          assert_raises(Parslet::ParseFailed) {
            Sip2.parse(sprintf("%s", msg))
          }
        end
      end
    end

    describe "multiple messages" do
      let(:messages) {
        [
          "9900302.00\r",
          "XXfoo\r",
        ]
      }

      it "reads multiple messages into an array of hashes" do
        result = Sip2.parse(messages.join)

        assert_kind_of Array, result
        assert_kind_of Hash, result.first
        assert_kind_of Hash, result.last
      end

      it "allows for an extra newline character (lf) between messages" do
        result = Sip2.parse(messages.join("\n"))

        assert_kind_of Array, result
        assert_kind_of Hash, result.first
        assert_kind_of Hash, result.last
      end
    end

    describe "Messages with unexpected fields" do
      let(:messages) {
        [
          "9900302.00XXSomeExtraValue|\r",
        ]
      }

      it "reads a single unexpected field into an array" do
        result = Sip2.parse("9900302.00XXSome Unexpected Value|\r")

        assert_equal(
          [{ code: "XX", value: "Some Unexpected Value" }],
          result.first[:unexpected_fields]
        )
      end

      it "reads multiple unexpected fields into an array" do
        result = Sip2.parse("9900302.00XXSome Unexpected Value|ZZAnother Unexpected Value|\r")

        assert_equal(
          [
            { code: "XX", value: "Some Unexpected Value" },
            { code: "ZZ", value: "Another Unexpected Value" },
          ],
          result.first[:unexpected_fields]
        )
      end

    end
  end 

end
