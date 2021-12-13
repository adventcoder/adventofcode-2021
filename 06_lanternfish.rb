require_relative 'framework'

def tick(state, n)
  counts = Array.new(9, 0)
  for i in state
    counts[i] += 1
  end
  n.times do
    counts.rotate!
    counts[6] += counts[8]
  end
  counts.inject(0, &:+)
end

state = get_input(6).split(',').map(&:to_i)
puts "Part 1: #{tick(state, 80)}"
puts "Part 2: #{tick(state, 256)}"
