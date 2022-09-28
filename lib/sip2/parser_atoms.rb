require 'parslet'

module Sip2
  module ParserAtoms
    include Parslet

    rule(:digit) { match["0-9"] }
    rule(:natural) { match["1-9"] }
    rule(:zero) { str("0") } 

    rule(:hex_digit) { match["0-9A-F"] }

    rule(:space) { str(" ") }
    rule(:pipe) { str("|") }
    rule(:upper) { match["A-Z"] }

    rule(:year) { digit.repeat(4,4) }
    rule(:month) { (zero >> natural) | (str("1") >> match["012"] ) }
    rule(:day) { (zero >> natural) | (match["12"] >> digit) | (str("3") >> match["01"]) }
    rule(:zzzz) { (space | upper).repeat(4) }
    rule(:hour) { (match["01"] >> digit) | str("2") >> match["0-3"] }
    rule(:minute) { match["0-5"] >> digit }
    rule(:second) { minute }

    rule(:bool) { match["YN"].as(:bool) }
    rule(:bool_with_space) { match["Y "].as(:bool) }
    rule(:nillable_bool) { match["YNU"].as(:bool) }
    rule(:numerical_bool) { match["01"].as(:bool) }

    rule(:timestamp) {
      year.as(:int).as(:year) >> month.as(:int).as(:month) >> day.as(:int).as(:day) >>
      zzzz.as(:tz).as(:zone) >>
      hour.as(:int).as(:hour) >> minute.as(:int).as(:minute) >> second.as(:int).as(:second)
    }

    rule(:pipe) { str("|") }

    rule(:four_digits_or_blanks) {
      digit.repeat(4,4).as(:int) | space.repeat(4,4).as(:nil)
    }

    rule(:variable_length_value) {
      (pipe.absent? >> any).repeat(0,255).as(:str)
    }

  end
end
