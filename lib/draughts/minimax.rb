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
      moves_list = @bs.generate_computer_moves(board, player)
      #p "IN BEST MOVE : moves_list -> #{moves_list}"
      moves_list.each_slice(4) do |move|
        apply_move(board, move)
        move_scores << minimax(board, player, depth)
        unapply_move(board, move)
      end
      move_scores.flatten
      best_score_index = move_scores.index(move_scores.max)
      moves_list.slice(best_score_index * 4, 4)
    end
    
    def minimax(board, player, depth)
      if game_over?(board)
        return who_won(board)
      end

      if depth == 0
        #p "in depth == 0"
        return @eval.evaluate_board(board, player)
        #p "in depth == 0: score = #{score}"
      else
        player == :red ? best_score = -INFINITY : best_score = INFINITY
        
        moves_list = @bs.generate_all_possible_moves(board, player)
        #p "IN MINIMAX -> moves list = #{moves_list}"
        if moves_list == nil
          score = @eval.evaluate_board(board, player)
        else
          moves_list.each_slice(4) do |move| 
            apply_move(board, move)
            score = minimax(board, player, depth-1)
            best_score = score > best_score ? score : best_score
            unapply_move(board, move) 
          end
        end
      end
      #p best_score
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
      #p "IN APPLY MOVE: move -> #{move}"
      checker = board[move[0]][move[1]]
      board[move[2]][move[3]] = checker
      board[move[0]][move[1]] = nil
      checker.x_pos = move[2]
      checker.y_pos = move[3]
    end
    
    def unapply_move(board, move)
      #p "IN UNAPPLY MOVE: move -> #{move}"
      checker = board[move[2]][move[3]]
      board[move[0]][move[1]] = checker
      board[move[2]][move[3]] = nil
      checker.x_pos = move[0]
      checker.y_pos = move[1]
    end

    def other_player(player)
      player == :red ? :black : :red
    end
end
