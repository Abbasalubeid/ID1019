defmodule Chopstick do
  def start do
    stick = spawn_link(fn -> available() end)
    end



end
