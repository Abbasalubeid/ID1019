defmodule Deriv do

  #Literals and expressions
  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}

  def test() do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}
        }
    #Derive with respect to x
   d =  deriv(e, :x)
   prettyPrint(d)
  end

  #Order of the definitions
  #f´(c) = 0
  def deriv({:num, _}, _) do {:num, 0} end

  #f'(x) = 1
  def deriv({:var, v},  v) do {:num, 1} end

  #f´(c) = 0
  def deriv({:var, _}, _) do {:num, 0} end

  #f'(x) + g´(x)
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end

  #f´(x) * g(x) + f(x) * g´(x)
  def deriv({:mul, e1, e2}, v) do
    {:add,
      {:mul, deriv(e1, v), e2},
      {:mul, e1, deriv(e2, v)}}
  end

  def prettyPrint ({:num, n}) do "#{n}" end
  def prettyPrint ({:var, v}) do "#{v}" end
  def prettyPrint ({:add, e1, e2}) do "(#{prettyPrint(e1)} + #{prettyPrint(e2)})" end
  def prettyPrint ({:mul, e1, e2}) do "#{prettyPrint(e1)} * #{prettyPrint(e2)}" end

end
