require_relative 'framework'

def parse_graph(input)
  graph = Hash.new { |h, k| h[k] = [] }
  input.each_line do |line|
    a, b = line.chomp.split('-')
    graph[a] << b unless b == 'start'
    graph[b] << a unless a == 'start'
  end
  graph
end

def count_paths(graph, allow_double, cave = 'start', seen = Hash.new(0))
  return 1 if cave == 'end'
  if seen[cave] > 0 && cave == cave.downcase
    return 0 unless allow_double
    allow_double = false
  end
  seen[cave] += 1
  total = 0
  for next_cave in graph[cave]
    total += count_paths(graph, allow_double, next_cave, seen)
  end
  seen[cave] -= 1
  total
end

graph = parse_graph(get_input(12))
puts "Part 1: #{count_paths(graph, false)}"
puts "part 2: #{count_paths(graph, true)}"
