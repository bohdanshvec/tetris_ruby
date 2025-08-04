# module PositionFigure

#   def change_position_figure

#     # if @key == "\e[C" && @figure.all? { |coord| coord[:x] + 1 < 11 }
#     #   @figure.each { |coord| coord[:x] += 1}
#     # elsif @key == "\e[D" && @figure.all? { |coord| coord[:x] - 1 > 0 }
#     #   @figure.each { |coord| coord[:x] -= 1}
#     # end
#     if @key == "\e[C" 
#       move_right
#     elsif @key == "\e[D"
#       move_left
#     end
    
#     @figure.each { |coord| coord[:y] += 1}

#   end

#   def move_left
#     if @figure.all? { |coord| (coord[:x] - 1 > 0) && (!intersects_with_left?(coord)) }
#       @figure.each { |coord| coord[:x] -= 1}
#     end
#   end

#   def move_right
#     if @figure.all? { |coord| (coord[:x] + 1 < 11) && (!intersects_with_right?(coord)) }
#       @figure.each { |coord| coord[:x] += 1}
#     end
#   end

#   def intersects_with_right?(coord)
#     @arr_down.any? do |f|
#       f[:x] == coord[:x] + 1 && f[:y] == coord[:y]
#     end
#   end

#   def intersects_with_left?(coord)
#     @arr_down.any? do |f|
#       f[:x] == coord[:x] - 1 && f[:y] == coord[:y]
#     end
#   end

# end

module PositionFigure
  # include CheckBlock

  MIN_X = 1
  MAX_X = 10

  def change_position_figure_left_right
    move_right if @key == "\e[C"
    move_left  if @key == "\e[D"
    drop_down if @key == "\e[B"
  end

  def figure_down
    @figure.each { |coord| coord[:y] += 1 }
  end

  private

  def move_left
    try_move(dx: -1, dy: 0)
  end

  def move_right
    try_move(dx: 1, dy: 0)
  end

  def drop_down
    while try_move(dx: 0, dy: 1)
    end
  end

  def try_move(dx:, dy:)
    new_positions = @figure.map { |coord| { x: coord[:x] + dx, y: coord[:y] + dy } }

    # проверяем границы и отсутствие столкновений
    can_move = new_positions.all? do |pos|
      pos[:x].between?(MIN_X, MAX_X) &&
        !@arr_down.any? { |f| f[:x] == pos[:x] && f[:y] == pos[:y] }
    end

    # применяем движение
    @figure = new_positions if can_move
    can_move
  end
end
