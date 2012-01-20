require 'spec_helper'

describe Minimax do
  before(:each) do
    @game = Game.new
    @b = Board.new
    @eval = Evaluation.new
    @bs = BoardSurvey.new
    @full_board = @b.create_board
    @clear_board = @b.create_test_board
    @minmax = Minimax.new(@bs, @eval)
    @INFINITE = Minimax::INFINITY
  end

  it "should indicate when the game is over" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @minmax.game_over?(@clear_board).should == true
  end

  it "should return a score of INFINITY if the game is over" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @minmax.who_won(@clear_board).should == @INFINITE
  end

  it "should apply a move to the board" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @minmax.apply_move(@clear_board, [2, 0, 3, 1])
    @clear_board[2][0].should == nil
    @clear_board[3][1].color.should == :red
    @clear_board[3][1].x_pos.should == 3
  end

  it "should unapply a move to the board" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @minmax.apply_move(@clear_board, [2, 0, 3, 1])
    @minmax.unapply_move(@clear_board, [2, 0, 3, 1])
    @clear_board[3][1].should == nil
    @clear_board[2][0].color.should == :red
    @clear_board[2][0].x_pos.should == 2
  end

  it "minimax scenario test 1: game_over" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @minmax.minimax(@clear_board, :black, 1).should == @INFINITE
  end

  it "minimax scenario test 2: one possible move, depth 1" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @b.add_checker(@clear_board, :black, 5, 5)
    @minmax.minimax(@clear_board, :black, 1).should == 5
  end

  it "minimax scenario test 3: one possible moves, depth 2" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @b.add_checker(@clear_board, :black, 5, 5)
    @minmax.minimax(@clear_board, :black, 2).should == 0
  end

  it "minimax scenario test 4: two possible moves, different black location, depth 1" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 5, 5)
    @minmax.minimax(@clear_board, :black, 1).should == -5
  end

  it "minimax scenario test 5: two possile moves depth 2" do
    @b.add_checker(@clear_board, :red, 1, 1)
    @b.add_checker(@clear_board, :black, 6, 6)
    @minmax.minimax(@clear_board, :black, 2).should == 0
  end

  it "minimax scenario test 6: two possile moves depth 3" do
    @b.add_checker(@clear_board, :red, 1, 1)
    @b.add_checker(@clear_board, :black, 6, 6)
    @minmax.minimax(@clear_board, :black, 3).should == 5
  end

  it "minimax scenario test 7: alternate two possible moves depth 1" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 1, 7)
    @minmax.minimax(@clear_board, :black, 1).should == -30
  end

  it "minimax scenario test 8: alternate two possible moves depth 2" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 1, 7)
    @minmax.minimax(@clear_board, :black, 2).should == -25
  end

  it "minimax scenario test 9: comprehensive algorithm test depth 1" do
    @b.add_checker(@clear_board, :red, 1, 1)
    @b.add_checker(@clear_board, :black, 6, 6)
    @minmax.minimax(@clear_board, :black, 1).should == -5
  end

  it "minimax scenario test 10: comprehensive algorithm test depth 2" do
    @b.add_checker(@clear_board, :red, 1, 1)
    @b.add_checker(@clear_board, :black, 6, 6)
    @minmax.minimax(@clear_board, :black, 2).should == 0
  end

  it "minimax scenario test 11: comprehensive algorithm test depth 3" do
    @b.add_checker(@clear_board, :red, 1, 1)
    @b.add_checker(@clear_board, :black, 6, 6)
    @minmax.minimax(@clear_board, :black, 3).should == 5
  end

  it "minimax2 scenario test 2: score confirmation" do
    pending
    @b.add_checker(@clear_board, :red, 5, 7)
    @b.add_checker(@clear_board, :black, 7, 7)
    @minmax.minimax2(@clear_board, :black, 1).should == 0
    @minmax.minimax2(@clear_board, :black, 2).should == 1
  end

  it "best move scenario test 1: one possible move, depth 1" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @b.add_checker(@clear_board, :black, 1, 7)
    @minmax.best_move(@clear_board, :red, 1).should == [2, 0, 3, 1]
  end

  it "best move scenario test 2: normal full board depth 1" do
    @minmax.best_move(@full_board, :red, 1).should == [2, 2, 3, 1]
  end

  it "best move scenario test 3: 2 checkers, depth 3" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 5, 5)
    @minmax.best_move(@clear_board, :red, 1).should == [2, 2, 3, 1]
  end

  it "should, if an applied move was a jump, return the same object upon unapply" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 3, 3)
    jumped_checker = @clear_board[3][3]
    @minmax.apply_move(@clear_board, [2, 2, 4, 4])
    @clear_board[3][3].should == nil
    @minmax.unapply_move(@clear_board, [2, 2, 4, 4])
    @clear_board[3][3].should equal(jumped_checker)
    puts Gui.render_board(@clear_board)
  end

  it "should, if an best_move_applied move was a jump, return the same object upon best_move_unapply" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 3, 3)
    jumped_checker = @clear_board[3][3]
    @minmax.apply_move(@clear_board, [2, 2, 4, 4])
    @clear_board[3][3].should == nil
    @minmax.unapply_move(@clear_board, [2, 2, 4, 4])
    @clear_board[3][3].should equal(jumped_checker)
    puts Gui.render_board(@clear_board)
  end

  it "have the right jumped checkers in place after a multi-jump, once unapply move is done" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 3, 3)
    @b.add_checker(@clear_board, :black, 5, 5)
    jumped_checker1 = @clear_board[3][3]
    jumped_checker2 = @clear_board[5][5]
    @minmax.apply_move(@clear_board, [2, 2, 4, 4])
    @minmax.apply_move(@clear_board, [4, 4, 6, 6])
    @clear_board[3][3].should == nil
    @clear_board[5][5].should == nil
    @minmax.unapply_move(@clear_board, [4, 4, 6, 6])
    @minmax.unapply_move(@clear_board, [2, 2, 4, 4])
    @clear_board[3][3].should equal(jumped_checker1)
    @clear_board[5][5].should equal(jumped_checker2)
    puts Gui.render_board(@clear_board)
  end

  it "should return to the board to its original state after best move is called" do
    pending
    the_board = @full_board
    @minmax.best_move(@full_board, :red, 2)
    the_board.should == @full_board
  end
end
