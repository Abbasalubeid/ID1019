defmodule Eager do

  #An atom is mapped to a value in the real world, no env needed
  def eval_expr({:atm, id}, _) do {:ok, id} end

  #The variable has to be mapped in the given enviroment
  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil ->
	      IO.puts("variable binding for #{id} not present")
        :error

      {_, str} ->
        {:ok, str}
    end
  end

  #Compound expression, evaluate the first variable and then the other,
  #only if the first is != error/bottoms
  def eval_expr({:cons, var1, var2}, env) do
    case eval_expr(var1, env) do
      :error ->
        :error

      {:ok, val1} ->
        case eval_expr(var2, env) do
          :error ->
            :error
          {:ok, val2} ->
            {:ok, {val1 , val2}}
        end
    end
  end

  #Matching an atom to its corresponding data structure gives a match
  def eval_match({:atm, a}, a, env) do {:ok, env} end

  #A don't care always gives a match
  def eval_match(:ignore, _, env) do {:ok, env} end

  #Matching a variable with a structure can give different results
  def eval_match({:var, v}, str, env) do
    case Env.lookup(v, env) do
      nil ->
        {:ok, Env.add(v, str, env)}
      #The exact same va
      {^v, ^str} ->
        {:ok, env}

      #Anything else gives a wrong env
      {_, _} ->
        :fail
    end
  end

  #Match the first expression
  def eval_match({:cons, var1, var2}, {s1, s2}, env) do
    case eval_match(var1, s1, env) do
      :fail ->
        :fail
      #Match the second expression with the new env
      {:ok, env} ->
        eval_match(var2, s2, env)
    end
  end





end
