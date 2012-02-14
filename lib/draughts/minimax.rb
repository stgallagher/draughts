class Minimax

    INFINITY = 100000

    # Best move -> Have a method that generates all the possible moves, then apply the minimax to each one of those board positions, match the highest score
    #              and return the best move.
    #
    def initialize(board_survey, evaluation)
      @bs = board_survey
      @eval = evaluation
      @jumped_checker = []
    end

    def best_move(board, player, depth, eval_choice)
      #p "IN BEST MOVE : player -> #{player}"
      move_scores = []
      moves_list = @bs.generate_computer_moves(board, player)
      moves_list.each_slice(4) do |move|
      #p "IN BEST MOVE : before apply move"
        apply_move(board, move)
        move_scores << minimax(board, :black, depth, eval_choice)
      #p "IN BEST MOVE : before unapply move"
        unapply_move(board, move)
      end
      move_scores.flatten
      #p "IN BEST MOVE : moves_list -> #{moves_list}"
      #p "IN BEST MOVE : move_scores -> #{move_scores}"
      best_score_index = move_scores.index(move_scores.max)
      #p "IN BEST MOVE : best_score_index -> #{best_score_index}"
      best_move_coords = moves_list.slice(best_score_index * 4, 4)
      #p "IN BEST MOVE : best_move_coords -> #{best_move_coords}"
      best_move_coords
    end

    def best_move_negamax(board, player, depth, eval_choice)
      moves_list = @bs.generate_computer_moves(board, player)
      #p "IN BEST_MOVE_NEGAMAX - moves_list = #{moves_list}"
      max = -INFINITY
      best_move = []
      moves_list.each_slice(4) do |move|
        apply_move(board, move)
        score = -negamax(board, Game.switch_player(player), depth - 1, eval_choice)
        #p "IN BEST_MOVE_NEGAMAX - score = #{score} with move #{move}"
        if score > max
          max = score
          best_move = move
        end
        unapply_move(board, move)
      end
      #p "IN BEST_MOVE_NEGAMAX - best_move = #{best_move}"
      return best_move
    end

    def negamax(board, player, depth, eval_choice)
      #game over evaluation
      if game_over?(board)
        return_score = who_won(board)
        #p "IN NEGAMAX - RETURNED SCORE(game_over) = #{return_score} for player #{player}"
        return return_score
      end

      #leaf evaluation
      if depth == 0
        evaluated_score = @eval.evaluation_chooser(eval_choice, board)
        return_score = player == :red ? evaluated_score : -evaluated_score
        #p "IN NEGAMAX - RETURNED SCORE(leaf) = #{return_score} for player #{player}"
        return return_score
      end

      max = -INFINITY
      moves_list = @bs.generate_computer_moves(board, player)

      #no possible move evaluation
      if moves_list == []
        return_score = player == :red ? -INFINITY : INFINITY
        #p "IN NEGAMAX - RETURNED SCORE(empty moves_list) = #{return_score} for player #{player}"
        return return_score
      end

      #p "IN NEGAMAX - moves_list = #{moves_list}"
      #scoring each move
      moves_list.each_slice(4) do |move|
        apply_move(board, move)
        score = -negamax(board, Game.switch_player(player), depth-1, eval_choice)
        if score > max
          max = score
        end
        unapply_move(board, move)
      end

      #returning max
      return max
    end

    def minimax(board, player, depth, eval_choice)
      #p "IN MINIMAX: player -> #{player}"
      if game_over?(board)
        return who_won(board)
      end

      if depth == 0
        evaluated_score = @eval.evaluation_chooser(eval_choice, board)
        #p "IN MINIMAX -> returned value = #{evaluated_score}"
        return @eval.evaluation_chooser(eval_choice, board)
      else
        player == :red ? best_score = -INFINITY : best_score = INFINITY

        moves_list = @bs.generate_all_possible_moves(board, player)
        #p "IN MINIMAX -> moves list = #{moves_list}"
        if moves_list == nil
          score = @eval.evaluation_chooser(eval_choice, board)
        else
          moves_list.each_slice(4) do |move|
            #p "IN MINIMAX -> before apply move"
            apply_move(board, move)
            score = minimax(board, Game.switch_player(player), depth-1, eval_choice)
            if player == :red
              #p "IN MINIMAX -> in best score branch(red) -> #{best_score}"
              best_score = score > best_score ? score : best_score
            elsif player == :black
              #p "IN MINIMAX -> in best score branch(black) -> #{best_score}"
              best_score = score < best_score ? score : best_score
            end
            #p "IN MINIMAX -> before unapply move"
            unapply_move(board, move)
            #p "IN MINIMAX -> after unapply move board status = "
            #puts Gui.render_board(board)
          end
        end
      end
      #p "IN MINIMAX -> best score = #{best_score}"
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
      if (move[2] - move[0]).abs == 2
        #Board.remove_jumped_checker(board, move[0], move[1], move[2], move[3])
        x_delta = (move[2] > move[0]) ? 1 : -1
        y_delta = (move[3] > move[1]) ? 1 : -1
        #p "MINIMAX::APPLY_MOVE -> move 1 - 4, x_delta, y_delta : #{move}, #{x_delta}, #{y_delta}"
        #p "MINIMAX::APPLY_MOVE -> before assign, jumping_checker pos  = #{@jumped_checker}"
        @jumped_checker.push(board[move[0] + x_delta][move[1] + y_delta])
        #p "MINIMAX::APPLY_MOVE -> jumped_checker = #{@jumped_checker}"
        #p "MINIMAX::APPLY_MOVE -> jumped pos = #{move[0] + x_delta } , #{move[1] + y_delta }"
        board[move[0] + x_delta][move[1] + y_delta] = nil
      end
      board
    end

    def unapply_move(board, move)
      #p "IN UNAPPLY MOVE: move -> #{move}"
      if (move[2] - move[0]).abs == 2
        #Board.return_jumped_checker(board, move[0], move[1], move[2], move[3])
        x_delta = (move[2] > move[0]) ? 1 : -1
        y_delta = (move[3] > move[1]) ? 1 : -1

        #p "MINIMAX::UNAPPLY_MOVE -> move 1 - 4, x_delta, y_delta : #{move}, #{x_delta}, #{y_delta}"
        #p "MINIMAX::UNAPPLY_MOVE -> jumped_checker = #{@jumped_checker}"
        #p "MINIMAX::UNAPPLY_MOVE -> jumped pos = #{move[0] + x_delta } , #{move[1] + y_delta }"
        board[move[0] + x_delta][move[1] + y_delta] = @jumped_checker.pop
        board
      end
      #p "IN UNAPPLY MOVE: before unapplied move, board at x-orig, y-orig -> #{board[move[0]][move[1]]} and x-dest, y-dest -> #{board[move[2]][move[3]]}"
      checker = board[move[2]][move[3]]
      board[move[0]][move[1]] = checker
      board[move[2]][move[3]] = nil
      checker.x_pos = move[0]
      checker.y_pos = move[1]
      #p "IN UNAPPLY MOVE: after unapplied move, board at x-orig, y-orig -> #{board[move[0]][move[1]]} and x-dest, y-dest -> #{board[move[2]][move[3]]}"
      #p "IN UNAPPLY MOVE: after unapplied move, TOTAL BOARD IS : #{board}}"
      board
    end

    def other_player(player)
      player == :red ? :black : :red
    end
end
