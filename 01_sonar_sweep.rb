require_relative 'framework'

depths = get_input(1).lines.map(&:to_i)

answer1 = depths.each_cons(2).count { |a, b| a < b }
puts "Part 1: #{answer1}"

answer2 = depths.each_cons(4).count { |a, b, c, d| a < d }
puts "Part 2: #{answer2}"
