require_relative 'framework'

def parse_paper(chunk)
  paper = Hash.new(false)
  chunk.each_line do |line|
    point = line.split(',').map(&:to_i)
    paper[point] = true
  end
  paper
end

def parse_folds(chunk)
  chunk.lines.map do |line|
    args = line.split
    pair = args[2].split('=', 2)
    ["xy".index(pair[0]), pair[1].to_i]
  end
end

def fold(paper, i, x)
  for p in paper.each_key.select { |p| p[i] > x }
    paper.delete(p)
    p[i] = 2 * x - p[i]
    paper[p] = true
  end
end

def gridify(paper)
  x0 = Float::INFINITY
  x1 = -Float::INFINITY
  y0 = Float::INFINITY
  y1 = -Float::INFINITY
  paper.each_key do |(x, y)|
    x0 = x if x < x0
    y0 = y if y < y0
    x1 = x if x > x1
    y1 = y if y > y1
  end
  grid = []
  for y in y0 .. y1
    row  = ''
    for x in x0 .. x1
      row << (paper.has_key?([x, y]) ? '#' : '.')
    end
    grid << row
  end
  grid
end

chunks = get_input(13).split("\n\n")
paper = parse_paper(chunks[0])
folds = parse_folds(chunks[1])

fold(paper, *folds[0])
puts "Part 1: #{paper.size}"

for i in 1 ... folds.size
  fold(paper, *folds[i])
end
puts "Part 2:", *gridify(paper)
