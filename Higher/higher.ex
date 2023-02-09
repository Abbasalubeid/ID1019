defmodule Higher do

  def double([]) do [] end
  def double([first | rest]) do [2 * first | double(rest)] end

  def five([]) do [] end
  def five([first | rest]) do [first + 5 | five(rest)] end

end
