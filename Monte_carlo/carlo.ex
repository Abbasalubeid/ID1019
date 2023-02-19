defmodule Carlo do

  def dart(r) do
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    #If r^2 > x^2 + y^2 -> (x,y) is inside
    :math.pow(r, 2)  >  :math.pow(x, 2) + :math.pow(y, 2)
  end

end
