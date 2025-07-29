module Figures
  def figures
    [
      [ { x: 4, y: 0 }, { x: 5, y: 0 }, { x: 6, y: 0 }, { x: 7, y: 0 } ],
      [ { x: 5, y: 0 }, { x: 4, y: 1 }, { x: 5, y: 1 }, { x: 6, y: 1 } ],
      [ { x: 4, y: 0 }, { x: 5, y: 0 }, { x: 6, y: 0 }, { x: 6, y: 1 } ],
      [ { x: 5, y: 0 }, { x: 6, y: 0 }, { x: 7, y: 0 }, { x: 5, y: 1 } ],
      [ { x: 4, y: 0 }, { x: 5, y: 0 }, { x: 6, y: 0 }, { x: 5, y: 1 } ],
      [ { x: 5, y: 0 }, { x: 6, y: 0 }, { x: 4, y: 1 }, { x: 5, y: 1 } ],
      [ { x: 4, y: 0 }, { x: 5, y: 0 }, { x: 5, y: 1 }, { x: 6, y: 1 } ],
    ]
  end

  def figure
    figures.sample
  end
end