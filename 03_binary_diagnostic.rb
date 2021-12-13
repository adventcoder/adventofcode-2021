require_relative 'framework'

def mcb(nums, i)
  count = nums.count { |num| num[i].to_i == 1 }
  count >= nums.size - count ? 1 : 0
end

def lcb(nums, i)
  1 - mcb(nums, i)
end

def rating1(nums, bit_criteria)
  nums[0].size.times.map { |i| bit_criteria.call(nums, i) }.join.to_i(2)
end

def rating2(nums, bit_criteria)
  i = 0
  while nums.size > 1
    b = bit_criteria.call(nums, i)
    nums = nums.select { |num| num[i].to_i == b }
    i += 1
  end
  nums.empty? ? nil : nums[0].to_i(2)
end

nums = get_input(3).lines.map(&:chomp)

gamma_rate = rating1(nums, method(:mcb))
epsilon_rate = rating1(nums, method(:lcb))
puts "Part 1: #{gamma_rate * epsilon_rate}"

o2_rate = rating2(nums, method(:mcb))
co2_rate = rating2(nums, method(:lcb))
puts "Part 2: #{o2_rate * co2_rate}"
