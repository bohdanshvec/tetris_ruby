module MoveFigure
  include SettingsGame

  def figure_down
    @figure.each { |coord| coord[:y] += 1 }
  end

  def move_left
    try_move(dx: -1, dy: 0)
    print_and_wait(0.3)
    @key = get_pressed_key_nonblocking
    move_left if @key == "\e[D" 
  end

  def move_right
    try_move(dx: 1, dy: 0)
    print_and_wait(0.3)
    @key = get_pressed_key_nonblocking
    move_right if @key == "\e[C"
  end

  def drop_down
    while try_move(dx: 0, dy: 1)
      print_and_wait(0.1)
    end
  end

  def twist
    pivot = @figure[1] # центр вращения — вторая точка
    min_line = @figure.map { |coord| coord[:y] }.min

    # 1. Поворот относительно центра
    new_positions = @figure.map do |coord|
      dx = coord[:x] - pivot[:x]
      dy = coord[:y] - pivot[:y]

      {
        x: pivot[:x] - dy,
        y: pivot[:y] + dx,
      }
    end

    # 2. Корректировка по вертикали — возвращаем на изначальный верхний уровень
    new_min_y = new_positions.map { |coord| coord[:y] }.min
    delta_y = min_line - new_min_y

    adjusted_positions = new_positions.map do |coord|
      { x: coord[:x], y: coord[:y] + delta_y }
    end

    # 3. Проверка границ и столкновений
    can_rotate = adjusted_positions.all? do |pos|
      pos[:x].between?(MIN_X, MAX_X) &&
        pos[:y].between?(MIN_Y, MAX_Y) &&
        !@arr_down.any? { |f| f[:x] == pos[:x] && f[:y] == pos[:y] }
    end

    # 4. Применить поворот
    @figure = adjusted_positions if can_rotate
    print_and_wait(0.3)
    @key = get_pressed_key_nonblocking
    twist if @key == "\e[A"
  end

  private

  def try_move(dx:, dy:)
    new_positions = @figure.map { |coord| { x: coord[:x] + dx, y: coord[:y] + dy } }

    # проверяем границы и отсутствие столкновений
    can_move = new_positions.all? do |pos|
      pos[:x].between?(MIN_X, MAX_X) && !figure_fell?(new_positions)
    end

    # применяем движение
    @figure = new_positions if can_move
    can_move
  end

end