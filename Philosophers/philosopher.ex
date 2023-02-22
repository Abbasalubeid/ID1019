defmodule Philosopher do

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def start(hunger, right, left, name, ctrl) do
    spawn_link(fn -> dreaming(hunger, left, right, name, ctrl) end)
  end

  #Not hungry
  def dreaming(0, _, _, name, ctrl) do
    IO.puts("#{name} is dreaming and is full")
    sleep(1000)
    send(self(), :full)
    send(ctrl, :done)
  end
  #
  def dreaming(hunger, left, right, name, ctrl) do
    IO.puts("#{name} is dreaming")
    sleep(1000)

    IO.puts("#{name} stoped dreaming")
    wait(hunger, left, right, name, ctrl)
  end

  def wait(hunger, left, right, name, ctrl) do
    IO.puts("#{name} is waiting to eat with #{hunger} hunger left")

    case Chopstick.request(left, 1000) && Chopstick.request(right, 1000) do
      :ok ->
        IO.puts("#{name} got both sticks")
        eating(hunger, left, right, name, ctrl)
      end

end
