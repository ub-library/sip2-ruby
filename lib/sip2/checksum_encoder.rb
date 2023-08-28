module Sip2
  module ChecksumEncoder

    def self.[](name)
      const_get(name.to_s.upcase)
    end

    ALMA = ->(str) { str.encode(Encoding::ASCII, undef: :replace) }
    IDENTITY = ->(x) { x }
  end
end
