B16 = "%016b"
def checksum(msg)
  # Add each character as an unsigned binary number
  sum = msg.codepoints.sum

  # Take the lower 16 bits of the total
  p sum16b = sprintf(B16, sum)[-16,16]
  sum16i = sum16b.to_i(2)

  # Perform a 2's complement
  #
  # First we take a 1's complement
  comp1_i = ~sum16i
  # Ruby interprets this as a negative int, but we want the actual inverted bits
  p comp1_16b = sprintf(B16, comp1_i).sub("..", "11")
  comp1_16i = comp1_16b.to_i(2)
  # Add 1 to make it a 2'a complement
  comp2_16i = comp1_16i + 1

  p sprintf(B16, comp2_16i)
  # The checksum field is the result represented by four hex digits
  p checksum = sprintf("%04X", comp2_16i)

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
