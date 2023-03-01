defmodule Train do

  def take(_, 0) do [] end
  def take([first | rest ], n) do
    [first | take(rest, n - 1)]
  end

  def drop(train, 0) do train end
  def drop([first | rest ], n) do
    drop(rest, n-1)
  end


end
