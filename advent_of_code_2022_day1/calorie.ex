defmodule Calorie do

    def max do
    records = File.read!("input.txt")
    #There is a "\n\n" between each elfs intake
    elves = String.split(records, "\n\n")
    #One number of calories for each elf
    total_list = counter(elves, [])
    #Return the maximum number of calories
    Enum.max(total_list)
  end

  def counter([head | tail], calories_per_elf) do
    #Count each elfs total amount and add it to the list
    calories_per_elf = calories_per_elf ++ [add(head)]
    counter(tail, calories_per_elf)
  end

  def counter([], calories_per_elf) do calories_per_elf end

  def add(string) do
    #There is a "\n" between each number of calories for one elf
    add(String.split(string, "\n"), 0)
  end

  def add([], acc) do acc end

  def add([head | tail], acc) do
    add(tail, String.to_integer(head) + acc)
  end


end
