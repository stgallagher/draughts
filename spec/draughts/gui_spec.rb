require 'spec_helper'


describe Gui do

  before(:each) do
    @gui = Gui.new
    @b = Board.new
    @board = @b.create_board
    @clear_board = @b.create_test_board
  end

  it "should print out an simple text display of the board" do
        Gui.render_board(@board).should == "\n         0     1     2     3     4     5     6    7    \n\n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  0   |  R  |  #  |  R  |  #  |  R  |  #  |  R  |  #  |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  1   |  #  |  R  |  #  |  R  |  #  |  R  |  #  |  R  |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  2   |  R  |  #  |  R  |  #  |  R  |  #  |  R  |  #  |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  3   |  #  |     |  #  |     |  #  |     |  #  |     |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  4   |     |  #  |     |  #  |     |  #  |     |  #  |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  5   |  #  |  B  |  #  |  B  |  #  |  B  |  #  |  B  |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  6   |  B  |  #  |  B  |  #  |  B  |  #  |  B  |  #  |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  7   |  #  |  B  |  #  |  B  |  #  |  B  |  #  |  B  |  \n" +
                                                 "      -------------------------------------------------\n\n"

  end

  it "should print a BK or RK for black king checkers or red king checkers" do
       @board[0][0].make_king
       @board[0][0].color = :black
       @board[7][1].make_king
       @board[7][1].color = :red
       Gui.render_board(@board).should == "\n         0     1     2     3     4     5     6    7    \n\n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  0   |  BK |  #  |  R  |  #  |  R  |  #  |  R  |  #  |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  1   |  #  |  R  |  #  |  R  |  #  |  R  |  #  |  R  |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  2   |  R  |  #  |  R  |  #  |  R  |  #  |  R  |  #  |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  3   |  #  |     |  #  |     |  #  |     |  #  |     |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  4   |     |  #  |     |  #  |     |  #  |     |  #  |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  5   |  #  |  B  |  #  |  B  |  #  |  B  |  #  |  B  |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  6   |  B  |  #  |  B  |  #  |  B  |  #  |  B  |  #  |  \n" +
                                                 "      -------------------------------------------------\n" +
                                                 "  7   |  #  |  RK |  #  |  B  |  #  |  B  |  #  |  B  |  \n" +
                                                 "      -------------------------------------------------\n\n"

  end

  it "should display a game ending message" do
    @b.add_checker(@clear_board, :red, 0, 0)
    @gui.display_game_ending_message(@clear_board).should == "\n\nCongratulations, Red, You have won!!!"
  end
end
