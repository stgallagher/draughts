require 'spec_helper'

describe Evaluation do
  before(:each) do
    @game = Game.new
    @b = Board.new
    @eval = Evaluation.new
    @full_board = @b.create_board
    @clear_board = @b.create_test_board
  end

  it "should have a weighted representation of the board" do
    pending
  end
  
  it "should calculate the value of a checker based on its position" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @eval.calculate_value(@clear_board[2][0], :red).should == 20
  end

  it "should calculate the value of the board based on checkers presence and position" do
    @b.add_checker(@clear_board, :red, 4, 6)
    @b.add_checker(@clear_board, :red, 2, 0)
    @b.add_checker(@clear_board, :black, 1, 5)
    @b.add_checker(@clear_board, :black, 7, 5)
    @clear_board[7][5].make_king
    @eval.evalute_board(@clear_board, :red).should == -26
  end
end
