require_relative 'framework'

def distance1(xs, x0)
  xs.inject(0) { |sum, x| sum + (x - x0).abs }
end

def mean1(xs)
  xs.sort!
  i = xs.size / 2
  if xs.size % 2 == 0
    (xs[i] + xs[i + 1]) / 2
  else
    xs[xs.size / 2]
  end
end

def distance2(xs, x0)
  xs.inject(0) do |sum, x|
    d = (x - x0).abs
    sum + d * (d + 1) / 2
  end
end

def mean2(xs)
  #
  #  d(x) = sum(k=1->n, |xk - x| (|xk - x|+1)/2)
  #       = sum(k=1->n, (xk - x)^2 + |xk - x|)/2
  # d'(x) = sum(k=1->n, -2 (xk - x) - sgn(xk - x))/2
  #
  # sum(k=1->n, 2 (xk - x') + sgn(xk - x')) = 0
  # 2 (sum(k=1->n, xk) - n x') + sum(k=1->n, sgn(xk - x')) = 0
  # x' = avg(xk) + (count(xk>x') - count(xk<x'))/(2 n)
  #
  # x' <= avg(xk) + (n - 0)/(2 n) = avg(xk) + 1/2
  # x' >= avg(xk) + (0 - n)/(2 n) = avg(xk) - 1/2
  #
  avg = xs.inject(0, &:+) / xs.size
  # We need to check all the integers on either side of the range to be sure we find the minimum.
  x0 = (avg - 0.5).floor
  x1 = (avg + 0.5).ceil
  (x0 .. x1).min_by { |x| distance2(xs, x) }
end

xs = get_input(7).split(',').map(&:to_i)
puts "Part 1: #{distance1(xs, mean1(xs))}"
puts "Part 2: #{distance2(xs, mean2(xs))}"
