class Game
  
  attr_accessor :board, :gui, :red_checkers, :black_checkers, :current_player , :x_orig, :y_orig, :x_dest, :y_dest, :x_scan, :y_scan 
                
  def initialize
    @red_checkers   = Array.new
    @black_checkers = Array.new
    @gui = BasicGui.new
    @current_player = :red
    @board = create_board
  end

  def play_game
    puts intro

    while(game_over? == false)
      message = nil
      @gui.render_board(@board)
      print move_request
      player_input = gets 
      coordinates = translate_move_request_to_coordinates(player_input) 
      configure_coordinates(coordinates)

      message = move_validator
      puts message unless (message.nil? or message == "jumping move")
      if(message == nil or message == "jumping move")
        @current_player = switch_player unless (message == "jumping move" and jump_available? == true)
      end
    end
    puts display_game_ending_message  
  end

  def game_over?
    (red_checkers_left == 0) or (black_checkers_left == 0)
  end

  def switch_player
    @current_player == :red ? :black : :red
  end
end 
