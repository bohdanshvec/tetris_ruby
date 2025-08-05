module CheckBlock
  include SettingsGame
  include PrintDrawer
  include GetPressedKey

  MIN_X = 1
  MAX_X = 10
  MIN_Y = 0
  MAX_Y = 19

  def check_block
    change_position_figure_left_right_down_twist

    if figure_fell?(@figure)
      @arr_down.concat(@figure)
      @figure = figure
    else
      figure_down
    end
  end

  def intersects_with_down?(coord)
    @arr_down.any? do |f|
      f[:x] == coord[:x] && f[:y] == coord[:y] + 1
    end
  end

  def figure_fell?(figure)
    figure.any? { |coord| (coord[:y] == MAX_Y) || intersects_with_down?(coord) }
  end

  def change_position_figure_left_right_down_twist
    move_right if @key == "\e[C"
    move_left if @key == "\e[D"
    drop_down if @key == "\e[B"
    twist if @key == "\e[A"
  end

  def figure_down
    @figure.each { |coord| coord[:y] += 1 }
  end

  def clear_full_rows
    rows_to_clear = []

    # 1. Найти все строки, которые полностью заполнены
    (MIN_Y..MAX_Y).each do |y|
      count_in_row = @arr_down.count { |coord| coord[:y] == y }
      rows_to_clear << y if count_in_row == FIELD_WIDTH_GAMING
    end

    return if rows_to_clear.empty?

    # 2. Удалить заполненные строки
    # @arr_down.reject! { |coord| rows_to_clear.include?(coord[:y]) }

    # Пытаюсь добавить анимацию (постепенное удалание элементов)
    animate_clear(rows_to_clear)

    # 3. Сдвинуть оставшиеся блоки вниз (если их y < очищенного)
    rows_to_clear.each do |cleared_y|
      @arr_down.each do |coord|
        if coord[:y] < cleared_y
          coord[:y] += 1
        end
      end
    end
  end

  private

  def animate_clear(rows_to_clear)
    rows_to_clear.each do |y|
      # Найти все координаты на этой строке
      line_coords = @arr_down.select { |coord| coord[:y] == y }

      # Удалять по одному с паузой (для анимации)
      line_coords.sort_by { |coord| coord[:x] }.each do |coord|
        @arr_down.delete(coord)
        @arr_field = field_and_figure
        system "clear"
        print_field  # функция отрисовки поля
        sleep(0.05)
      end
    end
  end

  def move_left
    try_move(dx: -1, dy: 0)
    @arr_field = field_and_figure
    system "clear"
    print_field
    sleep(0.3)
    @key = get_pressed_key_nonblocking
    move_left if @key == "\e[D" 
  end

  def move_right
    try_move(dx: 1, dy: 0)
    @arr_field = field_and_figure
    system "clear"
    print_field
    sleep(0.3)
    @key = get_pressed_key_nonblocking
    move_right if @key == "\e[C"
  end

  def drop_down
    while try_move(dx: 0, dy: 1)
      @arr_field = field_and_figure
      system "clear"
      print_field
      sleep(0.1)
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
    @arr_field = field_and_figure
    system "clear"
    print_field
    sleep(0.3)
    @key = get_pressed_key_nonblocking
    twist if @key == "\e[A"
  end

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
