defmodule Higher do

  def double([]) do [] end
  def double([first | rest]) do [2 * first | double(rest)] end

  def five([]) do [] end
  def five([first | rest]) do [first + 5 | five(rest)] end

  def animal([]) do [] end
  def animal(([first | rest])) do
    case first do
      :dog -> [:fido | animal(rest)]
      _ -> [first | animal(rest)]
    end
  end

  def double_five_animal([], _) do [] end
  def double_five_animal([first | rest], atom) do
    case atom do
    :double -> [2 * first | double(rest)]
    :five -> [first + 5 | five(rest)]
    :animal ->
      if first == :dog do
        [:fido | animal(rest)]
      else
        [first | animal(rest)]
      end
    end
  end

end
