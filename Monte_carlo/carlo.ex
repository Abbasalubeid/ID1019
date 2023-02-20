defmodule Carlo do

  def pi(rounds, radius) do
    inside = round(rounds, radius, 0)
    prob = inside / rounds
    4 * prob
  end

  def dart(r) do
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    #If r^2 > x^2 + y^2 -> (x,y) is inside
    :math.pow(r, 2)  >  :math.pow(x, 2) + :math.pow(y, 2)
  end

  #When there is no more darts left, return the accumulator
  def round(0, _, a) do a end
  def round(k, r, a) do
    if dart(r) do
      #One dart inside, accumulator increments
      round(k-1, r, a+1)
    else
      round(k-1, r, a)
    end
  end

end
