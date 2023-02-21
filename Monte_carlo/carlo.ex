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

  def rounds(k, j, r) do
    :io.format(":math.pi=~.10f\t Archimedes=~.10f\t Zu=~.10f\t\n~n",
      [:math.pi(), 22/7, 355/113])
    rounds(k, j, 0, r, 0)
  end
  #pi = 4 * probability -> 4 * inside/total
  def rounds(0, _, t, _, a) do 4 * (a/t) end
  def rounds(k, j, t, r, a) do
    a = round(j, r, a) #Inside
    t = t + j #total amount of darts
    pi = 4 * (a/t)
    :io.format("Pi= ~.10f\t from_:math.pi= ~f\n~n",[pi, (pi - :math.pi())])
    rounds(k-1, j, t, r, a)
  end

end
