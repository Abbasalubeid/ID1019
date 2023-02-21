defmodule Philosopher do

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def start(hunger, right, left, name, ctrl) do

  end

end
