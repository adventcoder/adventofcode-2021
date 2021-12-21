require_relative 'framework'

def results1(p1, p2)
  s1 = 0
  s2 = 0
  n = 0
  loop do
    d1 = n % 100 + 1
    n += 1
    d2 = n % 100 + 1
    n += 1
    d3 = n % 100 + 1
    n += 1
    p1 = (p1 - 1 + d1 + d2 + d3) % 10 + 1
    s1 += p1
    if s1 >= 1000
      return s2 * n
    end
    p1, s1, p2, s2 = p2, s2, p1, s1
  end
end

ROLLS = Hash.new(0)
for a in 1 .. 3
  for b in 1 .. 3
    for c in 1 .. 3
      ROLLS[a + b + c] += 1
    end
  end
end

def results2(p1, p2, s1 = 0, s2 = 0, memo = {})
  memo[[p1, p2, s1, s2]] ||= begin
    if s2 >= 21
      [0, 1]
    else
      total_wins1 = 0
      total_wins2 = 0
      for roll, n in ROLLS
        new_p1 = (p1 - 1 + roll) % 10 + 1
        new_s1 = s1 + new_p1
        wins2, wins1 = results2(p2, new_p1, s2, new_s1, memo)
        total_wins1 += n * wins1
        total_wins2 += n * wins2
      end
      [total_wins1, total_wins2]
    end
  end
end

input = get_input(21)
p1, p2 = input.lines.map { |line| line.split(':')[1].to_i }
puts "Part 1: #{results1(p1, p2)}"
puts "Part 2: #{results2(p1, p2).max}"
