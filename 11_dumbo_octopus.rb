require_relative 'framework'

def parse_grid(input)
  input.lines.map { |line| line.chomp.chars.map(&:to_i) }
end

def tick(grid)
  for y in 0 ... grid.size
    for x in 0 ... grid[y].size
      inc(grid, x, y)
    end
  end
  flashes = 0
  for y in 0 ... grid.size
    for x in 0 ... grid[y].size
      if grid[y][x] >= 10
        grid[y][x] = 0
        flashes += 1
      end
    end
  end
  flashes
end

def inc(grid, x, y)
  grid[y][x] += 1
  if grid[y][x] == 10 # only fire on first increment to 10
    for ny in [y - 1, 0].max .. [y + 1, grid.size - 1].min
      for nx in [x - 1, 0].max .. [x + 1, grid[y].size - 1].min
        next if nx == x && ny == y
        inc(grid, nx, ny)
      end
    end
  end
end

def part1(input)
  grid = parse_grid(input)
  flashes = 0
  100.times { flashes += tick(grid) }
  flashes
end

def part2(input)
  grid = parse_grid(input)
  size = grid.inject(0) { |sum, row| sum + row.size }
  ticks = 0
  loop do
    flashes = tick(grid)
    ticks += 1
    return ticks if flashes == size
  end
end

input = get_input(11)
puts "Part 1: #{part1(input)}"
puts "Part 2: #{part2(input)}"
