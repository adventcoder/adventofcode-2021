require_relative 'framework'

def parse(input)
  chunks = input.split("\n\n")
  algo = chunks[0].chars.map { |c| c == '.' ? 0 : 1 }
  image = Hash.new(0)
  chunks[1].lines.each_with_index do |line, y|
    line.chomp.chars.each_with_index do |c, x|
      image[[x, y]] = 1 unless c == '.'
    end
  end
  return algo, image
end

def tick(image, algo)
  # probably should use an array for this, but wrote it with a hash originally
  # and don't care enough to change it.
  new_image = Hash.new(1 - image.default)
  min_x = Float::INFINITY
  min_y = Float::INFINITY
  max_x = -Float::INFINITY
  max_y = -Float::INFINITY
  image.each_key do |(x, y)|
    min_x = x if x < min_x
    min_y = y if y < min_y
    max_x = x if x > max_x
    max_y = y if y > max_y
  end
  for y in (min_y - 1) .. (max_y + 1)
    for x in (min_x - 1) .. (max_x + 1)
      new_image[[x, y]] = lookup(algo, image, x, y)
    end
  end
  new_image.delete_if { |k, v| v == new_image.default }
end

def lookup(algo, image, x, y)
  i = 0
  for dy in -1 .. 1
    for dx in -1 .. 1
      i = (i << 1) | image[[x + dx, y + dy]]
    end
  end
  algo[i]
end

algo, image = parse(get_input(20))
2.times { image = tick(image, algo) }
puts "Part 1: #{image.size}"
48.times { image = tick(image, algo) }
puts "Part 2: #{image.size}"
