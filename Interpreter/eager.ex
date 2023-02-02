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

  #If it is a tuple, check the first variable and then the other,
  #only if the first is != error
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


end
