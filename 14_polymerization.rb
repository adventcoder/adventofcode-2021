require_relative 'framework'

def parse_polymer(chunk)
  pairs = Hash.new(0)
  chars = chunk.chomp.split('')
  chars.each_cons(2) do |a, b|
    pairs[a + b] += 1
  end
  [pairs, chars.last]
end

def parse_rules(chunk)
  rules = {}
  chunk.each_line do |line|
    pair, c = line.split('->').map(&:strip)
    rules[pair] = [pair[0] + c, c + pair[1]]
  end
  rules
end

def step(polymer, rules)
  pairs, last_char = polymer
  new_pairs = Hash.new(0)
  for pair, n in pairs
    for new_pair in rules[pair]
      new_pairs[new_pair] += n
    end
  end
  [new_pairs, last_char]
end

def char_counts(polymer)
  pairs, last_char = polymer
  counts = Hash.new(0)
  for pair, n in pairs
    counts[pair[0]] += n
  end
  counts[last_char] += 1
  counts
end

def answer(polymer)
  a, b = char_counts(polymer).each_value.minmax
  b - a
end

chunks = get_input(14).split("\n\n")
polymer = parse_polymer(chunks[0])
rules = parse_rules(chunks[1])

10.times { polymer = step(polymer, rules) }
puts "Part 1: #{answer(polymer)}"

30.times { polymer = step(polymer, rules) }
puts "Part 2: #{answer(polymer)}"
