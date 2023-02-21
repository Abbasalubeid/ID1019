defmodule Chopstick do

  def start do
    stick = spawn_link(fn -> available() end)
  end

  def available() do
    receive do
      {:request, from} -> gone()
      :quit -> :ok
    end
  end

  def gone() do
    receive do
      :return -> available()
      :quit -> :ok
    end
  end





end
