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
    @count_result = 0
    @time_start = Time.now
  end

  def run
    loop do
      print_and_wait(0.3)

      @key = get_pressed_key_nonblocking

      check_block

      clear_full_rows

      if @arr_down.any? { |f| f[:y] == 0 }
        puts "Гру закінчено, ви програли! Ваш результат: #{@count_result} ліній, ви грали #{time_game}"
        break
      elsif @key == "\e"
        puts "Вихід з гри...ESCAPE Ваш результат: #{@count_result} ліній, ви грали #{time_game}"
        break
      end
    end
  end

  private

  def time_game
    elapsed = Time.now - @time_start
    minutes = (elapsed / 60).to_i
    seconds = (elapsed % 60).to_i

    if minutes > 0
      "#{minutes} мин #{seconds} сек"
    else
      "#{seconds} сек"
    end
  end
end

game = Tetris.new
game.run
