require_relative 'framework'

input = get_input(25)
grid = input.split("\n")

steps = 0
begin
  east = []
  for y in 0 ... grid.size
    for x in 0 ... grid[y].size
      if grid[y][x] == '>' && grid[y][(x + 1) % grid[y].size] == '.'
        east << [x, y]
      end
    end
  end
  for x, y in east
    grid[y][x] = '.'
    grid[y][(x + 1) % grid[y].size] = '>'
  end
  south = []
  for y in 0 ... grid.size
    for x in 0 ... grid[y].size
      if grid[y][x] == 'v' && grid[(y + 1) % grid.size][x] == '.'
        south << [x, y]
      end
    end
  end
  for x, y in south
    grid[y][x] = '.'
    grid[(y + 1) % grid.size][x] = 'v'
  end
  steps += 1
end until east.empty? && south.empty?

puts "Part 1: #{steps}"
