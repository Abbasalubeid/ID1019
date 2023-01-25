defmodule EnvTree do
  # @type leaf() :: {:leaf, value}
  # @type node() :: {:node, value, left, right}

  # treeExample() :: {:node, :rootValue, {:leaf, :b} {:leaf, :c}}

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

  def add({:node, k, v, left, right}, key, value) do
    {:node, k, v, left, add(right, key, value)}
  end

  def lookup(_, :nil) do :not_found end

  def lookup(key, {:node, key, value, _, _}) do {:value, value} end

  def lookup(key, {:node, k, _, left, right}) do
    if key < k do
      lookup(key, left)
    else
      lookup(key, right)
    end
  end

end
