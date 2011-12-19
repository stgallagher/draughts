class Evaluation

  BOARD_WEIGHT = [ [   4, nil,   4, nil,   4, nil,   4, nil],
                   [ nil,   3, nil,   3, nil,   3, nil,   4],
                   [   4, nil,   2, nil,   2, nil,   3, nil],
                   [ nil,   3, nil,   1, nil,   2, nil,   4],
                   [   4, nil,   2, nil,   1, nil,   3, nil],
                   [ nil,   3, nil,   2, nil,   2, nil,   4],
                   [   4, nil,   3, nil,   3, nil,   3, nil],
                   [ nil,   4, nil,   4, nil,   4, nil,   4], ]

  def evalute_board(board, color)
    player_value = 0
    opponent_value = 0

    color == :red ? opponent_color = :black : opponent_color = :red

    board.each do |row|
      row.each do |position|
        if position.nil? == false
          position.color == color ? player_value += calculate_value(position, color) : opponent_value += calculate_value(position, opponent_color)
        end
      end
    end
    return player_value - opponent_value
  end

  def calculate_value(position, color)
    if color == :red
      if position.x_pos == 5 or position.x_pos == 6
        value = 7
      else
        value = 5
      end
    elsif color == :black
      if position.x_pos == 1 or position.x_pos == 2
        value = 7
      else
        value = 5
      end
    end

    if position.is_king?
      value = 10
    end
    p value * BOARD_WEIGHT[position.x_pos][position.y_pos]   
    return value * BOARD_WEIGHT[position.x_pos][position.y_pos]
  end

end
