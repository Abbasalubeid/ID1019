defmodule Train do

  def take(_, 0) do [] end
  def take([first | rest], n) do
    if n > 0 do
    [first | take(rest, n - 1)]
    end
  end

  def drop(train, 0) do train end
  def drop([ _ | rest], n) do
    if n > 0 do
      drop(rest, n-1)
    end
  end

  def append(train1, train2) do
    train1 ++ train2
  end

  def member([], _) do false end
  def member([first | rest], y) do
    case first do
      ^y -> true
      _ -> member(rest, y)
    end
  end

  def position([first | rest], y) do
    case first do
      ^y -> 1
      _ -> position(rest, y) + 1
    end
  end

  def split([], _) do
    {[], []}
  end
  def split([y | rest], y) do
    {[], rest}
  end
  def split([first | rest], y) do
    {left, right} = split(rest, y)
    {[first | left], right}
  end

  def main([], n) do {n, [], []} end
  def main([first | last], n) do
      case main(last, n) do
	      {0, drop, take} ->
	        {0, [first |  drop], take}
	      {n, drop, take} ->
	        {n-1, drop, [first | take]}
      end
  end

end
