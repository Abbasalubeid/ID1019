defmodule Chopstick do

  def start do
    stick = spawn_link(fn -> available() end)
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
  def request(stick) do
    #Send the current process and wait for a confirmation msg
    send(stick, {:request, self()})
    receive do
      :granted -> :ok
    end
  end
  def return(stick) do
    send(stick, {:return, self()})
  end
  def quit(stick) do
    send(stick, {:quit, self()})
  end

end
