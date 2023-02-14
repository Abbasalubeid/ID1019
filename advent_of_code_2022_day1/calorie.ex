defmodule Calorie do

  def reader do
    records = File.read!("input.txt")
    #There is a "\n\n" between each elf
    elfs = String.split(records, "\n\n")
    elfs
  end

  def add(string) do
    #There is a "\n" between each number of calories for one elf
    add(String.split(string, "\n"), 0)
  end

  def add([], acc) do acc end

  def add([head | tail], acc) do
    add(tail, String.to_integer(head) + acc)
  end


end
