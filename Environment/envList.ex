defmodule EnvList do

  def new() do [] end

  def add(map, key, value) do
    case map do
      [] -> [{key, value}]
      [{k, _} | rest] when k == key -> [{key, value} | rest]
      [first | rest] -> [first | add(rest, key, value)]
    end
  end

  def lookup(map, key) do
    case map do
      [] -> nil
      [{k, v} | _] when k == key -> {k, v}
      [_ | rest] -> lookup(rest, key)
    end
  end

  def remove(key, map) do
    case map do
      [] -> []
      [{k, _} | tail] when k == key -> tail
      [head | tail] -> [head | remove(key, tail)]
    end
  end

  def bench(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)
    list = Enum.reduce(seq, new(), fn(e, list) ->
    add(list, e, :foo)
    end)
    seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)
    {add, _} = :timer.tc(fn() ->
    Enum.each(seq, fn(e) ->
    add(list, e, :foo)
              end)
            end)
    {lookup, _} = :timer.tc(fn() ->
    Enum.each(seq, fn(e) ->
    lookup(list, e)
            end)
          end)
    {remove, _} = :timer.tc(fn() ->
    Enum.each(seq, fn(e) ->
    remove(e, list)
            end)
          end)
    {i, add, lookup, remove}
  end

  def bench(n) do
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~13.s~17.s~16.s\n", ["n", "add", "lookup", "remove"])
    Enum.each(ls, fn (i) ->
    {i, tla, tll, tlr} = bench(i, n)
    :io.format("~6.w &~12.2f & ~12.2f & ~12.2f \\\\ \n", [i, tla/n, tll/n, tlr/n])
            end)
  end

end
