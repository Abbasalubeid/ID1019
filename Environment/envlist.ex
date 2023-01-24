defmodule Envlist do

  def new() do [] end

  def add(map, key, value) do
    case map do
      [] -> [{key, value}]
      [{k, v} | rest] when k == key -> [{key, value} | rest]
      [first | rest] -> [first | add(rest, key, value)]
    end
  end

  def lookup(map, key) do
    case map do
      [] -> nil
      [{k, v} | rest] when k == key -> {k, v}
      [first | rest] -> lookup(rest, key)
    end
  end

  def remove(key, map) do
    case map do
      [] -> []
      [{k, v} | tail] when k == key -> tail
      [head | tail] -> [head | remove(key, tail)]
    end
  end


end
