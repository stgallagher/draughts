class Board

  attr_accessor :board

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

  def place_checker_on_board(checker)
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
        end
      elsif x_coord.odd?
        odds.each do |y_coord|
          red_checker = Checker.new(x_coord, y_coord, :red)
          @board[x_coord][y_coord] = red_checker 
        end
      end
    end

    5.upto(7) do |x_coord|
      if x_coord.even?
        evens.each do |y_coord|
          black_checker = Checker.new(x_coord, y_coord, :black)
          @board[x_coord][y_coord] = black_checker 
      end
      elsif x_coord.odd?
        odds.each do |y_coord|
          black_checker = Checker.new(x_coord, y_coord, :black)
          @board[x_coord][y_coord] = black_checker 
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

  def self.king_checkers_if_necessary(board)
    board.each do |row|
      row.each do |loc|
        if (loc != nil) and (loc.color == :red) and (loc.x_pos == 7)
          loc.make_king
        elsif (loc != nil) and (loc.color == :black) and (loc.x_pos == 0)
          loc.make_king
        end
      end
    end
  end

  def self.remove_jumped_checker(board, x_origin, y_origin, x_destination, y_destination)
    x_delta = (x_destination > x_origin) ? 1 : -1
    y_delta = (y_destination > y_origin) ? 1 : -1
    
    board[x_origin + x_delta][y_origin + y_delta] = nil
  end

end
