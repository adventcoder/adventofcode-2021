require_relative 'framework'

ROTATIONS = [
  lambda { |(x, y, z)| [ x,  y,  z] },
  lambda { |(x, y, z)| [ x, -y, -z] },
  lambda { |(x, y, z)| [ x,  z, -y] },
  lambda { |(x, y, z)| [ x, -z,  y] },
  lambda { |(x, y, z)| [-x,  y, -z] },
  lambda { |(x, y, z)| [-x, -y,  z] },
  lambda { |(x, y, z)| [-x,  z,  y] },
  lambda { |(x, y, z)| [-x, -z, -y] },
  lambda { |(x, y, z)| [ y,  x, -z] },
  lambda { |(x, y, z)| [ y, -x,  z] },
  lambda { |(x, y, z)| [ y,  z,  x] },
  lambda { |(x, y, z)| [ y, -z, -x] },
  lambda { |(x, y, z)| [-y,  x,  z] },
  lambda { |(x, y, z)| [-y, -x, -z] },
  lambda { |(x, y, z)| [-y,  z, -x] },
  lambda { |(x, y, z)| [-y, -z,  x] },
  lambda { |(x, y, z)| [ z,  x,  y] },
  lambda { |(x, y, z)| [ z, -x, -y] },
  lambda { |(x, y, z)| [ z,  y, -x] },
  lambda { |(x, y, z)| [ z, -y,  x] },
  lambda { |(x, y, z)| [-z,  x, -y] },
  lambda { |(x, y, z)| [-z, -x,  y] },
  lambda { |(x, y, z)| [-z,  y,  z] },
  lambda { |(x, y, z)| [-z, -y, -x] }
]

def parse_scanners(input)
  input.split("\n\n").map do |chunk|
    chunk.split("\n").drop(1).map do |line|
      line.split(',').map(&:to_i)
    end
  end
end

def vadd(a, b)
  Array.new(3) { |i| a[i] + b[i] }
end

def vsub(a, b)
  Array.new(3) { |i| a[i] - b[i] }
end

def distance(a, b)
  3.times.inject(0) { |sum, i| sum + (a[i] - b[i]).abs }
end

# Returns the location for the bs scanner relative to a if it can be determined or nil otherwise.
# This is super slow btw.
def overlap(as, bs)
  for rotation in ROTATIONS
    bs_prime = bs.map(&rotation)
    for oa in as
      a_deltas = as.map { |a| vsub(a, oa) }
      for ob in bs_prime
        b_deltas = bs_prime.map { |b| vsub(b, ob) }
        if (a_deltas & b_deltas).size >= 12
          origin = vsub(oa, ob)
          return origin, bs_prime.map { |b| vadd(origin, b) }
        end
      end
    end
  end
  nil
end

scanners = parse_scanners(get_input(19))
mapped_scanners = [scanners.first]
remaining_scanners = scanners.drop(1)
origins = [[0,0,0]]
for as in mapped_scanners
  next_remaining_scanners = []
  for bs in remaining_scanners
    if pair = overlap(as, bs)
      origins << pair[0]
      mapped_scanners << pair[1]
    else
      next_remaining_scanners << bs
    end
  end
  remaining_scanners = next_remaining_scanners
  p [mapped_scanners.size, remaining_scanners.size]
end
puts mapped_scanners.inject([], &:|).size
puts origins.combination(2).map { |a, b| distance(a, b) }.max
