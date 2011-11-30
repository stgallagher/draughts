class Gui
  
  def intro
    puts 'Welcome to Checkers!'
  end
  
  def move_request(current_player)
    print "#{current_player.to_s.upcase} make move(x1, y1, x2, y2): "
  end 
  
  def render_board(board)
    board_display = []
    board_display << "\n         0     1     2     3     4     5     6    7    \n"
    board_display << "\n      -------------------------------------------------\n"
    
    0.upto(7) do |x_coord|
      board_display << "  #{x_coord}   |  "
      0.upto(7) do |y_coord|
        if board[x_coord][y_coord].nil?
          if (x_coord.even? && y_coord.odd?) || (x_coord.odd? && y_coord.even?)
            board_display << "#" << "  |  "
          elsif x_coord.even? && y_coord.even? || (x_coord.odd? && y_coord.odd?)
            board_display << " " << "  |  "
          end
        elsif board[x_coord][y_coord].color == :red
          if (board[x_coord][y_coord].isKing?) == true
            board_display << "RK" << " |  "
          else
            board_display << "R" << "  |  "
          end
        elsif board[x_coord][y_coord].color == :black
          if (board[x_coord][y_coord].isKing?) == true
            board_display << "BK" << " |  "
          else
            board_display << "B" << "  |  "
          end
        end
      end
      board_display << "\n      -------------------------------------------------\n"
    end
    board_display << "\n"
    puts board_display.to_s
    board_display.to_s
  end
  
  def display_game_ending_message
    winner = (red_checkers_left == 0) ? :black : :red
    puts "\n\nCongratulations, #{winner}, You have won!!!"
  end
end
