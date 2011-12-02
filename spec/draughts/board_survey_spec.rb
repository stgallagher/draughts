require 'spec_helper'

describe'BoardSurvey' do
  before(:each) do
    @bs = BoardSurvey.new
  end

  it "should invert an array" do
    a = [2, -3, 4]
    @bs.invert_array(a).should == [-2, 3, -4]
  end

  it "should provide deltas for determining the right position coordinates (for red player)" do
    @bs.current_player = :red
    @bs.normal_deltas.should == [1, 1, 1, -1, -1, 1, -1, -1] 
  end
  
  it "should provide deltas for determining the right position coordinates (for black player)" do
    @bs.current_player = :black
    @bs.normal_deltas.should == [-1, -1, -1, 1, 1, -1, 1, 1] 
  end

  it "should indicate if a location is on the edge of the board" do
    @bs.edge?(5).should == false
    @bs.edge?(8).should == true
  end

  it "should modify a locations hash to indicate nil on the edge locations (for red player)" do
    @bs.current_player = :red
    h = {"upper_left" => 1, "upper_right" => 2, "lower_left" => 3, "lower_right" => 4 }
    @bs.edge_adjust(h).should ==  {"upper_left" => nil, "upper_right" => nil, "lower_left" => 3, "lower_right" => 4 }
  end
  
  it "should modify a locations hash to indicate nil on the edge locations (for black player)" do
    @bs.current_player = :black
    h = {"upper_left"=> 1, "upper_right" => 2, "lower_left" => 3, "lower_right" => 4 }
    @bs.edge_adjust(h).should ==  {"upper_left" => 1, "upper_right" => 2, "lower_left" => nil, "lower_right" => nil }
  end

  it "should create board locations that correspond to adajacent positions" do
    @bs.current_player = :red
    board = Board.new
    b = board.create_board
    x_coord = 5
    y_coord = 5
    d = @bs.normal_deltas
    @bs.deltas_to_board_locations(d, x_coord, y_coord).should == [6, 6, 6, 4, 4, 6, 4, 4]
  end

  it "should assign board locations as adjacent positions and deliver that info as a whole" do
    @bs.current_player = :red
    board = Board.new
    @bs.board = board.create_board
    x_coord = 3
    y_coord = 1
    jump_assignments = @bs.assign_adjacent_positions(x_coord, y_coord)
    jump_assignments.each_pair { |k, v| puts " #{k} is #{v}" }
    jump_assignments["upper_left"].class.should == Checker
    jump_assignments["upper_right"].class.should == Checker
    jump_assignments["lower_left"].class.should == Checker
    jump_assignments["lower_right"].class.should == Checker
  end
end
