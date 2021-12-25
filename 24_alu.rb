require_relative 'framework'

TEMPLATE = (<<-EOS).split
inp w
mul x 0
add x z
mod x 26
div z %d
add x %d
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y %d
mul y x
add z y
EOS

def parse(input)
  input.split.each_slice(TEMPLATE.size).map do |slice|
    args = []
    for a, b in slice.zip(TEMPLATE)
      case b
      when '%d'
        args << Integer(a)
      else
        raise unless a == b
      end
    end
    args
  end
end

def check(args, n)
  digits = []
  args.size.times do
    digits << n % 10
    n /= 10
  end
  z = [0]
  for q, a, b in args
    w = digits.pop
    x = z.last + a
    z.pop unless q == 1
    if x != w
      z << w + b
    end
  end
  z
end

def make_constraints(args)
  stack = []
  constraints = []
  args.each_with_index do |(q, a, b), i|
    x = stack.last
    stack.pop unless q == 1
    if !x.nil? && (x[1] + a).between?(-8, 8) && q == 26
      j, b = x
      # x + a == d[i]
      constraints << [j, i, a + b]
    else
      # x = d[i] + b
      stack << [i, b]
    end
  end
  constraints
end

def minmax(constraints)
  min = Array.new(constraints.size * 2)
  max = Array.new(constraints.size * 2)
  for i, j, c in constraints
    # d[i] + c = d[j]
    max[i] = [9 - c, 9].min
    max[j] = max[i] + c
    min[i] = [1 - c, 1].max
    min[j] = min[i] + c
  end
  [min.join, max.join]
end

a, b = minmax(make_constraints(parse(get_input(24))))
puts "Part 1: #{b}"
puts "Part 2: #{a}"
