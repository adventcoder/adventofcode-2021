require_relative 'framework'
require_relative 'utils'

def parse_grid(input)
  input.lines.map { |line| line.chomp.chars.map(&:to_i) }
end

def embiggen(grid)
  new_rows = []
  5.times do |i|
    new_cols = []
    5.times do |j|
      new_cols.concat(increase_cost(grid, i + j).transpose)
    end
    new_rows.concat(new_cols.transpose)
  end
  new_rows
end

def increase_cost(grid, n)
  grid.map { |row| row.map { |cost| (cost + n - 1) % 9 + 1 } }
end

def find_path(grid)
  cost = Array.new(grid.size) { |y| Array.new(grid[y].size, Float::INFINITY) }
  closed = Array.new(grid.size) { |y| Array.new(grid[y].size, false) }
  open = Heap.new { |a, b| a[2] <=> b[2] }
  cost[0][0] = 0
  open << [0, 0, 0]
  until open.empty?
    x, y, _ = open.pop
    next if closed[y][x]
    closed[y][x] = true
    if y == grid.size - 1 && x == grid[y].size - 1
      return cost[y][x]
    else
      for x2, y2 in [[x, y - 1], [x - 1, y], [x + 1, y], [x, y + 1]]
        next unless y2 >= 0 && y2 < grid.size && x2 >= 0 && x2 < grid[y2].size
        new_cost = cost[y][x] + grid[y2][x2]
        if new_cost < cost[y2][x2]
          cost[y2][x2] = new_cost
          open << [x2, y2, new_cost]
        end
      end
    end
  end
  nil
end

grid = parse_grid(get_input(15))
puts find_path(grid)
puts find_path(embiggen(grid))
