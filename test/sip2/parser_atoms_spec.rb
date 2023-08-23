require_relative '../spec_helper'
require 'sip2/parser_atoms'

include Sip2

describe ParserAtoms do

  include ParserAtoms

  describe :digit do
    it "matches a single digit" do
      assert_equal "1", digit.parse("1")
    end

    it "doesn't match multiple digits" do
      assert_raises(Parslet::ParseFailed) { digit.parse("12") }
    end

    it "doesn't match other chars" do
      %w[a . _].each do |c|
        assert_raises(Parslet::ParseFailed) { digit.parse(c) }
      end
    end
  end

  describe :year do
    subject { year }

    it "matches a normal four digit year" do
      assert_equal "2023", subject.parse("2023")
    end

    it "doesn't match non-four-digit values" do
      %w[123 202E 12345].each do |c|
        assert_raises(Parslet::ParseFailed) { subject.parse(c) }
      end
    end
  end

  describe :month do
    subject { month }

    it "matches all normal two digit months" do
      ("01".."12").each do |str|
        assert_equal str, subject.parse(str)
      end
    end

    it "doesn't match months outside the 01-12 range" do
      %w[00 13].each do |c|
        assert_raises(Parslet::ParseFailed) { subject.parse(c) }
      end
    end

    it "doesn't match non-two-digit values" do
      %w[0 1 ab 123].each do |c|
        assert_raises(Parslet::ParseFailed) { subject.parse(c) }
      end
    end
  end

  describe :day do
    subject { day }

    it "matches normal two digit days" do
      %w[01 15 23 31].each do |str|
        assert_equal str, subject.parse(str)
      end
    end

    it "doesn't match days outside the 01-31 range" do
      %w[00 32 60].each do |c|
        assert_raises(Parslet::ParseFailed) { subject.parse(c) }
      end
    end

    it "doesn't match non-two-digit values" do
      %w[0 1 ab 123].each do |c|
        assert_raises(Parslet::ParseFailed) { subject.parse(c) }
      end
    end
  end

  describe :hour do
    subject { hour }

    it "matches normal two digit hours" do
      %w[00 08 15 23].each do |str|
        assert_equal str, subject.parse(str)
      end
    end

    it "doesn't match hours outside the 00-23 range" do
      %w[24 42].each do |c|
        assert_raises(Parslet::ParseFailed) { subject.parse(c) }
      end
    end

    it "doesn't match non-two-digit values" do
      %w[0 1 ab 123].each do |c|
        assert_raises(Parslet::ParseFailed) { subject.parse(c) }
      end
    end
  end

  [:second, :minute].each do |unit|
    describe unit do
      subject { self.send(unit) }

      it "matches normal two digit #{unit}s" do
        %w[00 08 32 59].each do |str|
          assert_equal str, subject.parse(str)
        end
      end

      it "doesn't match #{unit}s outside the 00-59 range" do
        %w[60 99].each do |c|
          assert_raises(Parslet::ParseFailed) { subject.parse(c) }
        end
      end

      it "doesn't match non-two-digit values" do
        %w[0 1 ab 123].each do |c|
          assert_raises(Parslet::ParseFailed) { subject.parse(c) }
        end
      end
    end
  end

  describe :zzzz do
    subject { zzzz }

    let(:allowed) { ["    ", "ZZZZ", "EST "] }
    let(:disallowed) { ["zzzz", "1234", "...."] }

    it "matches all allowed values" do
      allowed.each do |v|
        assert_equal v, subject.parse(v)
      end
    end

    it "doesn't match disallowed values" do
      disallowed.each do |v|
        assert_raises(Parslet::ParseFailed) { subject.parse(v) }
      end
    end

    it "only matches a 4 char values" do
      allowed.each do |v|
        assert_raises(Parslet::ParseFailed) { subject.parse(v + v) }
      end
    end

  end

  describe :bool do
    subject { bool }

    it "matches Y" do
      assert_equal subject.parse("Y"), { bool: "Y" }
    end

    it "matches N" do
      assert_equal subject.parse("N"), { bool: "N" }
    end

    it "doesn't match alternative bool patterns" do
      [" ", "U", "1", "0"].each do |c|
        assert_raises(Parslet::ParseFailed) { subject.parse(c) }
      end
    end

    it "only matches a single char" do
      %w[YY NN YN NY].each do |c|
        assert_raises(Parslet::ParseFailed) { subject.parse(c) }
      end
    end
  end

  describe :bool do
    subject { bool }

    let(:allowed) { ["Y", "N"] }
    let(:disallowed) { [" ", "U", "0", "1"] }

    it "matches all allowed values" do
      allowed.each do |v|
        assert_equal subject.parse(v), { bool: v }
      end
    end

    it "doesn't match disallowed values" do
      disallowed.each do |v|
        assert_raises(Parslet::ParseFailed) { subject.parse(v) }
      end
    end

    it "only matches a single char" do
      allowed.each do |v|
        assert_raises(Parslet::ParseFailed) { subject.parse(v + v) }
      end
    end

  end

  describe :bool_with_space do
    subject { bool_with_space }

    let(:allowed) { ["Y", " "] }
    let(:disallowed) { ["N", "U", "0", "1"] }

    it "matches all allowed values" do
      allowed.each do |v|
        assert_equal subject.parse(v), { bool: v }
      end
    end

    it "doesn't match disallowed values" do
      disallowed.each do |v|
        assert_raises(Parslet::ParseFailed) { subject.parse(v) }
      end
    end

    it "only matches a single char" do
      allowed.each do |v|
        assert_raises(Parslet::ParseFailed) { subject.parse(v + v) }
      end
    end

  end

  describe :nillable_bool do
    subject { nillable_bool }

    let(:allowed) { ["Y", "N", "U"] }
    let(:disallowed) { [" ", "0", "1"] }

    it "matches all allowed values" do
      allowed.each do |v|
        assert_equal subject.parse(v), { bool: v }
      end
    end

    it "doesn't match disallowed values" do
      disallowed.each do |v|
        assert_raises(Parslet::ParseFailed) { subject.parse(v) }
      end
    end

    it "only matches a single char" do
      allowed.each do |v|
        assert_raises(Parslet::ParseFailed) { subject.parse(v + v) }
      end
    end

  end

  describe :numerical_bool do
    subject { numerical_bool }

    let(:allowed) { ["0", "1"] }
    let(:disallowed) { ["Y", "N", "U", " "] }

    it "matches all allowed values" do
      allowed.each do |v|
        assert_equal subject.parse(v), { bool: v }
      end
    end

    it "doesn't match disallowed values" do
      disallowed.each do |v|
        assert_raises(Parslet::ParseFailed) { subject.parse(v) }
      end
    end

    it "only matches a single char" do
      allowed.each do |v|
        assert_raises(Parslet::ParseFailed) { subject.parse(v + v) }
      end
    end

  end


  describe :timestamp do
    subject { timestamp }

    it "matches timestamps with valid dates and times" do
      [
        "19700101ZZZZ000000",
        "20230823ZZZZ102930",
        "20991231    235959",
      ].each do |str|
        assert_equal subject.parse(str).keys, [:year, :month, :day, :zone, :hour, :minute, :second]
      end
    end

    it "doesn't match timestamp with *clearly* invalid dates or times" do
      [
        "AB010203    040506",
        "20019903    040506",
        "20010299    040506",
        "20010203    990506",
        "20010203    049906",
        "20010203    040599",
      ].each do |str|
        assert_raises(Parslet::ParseFailed) { subject.parse(str) }
      end
    end

    it "doesn't match non-18-char values" do
      [
        "19700101ZZZ000000",
        "20230823ZZZZZ102930",
        "20991231235959",
      ].each do |str|
        assert_raises(Parslet::ParseFailed) { subject.parse(str) }
      end
    end
  end

  describe :variable_length_value do
    subject { variable_length_value }

    it "requires a trailing pipe char" do
      assert_raises(Parslet::ParseFailed) { subject.parse("foo") }
    end

    it "captures the value without the trailing pipe char" do
      assert_equal({str: "foo"}, subject.parse("foo|"))
    end

    it "matches any kind of str in lengths from 1 to 255" do
      ["a", "A", "Å", "1", ".", " "].product([1, 20, 255]).each do |chr, length|
        value = (chr * length)
        assert_equal({str: value}, subject.parse(value + "|"))
      end
    end

    it "matches a single pipe (empty value)" do
      assert_equal({str: []}, subject.parse("|"))
    end

    it "doesn't match strings longer than 255" do
      assert_raises(Parslet::ParseFailed) { subject.parse("A" * 256 + "|") }
    end

    it "doesn't allow a pipe char in the data" do
      assert_raises(Parslet::ParseFailed) { subject.parse("||") }
    end

  end

end
