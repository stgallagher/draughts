require 'spec_helper'

describe Game do
  before(:each) do
    @game = Game.new
    @board = Board.new
    @new_game_board = @board.create_board
    @clear_board = @board.create_test_board
  end

  it "should move a checker" do
    @board.add_checker(@new_game_board, :red, 3, 3)
    moving_checker = @new_game_board[3][3]
    @game.move(@new_game_board, 3, 3, 4, 4)
    @new_game_board[4][4].should equal(moving_checker)
  end

  it "should tell when the game is over (no checkers left for either player)" do
    @board.add_checker(@clear_board, :red, 3, 3)
    @board.add_checker(@clear_board, :black, 5, 5)
    @game.game_over?(@clear_board).should == false
    @board.remove_checker(@clear_board, 3, 3)
    @game.game_over?(@clear_board).should == true
  end

  it "should switch player" do
    @game.current_player = :red
    @game.switch_player.should == :black
  end
end
