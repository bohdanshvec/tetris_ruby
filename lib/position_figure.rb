module PositionFigure

  def change_position_figure(key)

    if key == "\e[C" && @figure.all? { |coord| coord[:x] + 1 < 11 }
      @figure.each { |coord| coord[:x] += 1}
    elsif key == "\e[D" && @figure.all? { |coord| coord[:x] - 1 > 0 }
      @figure.each { |coord| coord[:x] -= 1}
    end
    
    @figure.each { |coord| coord[:y] += 1}

  end

end