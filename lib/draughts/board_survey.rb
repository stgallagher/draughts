class BoardSurvey

  attr_accessor :board, :current_player
  
  QUADRANTS = ["upper_left", "upper_right", "lower_left", "lower_right"]
  
  def invert_array(array)
    array.map! { |x| -x }
  end
  
  def normal_deltas
    deltas = [1, 1, 1, -1, -1, 1, -1, -1] 
    @current_player == :red ? deltas : invert_array(deltas) 
  end
  
  def edge?(x)
    x > 7
  end

  def edge_adjust(hash)
    @current_player == :red ? hash.merge({"upper_left" => nil, "upper_right" => nil}) : hash.merge({"lower_left" => nil, "lower_right" => nil}) 
  end

  def deltas_to_board_locations(deltas, x, y)
    board_coords = []
    deltas.each_slice(2) do |slice|
      board_coords << x + slice[0] 
      board_coords << y + slice[1]
    end
    board_coords
  end    

  def assign_adjacent_board_coords(x, y) 
    jump_positions = Hash[QUADRANTS.zip(deltas_to_board_locations(normal_deltas, x, y).each_slice(2))]    
  end
  
  def determine_adjacent_positions_content(board, board_coords)
    adjacent_content = {}
    board_coords.each_pair { |quad, coords| adjacent_content[quad] = board[coords[0]][coords[1]] }
    adjacent_content
  end 
  
  def opposing_checker_adjacent(adjacent_content)
    opposing_checker_adjacent = {}
    adjacent_content.each_pair do |quad, content|
      if content != nil 
        content.color != @current_player ? opposing_checker_adjacent[quad] = true : opposing_checker_adjacent[quad] = false 
      else
        opposing_checker_adjacent[quad] = false
      end
    end
    opposing_checker_adjacent
  end
  
  def not_outside_bounds?(x, y, dx, dy)
    move_check = MoveCheck.new
    not move_check.out_of_bounds?(x + dx, y + dy)
  end

  def jump_possible?(board, x, y, deltas)
    (not_outside_bounds?(x, y, deltas[0], deltas[1]) and board[x + deltas[0]][y + deltas[1]] == nil) ? true : false
  end
  
  def delta_translator(quad, x, y)
    deltas = []
    case quad
    when "upper_left"
      x += 1; y += 1
    when "upper_right"
      x += 1; y -= 1
    when "lower_left"
      x -= 1; y += 1
    when "lower_right"
      x -= 1; y -= 1  
    end
    deltas << x << y
    @current_player == :black ? deltas.reverse : deltas
  end
  
  def adjust_jump_locations_if_not_king(board, x, y, jump_locations)
    unless board[x][y].is_king?
      jump_locations["lower_left"]  = false
      jump_locations["lower_right"] = false
    end
    jump_locations
  end

  def jump_locations(board, x, y, opposing_checkers)
    jump_locations = {}
    opposing_checkers.each_pair do |quad, present|
      if present
        deltas = delta_translator(quad, x, y)
        jump_possible?(board, x, y, deltas) ? jump_locations[quad] = true : jump_locations[quad] = false
      else
        jump_locations[quad] = false
      end
    end
    adjust_jump_locations_if_not_king(board, x, y, jump_locations)
    jump_locations
  end
 
    
  def jump_locations_coordinates
    locations = jump_locations
    
    jump_coords = []
    
    if @current_player == :red
      if locations["upper_left"]  == true
        jump_coords << [@x_scan + 2, @y_scan + 2]
      end
      if locations["upper_right"] == true
        jump_coords << [@x_scan + 2, @y_scan - 2] 
      end
      if locations["lower_left"]  == true
        jump_coords << [@x_scan - 2, @y_scan + 2]
      end
      if locations["lower_right"] == true
        jump_coords << [@x_scan - 2, @y_scan - 2]
      end
    end

    if @current_player == :black
      if locations["upper_left"]  == true
        jump_coords << [@x_scan - 2, @y_scan - 2]
      end
      if locations["upper_right"] == true
        jump_coords << [@x_scan - 2, @y_scan + 2] 
      end
      if locations["lower_left"]  == true
        jump_coords << [@x_scan + 2, @y_scan - 2]
      end
      if locations["lower_right"] == true
        jump_coords << [@x_scan + 2, @y_scan + 2]
      end
    end
    
    jump_coords
  end
  
  def generate_jump_locations_coordinates_list(board, current_player)
    coordinates_list = []
    @board = board
    @current_player = current_player 
    
    @board.each do |row|
      row.each do |loc|
        if (loc != nil) and (loc.color == @current_player)
          @x_scan = loc.x_pos
          @y_scan = loc.y_pos
          coordinates_list << jump_locations_coordinates
        end
      end
    end
    
    coordinates_list.flatten
  end
end
