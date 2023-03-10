defmodule Philosopher do

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def start(hunger, right, left, name, ctrl) do
    spawn_link(fn -> dream(hunger, left, right, name, ctrl) end)
  end

  #Not hungry
  def dream(0, _, _, name, ctrl) do
    # IO.puts("#{name} is dreaming and is full")
    sleep(1000)
    send(self(), :full)
    send(ctrl, :done)
  end
  #Dream for a while, then request chopsticks
  def dream(hunger, left, right, name, ctrl) do
    # IO.puts("#{name} is dreaming")
    sleep(1000)

    # IO.puts("#{name} stopped dreaming")
    wait(hunger, left, right, name, ctrl)
  end

  #Request chopsticks
  def wait(hunger, left, right, name, ctrl) do
    # IO.puts("#{name} is waiting to eat with #{hunger} hunger left")
    case Chopstick.request(left, 1000) && Chopstick.request(right, 1000) do
      :ok ->
        # IO.puts("#{name} received both chopsticks")
        eat(hunger, left, right, name, ctrl)
    end
  end

  #Eat and then return the chopsticks
  def eat(hunger, left, right, name, ctrl) do
    sleep(200)
    # IO.puts("#{name} ate")

    Chopstick.return(left)
    Chopstick.return(right)

    dream(hunger - 1, left, right, name, ctrl)
  end

end
