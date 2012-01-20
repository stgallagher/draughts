class Game

  attr_accessor :board, :gui, :single_player_game, :current_player , :x_orig, :y_orig, :x_dest, :y_dest

  def initialize
    @gui = Gui.new
    @current_player = :red
    @bs = BoardSurvey.new
    @evaluation = Evaluation.new
    @input = UserInput.new
    @move_check = MoveCheck.new
    @board = Board.new
    @game_board = @board.create_board
    @minmax = Minimax.new(@bs, @evaluation)
  end

  def play_test_game
    @game_board = @board.create_test_board
    @board.add_checker(@game_board, :red, 0, 0)
    @board.add_checker(@game_board, :red, 0, 2)
    @board.add_checker(@game_board, :black, 7, 5)
    @board.add_checker(@game_board, :black, 7, 7)
    play_game
  end

  def play_game
    @gui.intro
    @gui.one_or_two_player_prompt
    player_input = gets
    @single_player_game = true  if player_input == "y\n"
    while(game_over?(@game_board) == false)
      message = nil
      puts Gui.render_board(@game_board)
      if single_player_game and @current_player == :red
        move = @minmax.best_move(@game_board, :red, 3)
        coordinates = move
        message = @move_check.move_validator(self, @game_board, :red,  coordinates[0], coordinates[1], coordinates[2], coordinates[3])
      else
        @gui.move_request(@current_player)
        player_input = gets
        coordinates = @input.translate_move_request_to_coordinates(player_input)

        message = @move_check.move_validator(self, @game_board, @current_player, coordinates[0], coordinates[1], coordinates[2], coordinates[3])
      end
      puts message unless (message.nil? or message == "jumping move")
    end
    puts Gui.render_board(@game_board)
    puts @gui.display_game_ending_message(@game_board)
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

  def self.switch_player(current_player)
    current_player == :red ? :black : :red
  end
end
