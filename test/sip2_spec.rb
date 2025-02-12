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

    describe "Messages with duplicate fields" do
      let(:base_message) { sip2_fixture("18") }

      it "combines repeatable fields into arrays" do
        # Insert print_line fields after the title field
        msg = base_message.sub(
          "|AJSome example title by Some Author|",
          "|AJSome example title by Some Author|AGFirst print line|AGSecond print line|"
        )

        result = Sip2.parse(msg).first
        assert_equal ["First print line", "Second print line"], result[:print_line]
      end

      it "keeps last value for duplicate non-repeatable fields" do
        # Insert duplicate location field after the first one
        msg = base_message.sub(
          "|APSomeLocation|",
          "|APFirstLocation|APSecondLocation|"
        )

        result = Sip2.parse(msg).first
        assert_equal "SecondLocation", result[:current_location]
      end

      it "warns about duplicate non-repeatable fields" do
        msg = base_message.sub(
          "|APSomeLocation|",
          "|APFirstLocation|APSecondLocation|"
        )

        assert_output(nil, /Overwriting duplicate field: current_location/) do
          Sip2.parse(msg)
        end
      end

      it "handles multiple types of repeatable fields in any order" do
        msg = base_message.sub(
          "|AJSome example title by Some Author|",
          "|AJSome example title by Some Author|" \
            "AGFirst print line|AFFirst screen msg|" \
            "AFSecond screen msg|AGSecond print line|"  # Interspersed order
        )

        result = Sip2.parse(msg).first
        assert_equal ["First print line", "Second print line"], result[:print_line]
        assert_equal ["First screen msg", "Second screen msg"], result[:screen_message]
      end
    end
  end

end
