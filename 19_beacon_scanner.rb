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

def match(as, bs)
  h = Hash.new { |h, k| h[k] = [] }
  for oa in as
    for a in as
      h[vsub(a, oa)] << oa
    end
  end
  for rotation in ROTATIONS
    bs_prime = bs.map(&rotation)
    for ob in bs_prime
      counts = Hash.new(0)
      for b in bs_prime
        for oa in h[vsub(b, ob)]
          counts[oa] += 1
        end
      end
      oa, _ = counts.find { |_, n| n >= 12 }
      if oa
        origin = vsub(oa, ob)
        return origin, bs_prime.map { |b| vadd(origin, b) }
      end
    end
  end
  nil
end

def merge(scanners)
  queue = [scanners.first]
  remaining = scanners.drop(1)
  origins = [[0,0,0]]
  result = []
  until queue.empty?
    as = queue.shift
    next_remaining = []
    for bs in remaining
      if pair = match(as, bs)
        origins << pair[0]
        result |= pair[1]
        queue << pair[1]
      else
        next_remaining << bs
      end
    end
    remaining = next_remaining
    p [queue.size, remaining.size]
  end
  return result, origins
end

scanners = parse_scanners(get_input(19))
result, origins = merge(scanners)
puts result.size
puts origins.combination(2).map { |a, b| distance(a, b) }.max
