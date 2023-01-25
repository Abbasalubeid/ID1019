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

  #New structure based on the one we are adding
  def add({:node, k, v, left, right}, key, value) do
    {:node, k, v, left, add(right, key, value)}
  end

  def lookup(_, :nil) do :not_found end

  def lookup(key, {:node, key, value, _, _}) do  value end

  #Since the key is sorted, we can choose to go left or right depending on 'key'
  def lookup(key, {:node, k, _, left, right}) do
    if key < k do
      lookup(key, left)
    else
      lookup(key, right)
    end
  end

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

end
