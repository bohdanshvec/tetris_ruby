  require "io/console"
  require_relative "lib/settings_game"
  require_relative "lib/print_drawer"
  require_relative "lib/figures"
  require_relative "lib/position_figure"
  require_relative "lib/get_pressed_key"

class Tetris
  include PrintDrawer
  include GetPressedKey
  include SettingsGame
  include Figures
  include PositionFigure

  def initialize
    @arr_figures = figures
    @figure = figure
    @arr_field = []
    @arr_down = []
  end

  # def run
    
  #   loop do
  #     @key = get_pressed_key

  #     check_block
      
  #     if @key == "\e"  # просто Escape
  #       puts "Выход из игры..."
  #       break
  #     end

  #     @arr_field = field_and_figure
  #     print_and_wait

  #   end
  # end

  def run
    loop do
      start_time = Time.now

      @key = get_pressed_key_nonblocking  # <-- не блокирует
      check_block

      if @key == "\e"  # просто Escape
        puts "Выход из игры..."
        break
      end

      @arr_field = field_and_figure
      print_and_wait

      # Спим столько, сколько осталось до 0.3 сек
      # elapsed = Time.now - start_time
      # sleep([SLEEP_INTERVAL - elapsed, 0].max)
      
    end
  end

  private

  def print_and_wait
    system "clear"
    print_field
    sleep SLEEP_INTERVAL
  end

  def check_block
    if @figure.any? { |coord| (coord[:y] == (FIELD_HEIGHT_GAMING - 1)) || intersects_with_down?(coord) } 
      @arr_down.concat(@figure)
      @figure = figure
    else
      # update_position_figure
      change_position_figure(@key)
    end
  end

  def intersects_with_down?(coord)
    @arr_down.any? do |f|
      f[:x] == coord[:x] && f[:y] == coord[:y] + 1
    end
  end

end

game = Tetris.new
game.run

