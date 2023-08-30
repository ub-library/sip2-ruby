module FixtureHelper

  FIXTURE_DIR = File.join(__dir__, "fixtures")

  KNOWN_MESSAGES_FIXTURE_CODES = %w[
    09
    10
    17
    18
    98
    99
  ]

  UNKNOWN_MESSAGES_FIXTURE_CODES = %w[
    XX
  ]

  MESSAGES_WITH_EXTRA_FIELDS_FIXTURE_CODES = %w[
    98-with-unexpected
    99-with-unexpected
  ]

  def sip2_fixture_path(code)
    File.join(FIXTURE_DIR, "#{code}.sip2")
  end

  def sip2_fixture(code)
    File.read(sip2_fixture_path(code))
  end

end
