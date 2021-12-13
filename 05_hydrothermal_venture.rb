require_relative 'framework'

class Line
  def initialize(str)
    @x1, @y1, @x2, @y2 = str.split('->').flat_map { |str| str.split(',', 2) }.map(&:to_i)
  end

  def straight?
    @x1 == @x2 || @y1 == @y2
  end

  def each_point
    dx = @x2 <=> @x1
    dy = @y2 <=> @y1
    x = @x1
    y = @y1
    until x == @x2 && y == @y2
      yield x, y
      x += dx
      y += dy
    end
    yield x, y
  end
end

lines = get_input(5).lines.map { |line| Line.new(line.chomp) }
grid = Hash.new(0)

for line in lines.select(&:straight?)
  line.each_point { |x, y| grid[[x, y]] += 1 }
end
puts "Part 1: #{grid.count { |p, n| n >= 2 }}"

for line in lines.reject(&:straight?)
  line.each_point { |x, y| grid[[x, y]] += 1 }
end
puts "Part 2: #{grid.count { |p, n| n >= 2 }}"
