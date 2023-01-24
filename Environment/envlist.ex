defmodule Envlist do

  def new() do [] end

  def add(map, key, value) do
    case map do
      [] -> map ++ [{key, value}]
      [{k, v} | rest] when k == key -> [{key, value} | rest]
      [first | rest] -> [first | add(rest, key, value)]
    end
  end


end
