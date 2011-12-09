class Game
  
  attr_accessor :board, :gui, :current_player , :x_orig, :y_orig, :x_dest, :y_dest 
                
  def initialize
    @gui = Gui.new
    @current_player = :red
    @input = UserInput.new
    @move_check = MoveCheck.new
    @board = Board.new
    @game_board = @board.create_board
  end

  def play_game
    @gui.intro

    while(game_over?(@game_board) == false)
      message = nil
      puts @gui.render_board(@game_board)
      @gui.move_request(@current_player)
      player_input = gets 
      coordinates = @input.translate_move_request_to_coordinates(player_input) 

      message = @move_check.move_validator(self, @game_board, @current_player, coordinates[0], coordinates[1], coordinates[2], coordinates[3])
      puts message unless (message.nil? or message == "jumping move")
      if(message == nil or message == "jumping move")
        @current_player = switch_player unless (message == "jumping move" and @move_check.jump_available?(@game_board, @current_player))
      end
    end
    @gui.display_game_ending_message  
  end
  
  def move(board, x_origin, y_origin, x_destination, y_destination)
    #moving
    moving_checker = board[x_origin][y_origin]

    # set new location for checker
    moving_checker.x_pos = x_destination
    moving_checker.y_pos = y_destination

    # update board positions of checker
    board[x_origin][y_origin] = nil
    board[x_destination][y_destination] = moving_checker
  end
  
  def game_over?(board)
    @board.checkers_left(board, :black) == 0 or @board.checkers_left(board, :red) == 0
  end

  def switch_player
    @current_player == :red ? :black : :red
  end
end 
