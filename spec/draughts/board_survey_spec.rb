require 'spec_helper'

describe'BoardSurvey' do
  before(:each) do
    @bs = BoardSurvey.new
    @current_player = :red
  end

  it "should invert an array" do
    a = [2, -3, 4]
    @bs.invert_array(a).should == [-2, 3, -4]
  end

  it "should provide deltas for determining the right position coordinates (for red player)" do
    @bs.normal_deltas(@current_player).should == [1, 1, 1, -1, -1, 1, -1, -1] 
  end
  
  it "should provide deltas for determining the right position coordinates (for black player)" do
    @current_player = :black
    @bs.normal_deltas(@current_player).should == [-1, -1, -1, 1, 1, -1, 1, 1] 
  end

  it "should indicate if a location is on the edge of the board" do
    @bs.edge?(5).should == false
    @bs.edge?(7).should == true
  end

  it "should modify a locations hash to indicate nil on the edge locations (for red player)" do
    h = {"upper_left" => 1, "upper_right" => 2, "lower_left" => 3, "lower_right" => 4 }
    @bs.edge_adjust(7, @current_player, h).should ==  {"upper_left" => nil, "upper_right" => nil, "lower_left" => 3, "lower_right" => 4 }
  end
  
  it "should modify a locations hash to indicate nil on the edge locations (for black player)" do
    h = {"upper_left"=> 1, "upper_right" => 2, "lower_left" => 3, "lower_right" => 4 }
    @bs.edge_adjust(7, :black, h).should ==  {"upper_left" => 1, "upper_right" => 2, "lower_left" => nil, "lower_right" => nil }
  end

  it "should create board locations that correspond to adajacent positions" do
    x_coord = 3; y_coord = 1
    @bs.deltas_to_board_locations(@bs.normal_deltas(@current_player), x_coord, y_coord).should == [4, 2, 4, 0, 2, 2, 2, 0]
  end
  
  it "should include coordinates with each quadrant" do 
    x_coord = 3; y_coord = 1
    @bs.assign_adjacent_board_coords(@current_player, x_coord, y_coord).should == { "upper_left"=>[4, 2], "upper_right"=>[4, 0], "lower_left"=>[2, 2], "lower_right"=>[2, 0] }
  end
  
  it "should adjust an jump locations hash to have the edge positions nil" do
    @current_player = :black
    x_coord = 7; y_coord = 3
    @bs.assign_adjacent_board_coords(@current_player, x_coord, y_coord).should == { "upper_left"=>[6, 2], "upper_right"=>[6, 4], "lower_left"=> nil , "lower_right"=> nil }
  end

  it "should determine whether adjacent positions contain checkers" do
    board = Board.new
    game_board = board.create_board
    x_coord = 3
    y_coord = 1
    adjacent_content = @bs.determine_adjacent_positions_content(game_board, @bs.assign_adjacent_board_coords(@current_player, x_coord, y_coord))
    adjacent_content["upper_left"].should == nil 
    adjacent_content["upper_right"].should == nil
    adjacent_content["lower_left"].class.should == Checker
    adjacent_content["lower_right"].class.should == Checker
  end
  
  it "should determine if adjacent checkers are opposing checkers" do
    board = Board.new
    game_board = board.create_test_board
    board.add_checker(game_board, :black, 1, 5)
    x_coord = 0
    y_coord = 4
    adjacent_content = @bs.determine_adjacent_positions_content(game_board, @bs.assign_adjacent_board_coords(@current_player, x_coord, y_coord))
    opposing_checkers = @bs.opposing_checker_adjacent(@current_player, adjacent_content).should include( "upper_left"  => true,
                                                                                                         "upper_right" => false,
                                                                                                         "lower_left"  => false,
                                                                                                         "lower_right" => false)
  end
  
  it "should tell if a prospective position is not out-of-bounds" do
    @bs.not_outside_bounds?(0, 4).should == true
    @bs.not_outside_bounds?(8, 5).should == false
  end

  it "should tell if a jump is possible in a particular lane" do
    board = Board.new
    game_board = board.create_board
    @bs.jump_possible?(game_board, [4, 4]).should == true 
    @bs.jump_possible?(game_board, [5, 5]).should == false
  end
  
  it "should be able to convert a given quadrant and xy coords to an array of delta values" do
    quadrant = "upper_right"
    @bs.delta_translator(@current_player, quadrant, 4, 4, 1).should == [5, 3]
    @current_player = :black
    @bs.delta_translator(@current_player, quadrant, 4, 4, 1).should == [3, 5]
  end
  
  it "should not indicate backwards jumps if the checker position is not a king" do
    board = Board.new
    game_board = board.create_test_board
    board.add_checker(game_board, :red, 3, 3)
    board.add_checker(game_board, :black, 4, 4)
    opposing_checkers = @bs.jump_location_finder_stack(game_board, @current_player, 3, 3)
    @bs.adjust_jump_locations_if_not_king(game_board, 3, 3, @bs.jump_locations(game_board,@current_player, 3, 3, opposing_checkers)).should include( "upper_left"  => true,
                                                                                                                                    "upper_right" => false,
                                                                                                                                    "lower_left"  => false,
                                                                                                                                    "lower_right" => false)  
  end 

  it "should determine what quadrants meet the conditions for performing a jump" do
    board = Board.new
    game_board = board.create_test_board
    board.add_checker(game_board, :black, 1, 5)
    board.add_checker(game_board, :red, 0, 4)
    opposing_checkers = @bs.jump_location_finder_stack(game_board, @current_player, 0, 4)    
    @bs.jump_locations(game_board, @current_player, 0, 4, opposing_checkers).should include( "upper_left"  => true,
                                                                            "upper_right" => false,
                                                                            "lower_left"  => false,
                                                                            "lower_right" => false)   
  end

  it "should give a list of jump landing coordinates for a given position" do
    board = Board.new
    game_board = board.create_test_board
    board.add_checker(game_board, :red, 0, 4)
    board.add_checker(game_board, :black, 1, 5)
    opposing_checkers = @bs.jump_location_finder_stack(game_board, @current_player, 0, 4)
    jump_locations = @bs.jump_locations(game_board, @current_player, 0, 4, opposing_checkers)
    @bs.coordinates_of_jump_landings(@current_player, 0, 4, jump_locations).should == [[2, 6]]
  end

  it "should give a list of jump landing coordinates for every checker on the board of a given color" do
    board = Board.new
    game_board = board.create_test_board
    board.add_checker(game_board, :red, 0, 4)
    board.add_checker(game_board, :red, 3, 3)
    board.add_checker(game_board, :black, 4, 4)
    board.add_checker(game_board, :black, 4, 2)
    board.add_checker(game_board, :black, 1, 5)
    @bs.generate_jump_locations_list(game_board, @current_player).should == [2, 6, 5, 5, 5, 1] 
  end

  it "should have a method that performs the ladder of methods necessary to determine jump_locations" do
    board = Board.new
    game_board = board.create_test_board
    board.add_checker(game_board, :red, 3, 3)
    board.add_checker(game_board, :black, 4, 4)
    board.add_checker(game_board, :black, 4, 2)
    @bs.jump_location_finder_stack(game_board, @current_player, 3, 3).should include( "upper_left"  => true,
                                                                           "upper_right" => true,
                                                                           "lower_left"  => false,
                                                                           "lower_right" => false)
  end
end
