class Board

  def create_board
    @board = Array.new(8)
    8.times { |index| @board[index] = Array.new(8) }
    populate_checkers
    @board
  end
  
  def create_test_board
    @board = Array.new(8)
    8.times { |index| @board[index] = Array.new(8) }
    @board
  end

  def create_debug_board_and_play
    create_test_board
    red_checker1 = Checker.new(2, 4, :red)
    red_checker2 = Checker.new(3, 3, :red)
    red_checker3 = Checker.new(1, 1, :red)
    black_checker = Checker.new(5, 3, :black)
    place_checker_on_board(red_checker1)
    place_checker_on_board(red_checker2)
    place_checker_on_board(red_checker3)
    place_checker_on_board(black_checker)
    play_game
  end

  def place_checker_on_board(checker)
    if checker.color == :red
      @red_checkers << checker
    else
      @black_checkers << checker
    end
    @board[checker.x_pos][checker.y_pos] = checker 
  end

  def populate_checkers
    evens = [0, 2, 4, 6]
    odds  = [1, 3, 5, 7]

    0.upto(2) do |x_coord|
      if x_coord.even?
        evens.each do |y_coord|
          red_checker = Checker.new(x_coord, y_coord, :red)
          @board[x_coord][y_coord] = red_checker 
          @red_checkers << red_checker
        end
      elsif x_coord.odd?
        odds.each do |y_coord|
          red_checker = Checker.new(x_coord, y_coord, :red)
          @board[x_coord][y_coord] = red_checker 
          @red_checkers << red_checker
        end
      end
    end

    5.upto(7) do |x_coord|
      if x_coord.even?
        evens.each do |y_coord|
          black_checker = Checker.new(x_coord, y_coord, :black)
          @board[x_coord][y_coord] = black_checker 
          @black_checkers << black_checker
      end
      elsif x_coord.odd?
        odds.each do |y_coord|
          black_checker = Checker.new(x_coord, y_coord, :black)
          @board[x_coord][y_coord] = black_checker 
          @black_checkers << black_checker
        end
      end
    end
  end

  def red_checkers_left
    red_count = 0

    @board.each do |row|
      row.each do |location|
        if (location.nil? == false) and (location.color == :red)
          red_count += 1
        end
      end
    end
    red_count
  end
  
  def black_checkers_left
    black_count = 0

    @board.each do |row|
      row.each do |location|
        if (location.nil? == false) and (location.color == :black)
          black_count += 1
        end
      end
    end
    black_count
  end

  def king_checkers_if_necessary
    @board.each do |row|
      row.each do |loc|
        if (loc != nil) and (loc.color == :red) and (loc.x_pos == 7)
          loc.make_king
        elsif (loc != nil) and (loc.color == :black) and (loc.x_pos == 0)
          loc.make_king
        end
      end
    end
  end

  def remove_jumped_checker
    x_delta = (@x_dest > @x_orig) ? 1 : -1
    y_delta = (@y_dest > @y_orig) ? 1 : -1
    
    remove_checker_x_value = @x_orig + x_delta
    remove_checker_y_value = @y_orig + y_delta
    
    
    removed_checker = @board[remove_checker_x_value][remove_checker_y_value]
    @board[remove_checker_x_value][remove_checker_y_value] = nil
  end

end
