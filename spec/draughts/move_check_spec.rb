require 'spec_helper'

describe MoveCheck do

  before(:each) do
    @mv = MoveCheck.new
    @game = Game.new
    @b = Board.new
    @full_board = @b.create_board
    @clear_board = @b.create_test_board
  end

  it "should give an error message for an invalid move" do
    @mv.move_validator(@game, @full_board, :red, 2, 2, 3, 2).should == "You can only move a checker diagonally"
  end

  it "should tell when a jump is available" do
    @mv.jump_available?(@clear_board, :red).should == false
    @b.add_checker(@clear_board, :red, 3, 3)
    @b.add_checker(@clear_board, :black, 4, 4)
    @mv.jump_available?(@clear_board, :red).should == true
  end

  it "should indicate when a jump is available and not taken" do
    @b.add_checker(@clear_board, :red, 3, 3)
    @b.add_checker(@clear_board, :black, 4, 4)
    @mv.jump_available_and_not_taken?(@clear_board, :red, 4, 2).should == true
    @mv.jump_available_and_not_taken?(@clear_board, :red, 5, 5).should == false
  end

  it "should indicate if an attempted jump was over an empty space" do
    @b.add_checker(@clear_board, :red, 3, 3)
    @mv.attempted_jump_of_empty_space?(@clear_board, :red, 3, 3, 5, 5).should == true
    @b.add_checker(@clear_board, :black, 4, 4)
    @mv.attempted_jump_of_empty_space?(@clear_board, :red, 3, 3, 5, 5).should == false
  end
  
  it "should indicate if an attempted jump was over an empty space" do
    @b.add_checker(@clear_board, :red, 3, 3)
    @b.add_checker(@clear_board, :black, 4, 4)
    @mv.attempted_jump_of_own_checker?(@clear_board, :red, 3, 3, 5, 5).should == false
    @b.remove_checker(@clear_board, 4, 4)
    @b.add_checker(@clear_board, :red, 4, 4)
    @mv.attempted_jump_of_own_checker?(@clear_board, :red, 3, 3, 5, 5).should == true
  end
  
  it "should indicate if a move was a jumping move" do
    @mv.jumping_move?(2, 4).should == true
  end

  it "should indicate if a coordinate set is out of bounds" do
    @mv.out_of_bounds?(3, 3).should == false
    @mv.out_of_bounds?(9, 1).should == true
    @mv.out_of_bounds?(6, -1).should == true
  end
  
  it "should tell if no checker is at the origin of the move" do
    @mv.no_checker_at_origin?(@full_board, 2, 2).should == false
  end

  it "should indicate if the player is trying to move an opponents piece" do
    @mv.trying_to_move_opponents_checker?(@full_board, :red, 5, 1).should == true
  end

  it "should indicate if you are moving more than one space and not jumping" do
    @mv.trying_to_move_more_than_one_space_and_not_jumping?(1, 4).should == true
  end

  it "should indicate if you are trying to move non-diagonally" do
    @mv.attempted_non_diagonal_move?(2, 2, 3, 2).should == true
  end

  it "should indicate if you are trying to move into an occupied square" do
    @mv.attempted_move_to_occupied_square?(@full_board, 5, 1).should == true
  end
  
  it "should tell if a piece is not a king and attempting to move backwards" do
    @b.add_checker(@clear_board, :red, 3, 3)
    @mv.non_king_moving_backwards?(@clear_board, :red, 3, 3, 2).should == true
    @clear_board[3][3].make_king
    @mv.non_king_moving_backwards?(@clear_board, :red, 3, 3, 2).should == false
  end

  it "should not allow a player to jump with a different checker one they have started a jump move with a checker" do
    @b.add_checker(@clear_board, :red, 2, 0)
    @b.add_checker(@clear_board, :red, 2, 6)
    @b.add_checker(@clear_board, :black, 3, 1)
    @b.add_checker(@clear_board, :black, 5, 3)
    @b.add_checker(@clear_board, :black, 3, 5)
    @mv.move_validator(@game, @clear_board, :red, 2, 0, 4, 2).should == "jumping move"
    @mv.move_validator(@game, @clear_board, :red, 2, 6, 4, 4).should == "You cannot jump with a different checker"
  end

  
end
