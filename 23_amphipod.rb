require_relative 'framework'
require_relative 'utils'
require 'set'

ROOM_XS = { 'A' => 3, 'B' => 5, 'C' => 7, 'D' => 9 }
ENERGY = { 'A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000 }

def solve(start)
  seen = Set.new
  heap = Heap.new { |a, b| a[0] <=> b[0] }
  heap << [0, start]
  until heap.empty?
    cost, grid = heap.pop
    return cost if solved?(grid)
    next unless seen.add?(grid)
    each_move(grid) do |x0, y0, x1, y1|
      heap << move(cost, grid, x0, y0, x1, y1)
    end
  end
  nil
end

def solved?(grid)
  room_ys = 2 ... grid.size - 1
  for c, x in ROOM_XS
    for y in room_ys
      return false unless grid[y][x] == c
    end
  end
  true
end

def move(cost, grid, x0, y0, x1, y1)
  new_cost = cost + ((x1 - x0).abs + (y1 - y0).abs) * ENERGY[grid[y0][x0]]
  new_grid = grid.dup
  new_grid[y1] = new_grid[y1].dup
  new_grid[y1][x1] = grid[y0][x0]
  new_grid[y0] = new_grid[y0].dup
  new_grid[y0][x0] = '.'
  [new_cost, new_grid]
end

def each_move(grid)
  for room_c, room_x in ROOM_XS
    if room_y = source_room_y(grid, room_x, room_c)
      each_target_hall_x(grid, room_x) do |hall_x|
        yield room_x, room_y, hall_x, 1
      end
    end
  end
  for hall_x in 1 ... grid[1].size - 1
    next if grid[1][hall_x] == '.'
    if room_xy = target_room_xy(grid, hall_x)
      yield hall_x, 1, *room_xy
    end
  end
end

def source_room_y(grid, x, c)
  room_ys = 2 ... grid.size - 1
  if room_ys.any? { |y| grid[y][x] != '.' && grid[y][x] != c }
    return room_ys.find { |y| grid[y][x] != '.' }
  end
  nil
end

def each_target_hall_x(grid, x)
  (x - 1).downto(1) do |x|
    next if ROOM_XS.has_value?(x)
    break if grid[1][x] != '.'
    yield x
  end
  (x + 1).upto(grid[1].size - 1) do |x|
    next if ROOM_XS.has_value?(x)
    break if grid[1][x] != '.'
    yield x
  end
end

def target_room_xy(grid, x)
  room_x = ROOM_XS[grid[1][x]]
  room_ys = 2 ... grid.size - 1
  first_y = room_ys.find { |y| grid[y][room_x] != '.' }
  if first_y.nil? || (first_y ... grid.size - 1).all? { |y| grid[y][room_x] == grid[1][x] }
    room_y = first_y.nil? ? room_ys.last - 1 : first_y - 1
    dx = room_x <=> x
    if (x + dx).step(room_x, dx).all? { |x| grid[1][x] == '.' }
      return [room_x, room_y]
    end
  end
  nil
end

grid = get_input(23).split("\n")
puts "Part 1: #{solve(grid)}"

grid.insert(3, *<<-EOS.split("\n"))
  #D#C#B#A#  
  #D#B#A#C#  
EOS
puts "Part 2: #{solve(grid)}"
