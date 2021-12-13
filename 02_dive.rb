require_relative 'framework'

input = get_input(2)

x = 0
y = 0
dy = 0
input.each_line do |line|
  args = line.split
  n = args[1].to_i
  case args[0]
  when 'forward'
    x += n
    y += n * dy
  when 'up'
    dy -= n
  when 'down'
    dy += n
  end
end

puts "Part 1: #{x * dy}"
puts "Part 2: #{x * y}"
