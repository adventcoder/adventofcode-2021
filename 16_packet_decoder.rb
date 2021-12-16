require_relative 'framework'
require 'stringio'

def expand(str)
  str.chars.map { |c| c.to_i(16).to_s(2).rjust(4, '0') }.join
end

def read_packet(io)
  version = io.read(3).to_i(2)
  type = io.read(3).to_i(2)
  if type == 4
    num = 0
    while io.read(1).to_i(2) == 1
      num = (num << 4) | io.read(4).to_i(2)
    end
    num = (num << 4) | io.read(4).to_i(2)
    [version, type, num]
  else
    packets = []
    if io.read(1).to_i(2) == 0
      length = io.read(15).to_i(2)
      start_pos = io.pos
      while io.pos - start_pos < length
        packets << read_packet(io)
      end
    else
      n = io.read(11).to_i(2)
      n.times do
        packets << read_packet(io)
      end
    end
    [version, type, packets]
  end
end

def version_sum(packet)
  if packet[1] == 4
    packet[0]
  else
    packet[0] + packet[2].inject(0) { |acc, child| acc + version_sum(child) }
  end
end

def evaluate(packet)
  case packet[1]
  when 0
    packet[2].inject(0) { |acc, child| acc + evaluate(child) }
  when 1
    packet[2].inject(1) { |acc, child| acc * evaluate(child) }
  when 2
    packet[2].map { |child| evaluate(child) }.min
  when 3
    packet[2].map { |child| evaluate(child) }.max
  when 4
    packet[2]
  when 5
    evaluate(packet[2][0]) > evaluate(packet[2][1]) ? 1 : 0
  when 6
    evaluate(packet[2][0]) < evaluate(packet[2][1]) ? 1 : 0
  when 7
    evaluate(packet[2][0]) == evaluate(packet[2][1]) ? 1 : 0
  else
    nil
  end
end

io = StringIO.new(expand(get_input(16).chomp))
packet = read_packet(io)
puts "Part 1: #{version_sum(packet)}"
puts "Part 2: #{evaluate(packet)}"
