defmodule Calorie do

  def reader do
    records = File.read!("input.txt")
    records
  end
end
