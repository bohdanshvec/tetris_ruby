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

  # def get_pressed_key_nonblocking
  #   input = nil
  #   begin
  #     system('stty raw -echo')
  #     if IO.select([STDIN], nil, nil, 0)  # <-- без ожидания
  #       input = STDIN.getc.chr
  #       input << STDIN.read_nonblock(2) rescue nil if input == "\e"
  #       @time_bloking_key = Time.now
  #     end
  #   ensure
  #     system('stty -raw echo')
  #   end
  #   input
  # end

  def get_pressed_key_nonblocking
    input = nil
    begin
      system("stty raw -echo")
      if IO.select([STDIN], nil, nil, 0)
        first_char = STDIN.read_nonblock(1)

        if first_char == "\e"
          # Попытка дочитать ESC-последовательность (стрелка = 3 символа)
          sequence = first_char
          begin
            # Стрелки обычно приходят быстро, читаем оставшиеся 2 символа
            sequence << STDIN.read_nonblock(1)
            sequence << STDIN.read_nonblock(1)
          rescue IO::WaitReadable, EOFError
            # Если последовательность не полная — не блокируем
          end
          input = sequence[0, 3]  # строго первые 3 символа
        else
          input = first_char  # обычная клавиша
        end

        # Очищаем остатки буфера (если кто-то нажал сразу много)
        begin
          STDIN.read_nonblock(1) while true
        rescue IO::WaitReadable, EOFError
          # всё прочитано
        end
      end
    ensure
      system("stty -raw echo")
    end
    input
  end
end
