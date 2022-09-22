require 'parslet'
require 'parslet/convenience'

module Sip2
  module Meta

    class MessagesTransformer < Parslet::Transform

      rule(field_name_part: simple(:x)) { String(x).gsub(%r|[/-]|,"") }

      rule(field_name: sequence(:x)) { x.join("_").gsub(/_+/, "_") }

    end

  end
end
