require 'parslet'
require 'parslet/convenience'

module Sip2
  module Meta

    class MessagesTransformer < Parslet::Transform

      rule(str: simple(:x)) { String(x) }

      rule(str: sequence(:x)) { x.empty? ? "" : x }

      rule(sym: simple(:x)) {
        String(x).downcase.gsub(%r"[-/]", "").gsub(/ +/, "_").to_sym
      }

      rule(sym: sequence(:x)) {
        x.join("_").downcase.gsub(%r"[-/]", "").gsub(/ +/, "_").gsub(/_+/, "_")
      }



    end

  end
end
