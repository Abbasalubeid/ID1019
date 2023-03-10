defmodule Chopstick do

  def start do
    spawn_link(fn -> available() end)
  end

  def available() do
    receive do
      {:request, from} ->
        #Confirmation
        send(from, :granted)
        gone()
      :quit -> :ok
    end
  end

  def gone() do
    receive do
      :return -> available()
      :quit -> :ok
    end
  end

  #Abstraction
  def request(stick, timeout) do
    send(stick, {:request, self()})
    receive do
      :granted ->
        :ok
    after
      timeout ->
        # IO.puts("Timeout!")
        :no
    end
  end

  def return(stick) do
    send(stick, :return)
  end
  def quit(stick) do
    send(stick, :quit)
  end

end
