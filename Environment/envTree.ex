defmodule EnvTree do
  # @type leaf() :: {:leaf, value}
  # @type node() :: {:node, value, left, right}

  # treeExample() :: {:node, :rootValue, {:leaf, :b} {:leaf, :c}}

  def new() do nil end

  def member(_, :nil) do :no end
  def member(elem, {:leaf, elem}) do :yes end
  def member(_, {:leaf, _}) do :no end
  def member(elem, {:node, elem, _, _}) do :yes end
  def member(elem, {:node, _, left, right}) do
    case member(elem, left) do
      :yes -> :yes
      :no -> case member(elem, right) do
              :yes -> :yes
              :no -> :no
             end
    end
  end

  #Adding a key-value pair to an empty tree creates a new tree with the pair as the root
  def add(nil, key, value) do
    {:node, key, value, nil, nil}
  end

  #If the key exists in the tree, return a new modified tree with a new value for the key
  def add({:node, key, _, left, right}, key, value) do
    {:node, key, value, left, right}
  end

  #We know that key != k since the pattern above would get a match otherwise
  def add({:node, k, v, left, right}, key, value) when key < k do
    {:node, k, v, add(left, key, value), right}
  end

  #Same as above but when key > k
  def add({:node, k, v, left, right}, key, value) do
    {:node, k, v, left, add(right, key, value)}
  end

  def lookup(nil, _) do nil end

  #Found
  def lookup({:node, key, value, _, _}, key) do value end

  #The tree is sorted so if the key is less then the current root, go left
  def lookup({:node, k, _, left, _}, key) when key < k do lookup(left, key) end

  #If none of the above matches, key is to the right
  def lookup({:node, _, _, _, right}, key) do lookup(right, key) end

  def remove(nil, _) do :nil end

  #If the key to remove is the root and there is no left node
  #Remove the root and keep right
  def remove({:node, key, _, nil, right}, key) do right end

  #Same as above, but if there is no right node
  def remove({:node, key, _, left, nil}, key) do left end

  #If the root has left and right
  #Choose a successor, in this case the node with the minimum value
  #from the right tree.
  def remove({:node, key, _, left, right}, key) do
    minimum_from_right = leftmost(right)
    {:node, elem(minimum_from_right, 0), elem(minimum_from_right, 1), left, elem(minimum_from_right, 2)}
  end

  def remove({:node, k, v, left, right}, key) when key < k do
  {:node, k, v, remove(left, key), right}
  end

  def remove({:node, k, v, left, right}, key) do
  {:node, k, v, left, remove(right, key)}
  end

  #When we are at the leftmost node
  def leftmost({:node, key, value, nil, rest}) do
    {key, value, rest}
  end

  def leftmost({:node, k, v, left, right}) do
    last = leftmost(left)
    {elem(last, 0), elem(last, 1), {:node, k, v, elem(last, 2), right}}
  end

  def bench(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)
    list = Enum.reduce(seq, add(:nil, :rand.uniform(i), :value), fn(e, list) -> add(list, e, :foo)end)
    seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)
    start_time = :erlang.monotonic_time()
    Enum.each(seq, fn(e) ->
    add(list, e, :foo)
              end)
    end_time = :erlang.monotonic_time()
    add_time = end_time - start_time

    start_time = :erlang.monotonic_time()
    Enum.each(seq, fn(e) ->
    lookup(list, e)
            end)
    end_time = :erlang.monotonic_time()
    lookup_time = end_time - start_time

    start_time = :erlang.monotonic_time()
    Enum.each(seq, fn(e) ->
    remove(list, e)
            end)
    end_time = :erlang.monotonic_time()
    remove_time = end_time - start_time

    {i, add_time, lookup_time, remove_time}
  end

  def bench(n) do
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    :io.format("# benchmark with ~w operations, time per operation in ns\n", [n])
    :io.format("~6.s~13.s~17.s~16.s\n", ["n", "add", "lookup", "remove"])
    Enum.each(ls, fn (i) ->
    {i, tla, tll, tlr} = bench(i, n)
    :io.format("~6.w &~12.2f & ~12.2f & ~12.2f \\\\ \n", [i, tla/n, tll/n, tlr/n])
            end)
  end

end
