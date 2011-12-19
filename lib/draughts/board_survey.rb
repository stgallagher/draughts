class BoardSurvey

  attr_accessor :board, :current_player
  
  QUADRANTS = ["upper_left", "upper_right", "lower_left", "lower_right"]
  
  def invert_array(array)
    array.map! { |x| -x }
  end
  
  def normal_deltas(current_player)
    deltas = [1, 1, 1, -1, -1, 1, -1, -1] 
    current_player == :red ? deltas : invert_array(deltas) 
  end
  
  def edge?(x)
    x == 7 or x == 0
  end

  def edge_adjust(x, current_player, hash)
    if x == 0
      current_player == :red ? hash.merge({"lower_left" => nil, "lower_right" => nil}) : hash.merge({"upper_left" => nil, "upper_right" => nil}) 
    else
      current_player == :red ? hash.merge({"upper_left" => nil, "upper_right" => nil}) : hash.merge({"lower_left" => nil, "lower_right" => nil})
    end
  end

  def deltas_to_board_locations(deltas, x, y)
    board_coords = []
    deltas.each_slice(2) do |slice|
      board_coords << x + slice[0] 
      board_coords << y + slice[1]
    end
    board_coords
  end    

  def assign_adjacent_board_coords(current_player, x, y) 
    jump_positions = Hash[QUADRANTS.zip(deltas_to_board_locations(normal_deltas(current_player), x, y).each_slice(2))]    
    if edge?(x)
      return edge_adjust(x, current_player, jump_positions)
    end
    jump_positions
  end
  
  def determine_adjacent_positions_content(board, board_coords)
    adjacent_content = {}
    board_coords.each_pair { |quad, coords| coords.nil? ? adjacent_content[quad] = nil : adjacent_content[quad] = board[coords[0]][coords[1]] }
    adjacent_content
  end 
  
  def opposing_checker_adjacent(current_player, adjacent_content)
    opposing_checker_adjacent = {}
    adjacent_content.each_pair do |quad, content|
      if content != nil 
        content.color != current_player ? opposing_checker_adjacent[quad] = true : opposing_checker_adjacent[quad] = false 
      else
        opposing_checker_adjacent[quad] = false
      end
    end
    opposing_checker_adjacent
  end
  
  def not_outside_bounds?(x, y)
    move_check = MoveCheck.new
    not move_check.out_of_bounds?(x, y)
  end

  def jump_possible?(board, deltas)
    (not_outside_bounds?(deltas[0], deltas[1]) and board[deltas[0]][deltas[1]] == nil) ? true : false
  end
  
  def delta_translator(current_player, quad, x, y, mag)
    deltas = []
    case quad
    when "upper_left"
      x += mag; y += mag
    when "upper_right"
      x += mag; y -= mag
    when "lower_left"
      x -= mag; y += mag
    when "lower_right"
      x -= mag; y -= mag  
    end
    deltas << x << y
    current_player == :black ? deltas.reverse : deltas
  end
  
  def adjust_jump_locations_if_not_king(board, x, y, jump_locations)
    unless board[x][y].is_king?
      jump_locations["lower_left"]  = false
      jump_locations["lower_right"] = false
    end
    jump_locations
  end

  def jump_locations(board, current_player, x, y, opposing_checkers)
    jump_locations = {}
    opposing_checkers.each_pair do |quad, present|
      if present
        deltas = delta_translator(current_player, quad, x, y, 2)
        jump_possible?(board, deltas) ? jump_locations[quad] = true : jump_locations[quad] = false
      else
        jump_locations[quad] = false
      end
    end
    adjust_jump_locations_if_not_king(board, x, y, jump_locations)
    jump_locations
  end
  
  def coordinates_of_jump_landings(current_player,x, y, jump_locations)
    jump_coords = []
    
    jump_locations.each_pair do |quad, jump|
      if jump
        jump_coords << delta_translator(current_player, quad, x, y, 2)
      end
    end
    jump_coords
  end
  
  def jump_location_finder_stack(board, current_player, x, y)
    adj_board_coords = assign_adjacent_board_coords(current_player, x, y)
    adj_content = determine_adjacent_positions_content(board, adj_board_coords)
    opposing_checkers = opposing_checker_adjacent(current_player, adj_content)
    jump_locations(board, current_player, x, y, opposing_checkers)
  end

  def generate_jump_locations_list(board, current_player)
    coordinates_list = []
    
    board.each do |row|
      row.each do |loc|
        if (loc != nil) and (loc.color == current_player)
          jump_locations = jump_location_finder_stack(board, current_player, loc.x_pos, loc.y_pos)
          coordinates_list << coordinates_of_jump_landings(current_player, loc.x_pos, loc.y_pos, jump_locations)  
        end
      end
  end
    coordinates_list.flatten
  end

  def any_jumps_left?(board, current_player, x, y)
    jumps = jump_location_finder_stack(board, current_player, x, y)
    jumps.has_value?(true)
  end

  def surrounding_locations_for_checker(board, current_player, x, y)
    deltas = normal_deltas(current_player)
    possible_moves = deltas_to_board_locations(deltas, x, y)
    if board[x][y].is_king? == false
      possible_moves.slice!(4, 4)
    end
    possible_moves
  end

  def remove_out_of_bounds_locations(possible_moves)
    corrected_possible_moves = []
    possible_moves.each_slice(2) do |coords|
      if ((coords[0] <= 7 and coords[0] >= 0) and (coords[1] <= 7 and coords[1] >= 0))
        corrected_possible_moves << coords[0] << coords[1]
      end
    end
    corrected_possible_moves
  end
  
  def normal_move_locations(possible_moves, board, current_player, x, y)
    corrected_possible_moves = []
    possible_moves.each_slice(2) do |coords|
      if board[coords[0]][coords[1]] == nil
        corrected_possible_moves << x << y << coords[0] << coords[1]
      end
    end
    corrected_possible_moves
  end

  def normal_move_location_finder_stack(board, current_player, x, y)
    locations = surrounding_locations_for_checker(board, current_player, x, y)
    removed_out_of_bounds_locations = remove_out_of_bounds_locations(locations)
    normal_move_locations = normal_move_locations(removed_out_of_bounds_locations, board, current_player, x, y)
  end

  def generate_normal_move_locations_list(board, current_player)
    move_locations = []
    
    board.each do |row|
      row.each do |loc|
        if (loc != nil) and (loc.color == current_player)
          move_locations << normal_move_location_finder_stack(board, current_player, loc.x_pos, loc.y_pos)
        end
      end
    end
    move_locations.flatten
  end
 
  def coordinates_of_computer_jump_landings(current_player,x, y, jump_locations)
    jump_coords = []
    
    jump_locations.each_pair do |quad, jump|
      if jump
        jump_coords << x << y << delta_translator(current_player, quad, x, y, 2)
      end
    end
    jump_coords
  end

  def generate_computer_jump_locations_list(board, current_player)
    coordinates_list = []
    
    board.each do |row|
      row.each do |loc|
        if (loc != nil) and (loc.color == current_player)
          jump_locations = jump_location_finder_stack(board, current_player, loc.x_pos, loc.y_pos)
          coordinates_list << coordinates_of_computer_jump_landings(current_player, loc.x_pos, loc.y_pos, jump_locations)  
        end
      end
    end
    coordinates_list.flatten
  end

  def generate_all_possible_moves(board, current_player)
    all_moves = generate_normal_move_locations_list(board, current_player)
    all_moves << generate_computer_jump_locations_list(board, current_player)
    all_moves.flatten
  end
end
