defmodule Train do

  def take(_, 0) do [] end
  def take([first | rest ], n) do
    if n > 0 do
    [first | take(rest, n - 1)]
    end
  end

  def drop(train, 0) do train end
  def drop([first | rest ], n) do
    if n > 0 do
      drop(rest, n-1)
    end
  end

  def append(train1, train2) do
    train1 ++ train2
  end

  def member([], _) do false end
  def member([first | last], y) do
    case first do
      ^y -> true
      _ -> member(last, y)
    end
  end


end
