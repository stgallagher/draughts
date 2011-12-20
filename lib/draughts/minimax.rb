class Minimax
    
    INFINITY = 100000
    
    # Best move -> Have a method that generates all the possible moves, then apply the minimax to each one of those board positions, match the highest score
    #              and return the best move.
    #
    def initialize
      @bs = BoardSurvey.new
      @eval = Evaluation.new
    end
    
    def best_move(board, player, depth)
      move_scores = []
      moves_list = @bs.generate_all_possible_moves(board, player)
      moves_list.each_slice(4) do |move|
        apply_move(board, move)
        move_scores << minimax(board, 4)
      end
      move_scores.flatten
      best_score_index = move_scores.index(move_scores.max)
      moves_list.slice(best_score_index * 4, 4)
    end
    
    def minimax(board, player, depth)
      # if game is over, return score of INFINITY based on victor
      if game_over?(board)
        return who_won(board)
      end

      # if end of search return score
      if depth == 0
        p "in depth == 0"
        return @eval.evaluate_board(board, player)
        p "in depth == 0: score = #{score}"
      else
        # initial best scores
        player == :red ? best_score = -INFINITY : best_score = INFINITY
        
        moves_list = @bs.generate_all_possible_moves(board, player)
        p "moves list = #{moves_list}"
        # if no moves left, return score
        if moves_list == nil
          score = @eval.evaluate_board(board, player)
        else
          # iterate through each move
          moves_list.each_slice(4) do |move| 
            # do the move
            apply_move(board, move)
            p board
            # get the score
            p "In iteration(before recurse): score = #{score}"
            p "In iteration(before recurse): move = #{score}"
            score = minimax(board, player, depth-1)
            # red player maximizes
            p "In iteration(after recurse): score = #{score}"
            p "In iteration(after_recurse): move = #{score}"
            unapply_move(board, move) 
            if player == :red and best_score < score
              best_score = score
            #black player minimizes
            elsif player == :black and best_score > score
              best_score = score
            end
          end
        end
      end
      return best_score
    end

    def game_over?(board)
      red_checkers = 0
      black_checkers = 0
      
      board.each do |row|
        row.each do |position|
          if position.nil? == false
            position.color == :red ? red_checkers += 1 : black_checkers += 1
          end
        end
      end
      red_checkers == 0 or black_checkers == 0
    end

    def who_won(board)
      red_checkers = 0
      black_checkers = 0
      
      board.each do |row|
        row.each do |position|
          if position.nil? == false
            position.color == :red ? red_checkers += 1 : black_checkers += 1
          end
        end
      end
      red_checkers == 0 ? -INFINITY : INFINITY
    end

    def apply_move(board, move)
      checker = board[move[0]][move[1]]
      board[move[2]][move[3]] = checker
      board[move[0]][move[1]] = nil
      checker.x_pos = move[2]
      checker.y_pos = move[3]
    end
    
    def unapply_move(board, move)
      checker = board[move[2]][move[3]]
      board[move[0]][move[1]] = checker
      board[move[2]][move[3]] = nil
      checker.x_pos = move[0]
      checker.y_pos = move[1]
    end
end
