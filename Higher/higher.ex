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
  def apply_to_all([first | rest], f) do
    [f.(first) | apply_to_all(rest, f)]
  end

  def sum([]) do 0 end
  def sum([first | rest]) do first + sum(rest) end

  def fold_right([], base, _) do base end
  def fold_right([first | rest], base, f) do
    f.(first, fold_right(rest, base, f))
  end

  def fold_left([], base, _) do base end
  def fold_left([first | rest], base, f) do
    fold_left(rest, f.(first, base), f)
  end

  def odd([]) do [] end
  def odd([first | last]) do
    if rem(first, 2) == 1 do
      [first | odd(last)]
    else
      odd(last)
    end
  end

  def filter([], _) do [] end
  def filter([first | last], f) do
    case f.(first) do
      true -> [first | filter(last, f)]
      false ->  filter(last, f)
    end
  end

end
