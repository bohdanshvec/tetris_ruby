  require "io/console"
  require_relative "lib/settings_game"
  require_relative "lib/print_drawer"
  require_relative "lib/figures"
  require_relative "lib/get_pressed_key"
  require_relative "lib/check_block"

class Tetris
  include PrintDrawer
  include GetPressedKey
  include SettingsGame
  include Figures
  include CheckBlock

  def initialize
    @arr_figures = figures
    @figure = figure
    @arr_field = []
    @arr_down = []
  end

def run
  loop do


    print_and_wait

    @key = get_pressed_key_nonblocking

    check_block

    clear_full_rows

    if @arr_down.any? { |f| f[:y] == 0 }
      puts "Гру закінчено, ви програли!"
      break
    elsif @key == "\e"
      puts "Вихід з гри...ESCAPE"
      break
    end

  end
end


  private

  def print_and_wait
    @arr_field = field_and_figure
    system "clear"
    print_field
    sleep(SLEEP_INTERVAL)
  end

end

game = Tetris.new
game.run

