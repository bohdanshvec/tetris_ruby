module PrintDrawer
  include SettingsGame

  def field_and_figure
    add_down(add_figure(field))
  end

  def print_field
    @arr_field.each { |line| puts line }
  end

  def print_and_wait(time)
    @arr_field = field_and_figure
    system "clear"
    print_field
    sleep(time)
  end

  private

  def field
    arr = []
    FIELD_HEIGHT_GAMING.times { arr << ("|" + " " * FIELD_WIDTH_GAMING + "|") }
    arr << ("-" * FIELD_WIDTH)
    arr
  end

  def add_figure(field)
    @figure.each do |coord|
      x = coord[:x]
      y = coord[:y]

      field[y][x] = "O"
    end

    field
  end

  def add_down(field_with_figure)
    @arr_down.each do |coord|
      x = coord[:x]
      y = coord[:y]

      field_with_figure[y][x] = "O"
    end

    field_with_figure
  end
end
