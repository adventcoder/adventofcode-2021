require_relative 'framework'

def explode_ignore_carry(node)
  if result = explode(node, 0)
    return result[1]
  end
  nil
end

def explode(node, depth = 0)
  case node
  when Array
    if depth >= 4
      return node[0], 0, node[1]
    else
      if result = explode(node[0], depth + 1)
        left_carry, new_left, right_carry = result
        return left_carry, [new_left, add_left(node[1], right_carry)], nil
      end
      if result = explode(node[1], depth + 1)
        left_carry, new_right, right_carry = result
        return nil, [add_right(node[0], left_carry), new_right], right_carry
      end
    end
  end
  nil
end

def add_left(node, num)
  return node if num.nil?
  if node.is_a?(Array)
    [add_left(node[0], num), node[1]]
  else
    node + num
  end
end

def add_right(node, num)
  return node if num.nil?
  if node.is_a?(Array)
    [node[0], add_right(node[1], num)]
  else
    node + num
  end
end

def split(node, parent = nil)
  case node
  when Array
    if new_left = split(node[0])
      return [new_left, node[1]]
    end
    if new_right = split(node[1])
      return [node[0], new_right]
    end
  else
    if node >= 10
      return [node / 2, node - node / 2]
    end
  end
  nil
end

def reduce(num)
  while new_num = (explode_ignore_carry(num) || split(num))
    num = new_num
  end
  num
end

def add(num1, num2)
  reduce([num1, num2])
end

def magnitude(num)
  case num
  when Array
    3 * magnitude(num[0]) + 2 * magnitude(num[1])
  else
    num
  end
end

input = get_input(18)
nums = input.lines.map { |line| eval(line) }

sum = nums.inject { |sum, num| add(sum, num) }
puts "Part 1: #{magnitude(sum)}"

mags = []
for x in nums
  for y in nums
    mags << magnitude(add(x, y))
  end
end
puts "Part 2: #{mags.max}"
