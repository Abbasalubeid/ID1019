defmodule Shunt do

  def find([], []) do [] end

  def find(xs, [left | ys]) do
    {hs, ts} = Train.split(xs, left)
    tn = length(ts)
    hn = length(hs)
    [{:one, tn+1}, {:two, hn}, {:one, -(tn+1)}, {:two, -hn} |
      find(Train.append(hs, ts), ys)]
  end

  def few([], []) do [] end

  def few([x |xs], [left|ys]) do
      {hs, ts} = Train.split([x |xs], left)
    if (x != left) do
      tn = length(ts)
      hn = length(hs)
      [{:one, tn+1}, {:two, hn}, {:one, -(tn+1)}, {:two, -hn} |
        few(Train.append(hs, ts), ys)]
    else
      few(ts, ys)
    end
  end

  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
      ms
    else
      compress(ns)
    end
  end

end
