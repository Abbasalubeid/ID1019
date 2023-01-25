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

end
