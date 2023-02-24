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
    # IO.puts("Everyone is full!")
  end
  def wait(n, chopsticks) do
    receive do
      :done ->
        wait(n - 1, chopsticks)
      :abort ->
        Process.exit(self(), :kill)
    end
  end

  def bench_start(p), do: spawn(fn -> bench(p) end)

  def bench(p) do
    k = [200, 400, 800, 1600, 3200]
    :io.format("# ~w philosophers eating n times each, time per operation in ms\n", [p])
    :io.format("~s\t\t~s\n", ["n", "time"])
    Enum.each(k, fn (i) ->
      {i, time} = bench(p, i)
      :io.format("~w \t &\t~.2f  \\\\ \n", [i, time/1000000])
            end)
  end

  def bench(p, n) do
    sticks = create_chop(p, [])
    start_time = :erlang.monotonic_time()
    create_philo(p, n, sticks, self(), 0)
    wait(p, sticks)
    real_time = :erlang.monotonic_time() - start_time
    {n, real_time}
  end

  def create_chop(0, arr) do arr end
  def create_chop(n, arr) do
    create_chop(n-1, arr ++ [Chopstick.start()])
  end

  def create_philo(0, _, _, _, _) do :ok end

  def create_philo(p, n, sticks, ctrl, k) do
    if Enum.at(sticks, k+1) != :nil do
      Philosopher.start(n, Enum.at(sticks, k),
        Enum.at(sticks, k+1), "#{p}", ctrl)
    else
      #The last philosopher shares a stick with the first
      Philosopher.start(n, Enum.at(sticks, k),
        Enum.at(sticks, 0), "#{p}", ctrl)
    end

    create_philo(p-1, n, sticks, ctrl, k+1)
  end

end
