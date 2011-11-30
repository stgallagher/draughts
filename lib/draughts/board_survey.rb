class BoardSurvey

  def adjacent_positions
    
    if @current_player == :red
      if @x_scan < 7 
        jump_positions = { "upper_left"  => board[@x_scan + 1][@y_scan + 1],
                           "upper_right" => board[@x_scan + 1][@y_scan - 1],
                           "lower_left"  => board[@x_scan - 1][@y_scan + 1],
                           "lower_right" => board[@x_scan - 1][@y_scan - 1] }
      else
        jump_positions = { "upper_left"  => nil,
                           "upper_right" => nil,
                           "lower_left"  => board[@x_scan - 1][@y_scan + 1],
                           "lower_right" => board[@x_scan - 1][@y_scan - 1] }
      end
    end
    if @current_player == :black
      if @x_scan < 7
        jump_positions = { "upper_left"  => board[@x_scan - 1][@y_scan - 1],
                           "upper_right" => board[@x_scan - 1][@y_scan + 1], 
                           "lower_left"  => board[@x_scan + 1][@y_scan - 1],
                           "lower_right" => board[@x_scan + 1][@y_scan + 1] }
      else
        jump_positions = { "upper_left"  => board[@x_scan - 1][@y_scan - 1],
                           "upper_right" => board[@x_scan - 1][@y_scan + 1], 
                           "lower_left"  => nil,
                           "lower_right" => nil }
      end  
    end
    
    jump_positions
  end

  def opposing_checker_adjacent
    opposing_checkers = adjacent_positions

    if  ((opposing_checkers["upper_left"] != nil) and (opposing_checkers["upper_left"].color != @current_player))
      opposing_checkers["upper_left"] = true
    end
    
    if  ((opposing_checkers["upper_right"] != nil) and (opposing_checkers["upper_right"].color != @current_player))
      opposing_checkers["upper_right"] = true
    end
    
    if  ((opposing_checkers["lower_left"] != nil) and (opposing_checkers["lower_left"].color != @current_player))
      opposing_checkers["lower_left"] = true
    end
    
    if  ((opposing_checkers["lower_right"] != nil) and (opposing_checkers["lower_right"].color != @current_player))
      opposing_checkers["lower_right"] = true
    end
   
    opposing_checkers
  end
  
  def jump_locations 
    opposing_checkers = opposing_checker_adjacent
     
    jump_locations = { "upper_left"  => false,
                       "upper_right" => false,
                       "lower_left"  => false,
                       "lower_right" => false } 
    
    checker = @board[@x_scan][@y_scan]
    
    if(opposing_checkers["upper_left"] == true) and 
      (out_of_bounds?(@x_scan + 2, @y_scan + 2) == false) and
      (board[@x_scan + 2][@y_scan + 2] == nil)

      jump_locations["upper_left"] = true
    end
    
    if(opposing_checkers["upper_right"] == true) and 
      (out_of_bounds?(@x_scan + 2, @y_scan - 2) == false) and
      (board[@x_scan + 2][@y_scan - 2] == nil)

      jump_locations["upper_right"] = true
    end
    
    if(checker.isKing? == true)
      
      if(opposing_checkers["lower_left"] == true) and 
        (out_of_bounds?(@x_scan - 2, @y_scan + 2) == false) and
        (board[@x_scan - 2][@y_scan + 2] == nil)

        jump_locations["lower_left"] = true
      end

      if(opposing_checkers["lower_right"] == true) and 
        (out_of_bounds?(@x_scan - 2, @y_scan - 2) == false) and
        (board[@x_scan - 2][@y_scan - 2] == nil)
  
        jump_locations["lower_right"] = true
      end
    end

    if @current_player == :black
      
      jump_locations = { "upper_left"  => false,
                         "upper_right" => false,
                         "lower_left"  => false,
                         "lower_right" => false }

      if(opposing_checkers["upper_left"] == true) and 
        (out_of_bounds?(@x_scan - 2, @y_scan - 2) == false) and
        (board[@x_scan - 2][@y_scan - 2] == nil)

        jump_locations["upper_left"] = true
      end
    
      if(opposing_checkers["upper_right"] == true) and 
        (out_of_bounds?(@x_scan - 2, @y_scan + 2) == false) and
        (board[@x_scan - 2][@y_scan + 2] == nil)
        
        jump_locations["upper_right"] = true
      end
      
      if(checker.isKing? == true)
          
        if(opposing_checkers["lower_left"] == true) and 
          (out_of_bounds?(@x_scan + 2, @y_scan - 2) == false) and
          (board[@x_scan + 2][@y_scan - 2] == nil)

          jump_locations["lower_left"] = true
        end

        if(opposing_checkers["lower_right"] == true) and 
          (out_of_bounds?(@x_scan + 2, @y_scan + 2) == false) and
          (board[@x_scan + 2][@y_scan + 2] == nil)

          jump_locations["lower_right"] = true
        end
      end
    end
    
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
  
  def generate_jump_locations_coordinates_list
    coordinates_list = []

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
