class UserInput

  def configure_coordinates(coordinates)
    @x_orig = coordinates[0]
    @y_orig = coordinates[1]
    @x_dest = coordinates[2]
    @y_dest = coordinates[3]
  end

  def translate_move_request_to_coordinates(move_request)
    coords_array = move_request.chomp.split(',').map { |x| x.to_i }
  end

end
