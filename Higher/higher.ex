defmodule Higher do

  def double ([]) do [] end

  def double ([h | t]) do [2 * h | double(t)] end

end
