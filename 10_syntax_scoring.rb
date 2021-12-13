require_relative 'framework'

OPENING = '([{<'
CLOSING = ')]}>'
SCORES1 = Hash[*CLOSING.chars.zip([3, 57, 1197, 25137]).flatten]
SCORES2 = Hash[*CLOSING.chars.zip([1, 2, 3, 4]).flatten]

def calculate_scores(chunk)
  expecting = ''
  chunk.each_char do |c|
    if OPENING.include?(c)
      expecting << c.tr(OPENING, CLOSING)
    else
      if c != expecting[-1]
        return SCORES1[c], nil
      end
      expecting.chop!
    end
  end
  score2 = expecting.reverse.chars.inject(0) { |n, c| n * 5 + SCORES2[c] }
  return nil, score2
end

input = get_input(10)
scores = input.lines.map { |line| calculate_scores(line.chomp) }
scores1, scores2 = scores.transpose.map(&:compact)

answer1 = scores1.inject(0, &:+)
puts "Part 1: #{answer1}"

scores2.sort!
answer2 = scores2[scores2.size / 2]
puts "Part 2: #{answer2}"
