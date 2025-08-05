require_relative 'move_figure'

module CheckBlock
  include SettingsGame
  include PrintDrawer
  include GetPressedKey
  include MoveFigure

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

  def clear_full_rows
    rows_to_clear = []

    # 1. Найти все строки, которые полностью заполнены
    (MIN_Y..MAX_Y).each do |y|
      count_in_row = @arr_down.count { |coord| coord[:y] == y }
      if count_in_row == FIELD_WIDTH_GAMING
        rows_to_clear << y
        @count_result += 1
      end
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
        print_and_wait(0.05)
      end
    end
  end
  
end
