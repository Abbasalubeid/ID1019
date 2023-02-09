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
    :double -> [2 * first | double_five_animal(rest, :double)]
    :five -> [first + 5 | double_five_animal(rest, :five)]
    :animal ->
      if first == :dog do
        [:fido | double_five_animal(rest, :animal)]
      else
        [first | double_five_animal(rest, :animal)]
      end
    end
  end

  def apply_to_all([], _) do [] end
  def apply_to_all([first | rest], fun) do [fun.(first) | apply_to_all(rest, fun)] end

  def sum([]) do 0 end
  def sum([first | rest]) do first + sum(rest) end

end
