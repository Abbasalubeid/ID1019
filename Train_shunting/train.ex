defmodule Train do

  def take(_, 0) do [] end
  def take([first | rest ], n) do
    [first | take(rest, n - 1)]
  end



end
