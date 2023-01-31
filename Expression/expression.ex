defmodule Expression do

  # @type literal() :: {:num, n}
  #                 | {:var, a}
  #                 | {:q, n, m}

  # # @type expr() :: {:add, expr(), expr()}
  # #               | {:sub, expr(), expr()}
  # #               | {:mul, expr(), expr()}
  # #               | {:div, expr(), expr()}
  # #               | literal()

  #If it is just a number, no variable mapping is needed
  def eval({:num, n}, _) do n end
  #Get the value of the variable
  def eval({:var, v}, env) do Map.get(env, v) end

  def eval({:add, e1, e2}, env) do
    add(eval(e1, env), eval(e2, env))
  end

  def add(e1, e2) do
    e1 + e2
  end


end
