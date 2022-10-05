def checksum(msg)
  # Add each character as an unsigned binary number
  sum = msg.codepoints.sum

  # Take the lower 16 bits of the total
  sum16 = sprintf("%04x", sum)[-4,4].to_i(16)

  # Perform a 2's complement
  comp2 = (sum16 ^ 0xFFFF) + 1

  # The checksum field is the result represented by four hex digits
  sprintf("%04X", comp2)
end

def test(msgs)
  test_cases = msgs.map { |m|
    {
      msg: m[0..-5],
      expected: m[-4..-1],
    }
  }

  test_cases.each do |tc|
    msg,expected = tc.values_at(:msg, :expected)
    p msg
    actual = checksum(msg)
    puts sprintf("%s == %s #=> %s", expected, actual, (expected == actual).to_s)
  end
end

msgs = ARGF.readlines.map(&:chomp)
test(msgs)
