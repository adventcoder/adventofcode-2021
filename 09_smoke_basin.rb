require_relative 'framework'

def parse_grid(input)
  input.lines.map { |line| line.chomp.chars.map(&:to_i) }
end

def neighbours(grid, x, y)
  [[x, y - 1], [x - 1, y], [x + 1, y], [x, y + 1]].select { |x2, y2| valid?(grid, x2, y2) }
end

def valid?(grid, x, y)
  y >= 0 && y < grid.size && x >= 0 && x < grid[y].size
end

def total_risk_level(grid)
  total = 0
  for y in 0 ... grid.size
    for x in 0 ... grid[y].size
      total += grid[y][x] + 1 if low_point?(grid, x, y)
    end
  end
  total
end

def low_point?(grid, x, y)
  neighbours(grid, x, y).all? { |(x2, y2)| grid[y][x] < grid[y2][x2] }
end

def basin_sizes(grid)
  sizes = []
  for y in 0 ... grid.size
    for x in 0 ... grid[y].size
      next if grid[y][x] == 9
      sizes << basin_size(grid, x, y)
    end
  end
  sizes
end

def basin_size(grid, x, y)
  return 0 if grid[y][x] == 9
  grid[y][x] = 9
  1 + neighbours(grid, x, y).inject(0) { |sum, (x2, y2)| sum + basin_size(grid, x2, y2) }
end

grid = parse_grid(get_input(9))
puts "part 1: #{total_risk_level(grid)}"
puts "Part 2: #{basin_sizes(grid).sort.last(3).inject(1, &:*)}"
