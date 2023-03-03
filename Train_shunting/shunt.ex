defmodule Shunt do

  def find([], []) do [] end

  def find(xs, [left | ys]) do
    {hs, ts} = Train.split(xs, left)
    tn = length(ts)
    hn = length(hs)
    [{:one, tn+1}, {:two, hn}, {:one, -(tn+1)}, {:two, -hn} | find(Train.append(hs, ts), ys)]
  end




end
