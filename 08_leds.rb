require_relative 'framework'

def get_freqs(leds)
  freqs = Hash.new(0)
  for led in leds
    led.each_char { |c| freqs[c] += 1 }
  end
  freqs
end

def freq_sum(led, freqs)
  led.each_char.inject(0) { |sum, c| sum + freqs[c] }
end

def part1(entries)
  sum = 0
  for _, outputs in entries
    sum += outputs.count { |led| [2, 3, 4, 7].include?(led.size) }
  end
  sum
end

def part2(entries)
  example_leds = 'abcefg cf acdeg acdfg bcdf  abdfg abdefg acf abcdefg abcdfg'.split
  example_freqs = get_freqs(example_leds)
  sum_to_digit = {}
  example_leds.each_with_index do |led, digit|
    sum_to_digit[freq_sum(led, example_freqs)] = digit
  end
  sum = 0
  for entry_leds, outputs in entries
    entry_freqs = get_freqs(entry_leds)
    digits = outputs.map { |led| sum_to_digit[freq_sum(led, entry_freqs)] }
    sum += digits.inject(0) { |n, d| n * 10 + d }
  end
  sum
end

input = get_input(8)
entries = input.lines.map { |line| line.split('|').map(&:split) }
puts "Part 1: #{part1(entries)}"
puts "Part 2: #{part2(entries)}"
