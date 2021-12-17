require_relative 'framework'
require 'set'

# This could probably be better ...

def parse_area(str)
  str = str.split(':', 2)[1]
  pairs = {}
  for sub in str.split(',')
    lhs, rhs = sub.split('=', 2)
    pairs[lhs.strip] = rhs.split('..', 2).map(&:to_i)
  end
  pairs.values_at('x', 'y')
end

def solve_vy(t, y)
  # y = vy t - t(t-1)/2
  a = t*(t-1)/2
  return nil unless (y + a) % t == 0
  (y + a) / t
end

def solve_vx(t, x)
  a = t*(t-1)/2
  if x > 0
    if x < t*(t+1)/2
      # x = vx(vx+1)/2
      # vx = (sqrt(8 x+1) - 1)/2
      vx = (Math.sqrt(8*x+1) - 1) / 2
      return nil unless vx == vx.floor
      vx.floor
    else
      return nil unless (x + a) % t == 0
      (x + a) / t
    end
  elsif x < 0
    # This should be more or less the same as for positive x but wasn't needed for the input
    raise NotImplemented
  else
    0
  end
end

def solve(area)
  (x0, x1), (y0, y1) = area
  vels = Set.new
  for t in 1 ... [x0.abs, x1.abs].max
    for y in y0 .. y1
      next unless vy = solve_vy(t, y)
      for x in x0 .. x1
        next unless vx = solve_vx(t, x)
        vels << [vx, vy]
      end
    end
  end
  vels
end

area = parse_area(get_input(17))
vels = solve(area)
max_vy = vels.map{ |(_, vy)| vy }.max
puts "Part 1: #{max_vy * (max_vy + 1) / 2}"
puts "Part 2: #{vels.size}"
