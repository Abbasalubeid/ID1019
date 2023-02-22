defmodule Dinner do

  def start(), do: spawn(fn -> init() end)

  def init() do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    Philosopher.start(5, c1, c2, "Arendt", ctrl)
    Philosopher.start(5, c2, c3, "Hypatia", ctrl)
    Philosopher.start(5, c3, c4, "Simone", ctrl)
    Philosopher.start(5, c4, c5, "Elisabeth", ctrl)
    Philosopher.start(5, c5, c1, "Ayn", ctrl)
    wait(5, [c1, c2, c3, c4, c5])
  end

  def wait(0, chopsticks) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
    IO.puts("Everyone is full!")
  end
  def wait(n, chopsticks) do
    receive do
      :done ->
        wait(n - 1, chopsticks)
      :abort ->
        Process.exit(self(), :kill)
    end
  end

  # def bench(p, n) do
  #   sticks = create_chop(n, [Chopstick.start()])
  #   create_philo(n, sticks, name, ctrl)
  #   wait(n, sticks)
  #   :io.format("~w philosophers eating ~w times operations, time per operation in ns\n", [p,n])
  #   :io.format("~6.s~13.s~17.s~16.s\n", ["Philosophers", "n", "time"])
  # end

  def create_chop(0, arr) do arr end
  def create_chop(n, arr) do
    create_chop(n-1, arr ++ [Chopstick.start()])
  end

  def create_philo(n, sticks, name, ctrl) do

  end



end
