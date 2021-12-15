require_relative 'framework'

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

def neighbours(pos)
  x, y = pos
  [[x, y - 1], [x - 1, y], [x + 1, y], [x, y + 1]]
end

def valid?(grid, pos)
  x, y = pos
  return y >= 0 && y < grid.size && x >= 0 && x < grid[y].size
end

def find_path(grid)
  closed = {}
  open = {}
  open[[0, 0]] = 0
  until open.empty?
    pos, cost = open.min { |a, b| a[1] <=> b[1] }
    open.delete(pos)
    closed[pos] = cost
    if pos[1] == grid.size - 1 && pos[0] == grid[pos[1]].size - 1
      return cost
    else
      for n in neighbours(pos)
        next unless valid?(grid, n)
        next if closed.include?(n)
        new_cost = cost + grid[n[1]][n[0]]
        next if open.include?(n) && open[n] <= new_cost
        open[n] = new_cost
      end
    end
  end
  nil
end

grid = parse_grid(get_input(15))
puts find_path(grid)
puts find_path(embiggen(grid))
