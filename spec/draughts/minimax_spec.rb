require 'spec_helper'

describe Minimax do
  before(:each) do
    view = Gui.new
    @game = Game.new(view)
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
    @minmax.minimax(@clear_board, :black, 1, 1).should == @INFINITE
  end

  it "minimax scenario test 2: one possible move, depth 1" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @b.add_checker(@clear_board, :black, 5, 5)
    @minmax.minimax(@clear_board, :black, 1, 1).should == 5
  end

  it "minimax scenario test 3: one possible moves, depth 2" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @b.add_checker(@clear_board, :black, 5, 5)
    @minmax.minimax(@clear_board, :black, 2, 1).should == 0
  end

  it "minimax scenario test 4: two possible moves, different black location, depth 1" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 5, 5)
    @minmax.minimax(@clear_board, :black, 1, 1).should == -5
  end

  it "minimax scenario test 5: two possile moves depth 2" do
    @b.add_checker(@clear_board, :red, 1, 1)
    @b.add_checker(@clear_board, :black, 6, 6)
    @minmax.minimax(@clear_board, :black, 2, 1).should == 0
  end

  it "minimax scenario test 6: two possile moves depth 3" do
    @b.add_checker(@clear_board, :red, 1, 1)
    @b.add_checker(@clear_board, :black, 6, 6)
    @minmax.minimax(@clear_board, :black, 3, 1).should == 5
  end

  it "minimax scenario test 7: alternate two possible moves depth 1" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 1, 7)
    @minmax.minimax(@clear_board, :black, 1, 1).should == -30
  end

  it "minimax scenario test 8: alternate two possible moves depth 2" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 1, 7)
    @minmax.minimax(@clear_board, :black, 2, 1).should == -25
  end

  it "minimax scenario test 9: comprehensive algorithm test depth 1" do
    @b.add_checker(@clear_board, :red, 1, 1)
    @b.add_checker(@clear_board, :black, 6, 6)
    @minmax.minimax(@clear_board, :black, 1, 1).should == -5
  end

  it "minimax scenario test 10: comprehensive algorithm test depth 2" do
    @b.add_checker(@clear_board, :red, 1, 1)
    @b.add_checker(@clear_board, :black, 6, 6)
    @minmax.minimax(@clear_board, :black, 2, 1).should == 0
  end

  it "minimax scenario test 11: comprehensive algorithm test depth 3" do
    @b.add_checker(@clear_board, :red, 1, 1)
    @b.add_checker(@clear_board, :black, 6, 6)
    @minmax.minimax(@clear_board, :black, 3, 1).should == 5
  end

  it "best move scenario trouble-shoot test 1: poor choice fixing" do
    @b.add_checker(@clear_board, :red, 3, 3)
    @b.add_checker(@clear_board, :red, 6, 2)
    @b.add_checker(@clear_board, :black, 0, 4)
    @b.add_checker(@clear_board, :black, 5, 3)
    @minmax.best_move(@clear_board, :red, 3, 2).should_not == [3, 3, 4, 4]
  end

  it "best move scenario trouble-shoot test 2: poor choice fixing" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :red, 2, 6)
    @b.add_checker(@clear_board, :black, 4, 2)
    @b.add_checker(@clear_board, :black, 6, 6)
    @minmax.best_move(@clear_board, :red, 4, 2).should_not == [2, 2, 3, 3]
  end

  it "best move scenario test 1: one possible move, depth 1" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @b.add_checker(@clear_board, :black, 1, 7)
    @minmax.best_move(@clear_board, :red, 1, 1).should == [2, 0, 3, 1]
  end

  it "best move scenario test 2: normal full board depth 1" do
    @minmax.best_move(@full_board, :red, 1, 1).should == [2, 6, 3, 7]
  end

  it "best move scenario test 3: 2 checkers, depth 3" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 5, 5)
    @minmax.best_move(@clear_board, :red, 1, 1).should == [2, 2, 3, 1]
  end

  it "negamax test scenaro 1: " do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 5, 5)
    @minmax.best_move_negamax(@clear_board, :red, 1, 1).should == [2, 2, 3, 1]
  end

  it "negamax test scenaro 2: " do
    @b.add_checker(@clear_board, :red, 4, 2)
    @b.add_checker(@clear_board, :black, 6, 0)
    @minmax.best_move_negamax(@clear_board, :red, 3, 2).should_not == [4, 2, 5, 1]
  end

  it "negamax test scenaro 3: " do
    @b.add_checker(@clear_board, :red, 3, 3)
    @b.add_checker(@clear_board, :red, 3, 5)
    @b.add_checker(@clear_board, :black, 5, 1)
    @b.add_checker(@clear_board, :black, 5, 7)
    @minmax.best_move_negamax(@clear_board, :red, 3, 2).should_not == [3, 3, 4, 2]
    @minmax.best_move_negamax(@clear_board, :red, 3, 2).should_not == [3, 5, 4, 6]
  end

  it "negamax test scenaro 4: " do
    @b.add_checker(@clear_board, :red, 2, 4)
    @b.add_checker(@clear_board, :red, 3, 1)
    @b.add_checker(@clear_board, :black, 5, 1)
    @b.add_checker(@clear_board, :black, 7, 7)
    @minmax.best_move_negamax(@clear_board, :red, 3, 2).should_not == [3, 1, 4, 2]
  end

  it "negamax test scenaro 5: " do
    @b.add_checker(@clear_board, :red, 0, 2)
    @b.add_checker(@clear_board, :red, 0, 4)
    @b.add_checker(@clear_board, :red, 0, 6)
    @b.add_checker(@clear_board, :red, 1, 1)
    @b.add_checker(@clear_board, :red, 1, 3)
    @b.add_checker(@clear_board, :red, 1, 5)
    @b.add_checker(@clear_board, :red, 1, 7)
    @b.add_checker(@clear_board, :red, 2, 0)
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :red, 2, 4)
    @b.add_checker(@clear_board, :red, 2, 6)
    @b.add_checker(@clear_board, :red, 3, 1)
    @b.add_checker(@clear_board, :black, 4, 2)
    @b.add_checker(@clear_board, :black, 4, 4)
    @b.add_checker(@clear_board, :black, 4, 6)
    @b.add_checker(@clear_board, :black, 5, 3)
    @b.add_checker(@clear_board, :black, 6, 0)
    #@b.add_checker(@clear_board, :black, 6, 2)
    #@b.add_checker(@clear_board, :black, 6, 4)
    #@b.add_checker(@clear_board, :black, 6, 6)
    #@b.add_checker(@clear_board, :black, 7, 1)
    #@b.add_checker(@clear_board, :black, 7, 3)
    #@b.add_checker(@clear_board, :black, 7, 5)
    #@b.add_checker(@clear_board, :black, 7, 7)
    @minmax.best_move_negamax(@clear_board, :red, 2, 2).should_not == [2, 2, 3, 3]
  end

  it "negamax test scenaro 6: " do
    @b.add_checker(@clear_board, :red, 0, 0)
    @b.add_checker(@clear_board, :red, 0, 2)
    @b.add_checker(@clear_board, :red, 0, 4)
    @b.add_checker(@clear_board, :red, 0, 6)
    @b.add_checker(@clear_board, :red, 1, 7)
    @b.add_checker(@clear_board, :red, 4, 6)
    @b.add_checker(@clear_board, :red, 5, 5)
    @b.add_checker(@clear_board, :red, 5, 7)
    @b.add_checker(@clear_board, :black, 2, 2)
    @b.add_checker(@clear_board, :black, 3, 1)
    @b.add_checker(@clear_board, :black, 3, 3)
    @b.add_checker(@clear_board, :black, 4, 4)
    @b.add_checker(@clear_board, :black, 6, 2)
    @b.add_checker(@clear_board, :black, 7, 3)
    @b.add_checker(@clear_board, :black, 7, 5)
    @b.add_checker(@clear_board, :black, 7, 7)
    @minmax.best_move_negamax(@clear_board, :red, 3, 1).should_not == [5, 5, 6, 6]
  end

  it "negamax test scenaro 7: " do
    @b.add_checker(@clear_board, :red, 1, 7)
    @b.add_checker(@clear_board, :red, 4, 6)
    @b.add_checker(@clear_board, :red, 5, 5)
    @b.add_checker(@clear_board, :red, 5, 7)
    @b.add_checker(@clear_board, :black, 3, 3)
    @b.add_checker(@clear_board, :black, 4, 4)
    @b.add_checker(@clear_board, :black, 6, 2)
    @b.add_checker(@clear_board, :black, 7, 7)
    @minmax.best_move_negamax(@clear_board, :red, 3, 1).should_not == [5, 5, 6, 6]
  end

  it "negamax test scenaro 8a: " do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 4, 4)
    @minmax.best_move_negamax(@clear_board, :red, 1, 1).should == [2, 2, 3, 1]
  end

  it "negamax test scenaro 8b: " do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 4, 4)
    @minmax.best_move_negamax(@clear_board, :red, 2, 1).should == [2, 2, 3, 1]
  end

  it "negamax test scenaro 8c: " do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 4, 4)
    @minmax.best_move_negamax(@clear_board, :red, 3, 1).should == [2, 2, 3, 1]
  end

  it "negamax test scenaro 8d: " do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 4, 4)
    @minmax.best_move_negamax(@clear_board, :red, 4, 1).should == [2, 2, 3, 1]
  end

  it "negamax general test scenario 1: Two checkers, level 0" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 4, 4)
    @minmax.negamax(@clear_board, :red, 0, 1).should == 5
  end

  it "negamax general test scenario 2: Two checkers, level 1" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 4, 4)
    @minmax.negamax(@clear_board, :red, 1, 1).should == 10
  end

  it "negamax general test scenario 3: Two checkers, level 2" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 4, 4)
    @minmax.negamax(@clear_board, :red, 2, 1).should == 5
  end

  it "negamax general test scenario 4: Two checkers, level 3" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 4, 4)
    @minmax.negamax(@clear_board, :red, 3, 1).should == 10
  end

  it "negamax general test scenario 5: Two checkers, level 4" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 4, 4)
    @minmax.negamax(@clear_board, :red, 4, 1).should == -1
  end

  it "should, if an applied move was a jump, return the same object upon unapply" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 3, 3)
    jumped_checker = @clear_board[3][3]
    @minmax.apply_move(@clear_board, [2, 2, 4, 4])
    @clear_board[3][3].should == nil
    @minmax.unapply_move(@clear_board, [2, 2, 4, 4])
    @clear_board[3][3].should equal(jumped_checker)
  end

  it "should, if an best_move_applied move was a jump, return the same object upon best_move_unapply" do
    @b.add_checker(@clear_board, :red, 2, 2)
    @b.add_checker(@clear_board, :black, 3, 3)
    jumped_checker = @clear_board[3][3]
    @minmax.apply_move(@clear_board, [2, 2, 4, 4])
    @clear_board[3][3].should == nil
    @minmax.unapply_move(@clear_board, [2, 2, 4, 4])
    @clear_board[3][3].should equal(jumped_checker)
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
  end

  it "should return to the board to its original state after best move is called" do
    the_board = @full_board
    @minmax.best_move(@full_board, :red, 2, 1)
    the_board.should == @full_board
  end
end
