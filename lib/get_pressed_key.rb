module GetPressedKey

  include SettingsGame
  
  # получение нажатой клавиши поворота
  # def get_pressed_key
  #   input = nil
  #   begin
  #     system('stty raw -echo')  # Переключаем терминал в raw-режим
  #     if IO.select([STDIN], nil, nil, SLEEP_INTERVAL)
  #       input = STDIN.getc.chr  # Считываем первый символ
  #       if input == "\e"        # Если это ESC, возможно, это начало последовательности
  #         input << STDIN.read_nonblock(2) rescue nil  # Считываем следующие два символа
  #       end
  #     else
  #       input = nil  # Если время ожидания истекло, возвращаем nil
  #     end
  #   ensure
  #     system('stty -raw echo')    # Возвращаем терминал в обычный режим
  #   end
  #   input
  # end

  def get_pressed_key_nonblocking
    input = nil
    begin
      system('stty raw -echo')
      if IO.select([STDIN], nil, nil, 0)  # <-- без ожидания
        input = STDIN.getc.chr
        input << STDIN.read_nonblock(2) rescue nil if input == "\e"
      end
    ensure
      system('stty -raw echo')
    end
    input
  end

end