defmodule Moves do
  def single({_, 0}, state) do
    state
  end

  def single({:one, n}, {main, one, two}) when n < 0 do
    {Train.append(main, Train.take(one, -n)), Train.drop(one, -n), two}
  end

  def single({:one, n}, {main, one, two}) when n > 0 do
    {_, remain, taken} = Train.main(main, n)
    {remain, Train.append(taken, one), two}
  end

  def single({:two, n}, {main, one, two}) when n < 0 do
    {Train.append(main, Train.take(two, -n)), one, Train.drop(two, -n)}
  end

  def single({:two, n}, {main, one, two}) when n > 0 do
    {_, remain, taken} = Train.main(main, n)
    {remain, one, Train.append(taken, two)}
  end
end
