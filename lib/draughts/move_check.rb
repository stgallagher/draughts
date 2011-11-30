class MoveCheck
  
  def move_validator
    message = nil
    
    case 
    when out_of_bounds?(@x_dest, @y_dest) == true
      message = "You cannot move off the board"
      
    when no_checker_at_origin? == true
      message = "There is no checker to move in requested location"
    
    when trying_to_move_opponents_checker? == true 
      message = "You cannot move an opponents checker"  
     
    when trying_to_move_more_than_one_space_and_not_jumping? == true
      message = "You cannot move more than one space if not jumping"

    when attempted_non_diagonal_move? == true
      message = "You can only move a checker diagonally"
      
    when attempted_move_to_occupied_square? == true
      message = "You cannot move to an occupied square"
      
    when non_king_moving_backwards? == true
      message = "A non-king checker cannot move backwards"
    
    when attempted_jump_of_empty_space? == true  
      message = "You cannot jump an empty space"

    when attempted_jump_of_own_checker? == true
      message = "You cannot jump a checker of your own color"
      
    when jump_available_and_not_taken? == true
      message = "You must jump if a jump is available"  
    
    else
      move
      if jumping_move?
        message = "jumping move"
        remove_jumped_checker
      end
      king_checkers_if_necessary
    end
    message
  end

  def jump_available?
    possible_jumps = generate_jump_locations_coordinates_list
    
    possible_jumps.size > 0
  end
  
  def jump_available_and_not_taken?
    jump_possiblities = generate_jump_locations_coordinates_list
    
    not_taken_jump = true
    jump_possiblities.each_slice(2) do |i|
      if(i[0] == @x_dest) and (i[1] == @y_dest)
        not_taken_jump = false
      end
    end
    
    (jump_available? == true) and (not_taken_jump)   
  end          
  
  def attempted_jump_of_empty_space?
    if jumping_move?
      x_delta = (@x_dest > @x_orig) ? 1 : -1
      y_delta = (@y_dest > @y_orig) ? 1 : -1
      
      if @current_player == :black
       x_delta = (@x_dest < @x_orig) ? -1 : 1
       y_delta = (@y_dest < @y_orig) ? -1 : 1
      end
 
      jumped_checker_x_value = @x_orig + x_delta
      jumped_checker_y_value = @y_orig + y_delta
    
      jumped_checker = @board[jumped_checker_x_value][jumped_checker_y_value]
      jumped_checker.nil?
    end
  end
  
  def attempted_jump_of_own_checker?
    if jumping_move?
      x_delta = (@x_dest > @x_orig) ? 1 : -1
      y_delta = (@y_dest > @y_orig) ? 1 : -1
      
      if @current_player == :black
       x_delta = (@x_dest < @x_orig) ? -1 : 1
       y_delta = (@y_dest < @y_orig) ? -1 : 1
     end
 
      jumped_checker_x_value = @x_orig + x_delta
      jumped_checker_y_value = @y_orig + y_delta
    
      jumped_checker = @board[jumped_checker_x_value][jumped_checker_y_value]
      
      jumping_checker = @board[@x_orig][@y_orig]

      jumped_checker.color == jumping_checker.color
    end
  end

  def jumping_move?
    (@x_dest - @x_orig).abs == 2 
  end
  
  def out_of_bounds?(x, y)
   ( x < 0  or y < 0) or (x > 7  or y > 7)
  end

  def no_checker_at_origin?
    @board[@x_orig][@y_orig].nil?
  end

  def trying_to_move_opponents_checker?
    @current_player != board[@x_orig][@y_orig].color
  end
  
  def trying_to_move_more_than_one_space_and_not_jumping?
    (@x_dest - @x_orig).abs > 2
  end

  def attempted_non_diagonal_move?
    (@x_orig == @x_dest) or (@y_orig == @y_dest)
  end

  def attempted_move_to_occupied_square?
    not board[@x_dest][@y_dest].nil?
  end
  
  def non_king_moving_backwards?
    if @current_player == :red 
      (@x_dest < @x_orig) and (board[@x_orig][@y_orig].isKing? == false)
    else
      (@x_dest > @x_orig) and (board[@x_orig][@y_orig].isKing? == false)
    end
  end


end
