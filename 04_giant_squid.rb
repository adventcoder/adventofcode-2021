require_relative 'framework'

def turns_until_bingo(board, nums)
  row_counts = Array.new(board.size, board.size)
  col_counts = Array.new(board.size, board.size)
  turn = 0
  until row_counts.include?(0) || col_counts.include?(0)
    for y in 0 ... board.size
      for x in 0 ... board.size
        if board[y][x] == nums[turn]
          row_counts[y] -= 1
          col_counts[x] -= 1
        end
      end
    end
    turn += 1
  end
  turn
end

def score(board, nums)
  turn = turns_until_bingo(board, nums)
  (board.flatten - nums.take(turn)).inject(0, &:+) * nums[turn - 1]
end

def parse_nums(chunk)
  chunk.split(',').map(&:to_i)
end

def parse_board(chunk)
  chunk.split("\n").map { |line| line.split.map(&:to_i) }
end

chunks = get_input(4).split("\n\n")
nums = parse_nums(chunks[0])
boards = chunks.drop(1).map { |chunk| parse_board(chunk) }

winner = boards.min_by { |board| turns_until_bingo(board, nums) }
puts "Part 1: #{score(winner, nums)}"

loser = boards.max_by { |board| turns_until_bingo(board, nums) }
puts "Part 2: #{score(loser, nums)}"
