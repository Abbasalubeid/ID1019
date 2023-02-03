defmodule Eager do

  #An atom is mapped to a value in the real world, no env needed
  def eval_expr({:atm, id}, _) do {:ok, id} end

  #The variable has to be mapped in the given enviroment
  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil ->
	      IO.puts("Nothing is mapped to #{id}")
        :error

      {_, str} ->
        {:ok, str}
    end
  end

  #Compound expression, evaluate the first variable and then the other,
  #only if the first is != error/bottoms
  def eval_expr({:cons, he, te}, env) do
    case eval_expr(he, env) do
      :error ->
        :error
      {:ok, hs} ->
        case eval_expr(te, env) do
          :error ->
            :error
          {:ok, ts} ->
            {:ok, {hs , ts}}
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
      #Not only the same pattern, but the exact same values as the parameters
      {^v, ^str} -> {:ok, env}

      #Anything else gives a wrong env
      {_, _} -> :fail
    end
  end

  #Match the first expression
  def eval_match({:cons, hp, tp}, {hs, ts}, env) do
    case eval_match(hp, hs, env) do
      :fail -> :fail

      {:ok, env} -> eval_match(tp, ts, env)
    end
  end

  #If we can not match thr pattern to the structure, we fail
  def eval_match(_, _, _) do
    :fail
  end

  #If it is a variable, add it to the list
  def extract_vars(pattern) do extract_vars(pattern, []) end
  def extract_vars({:atm, _}, vars) do vars end
  def extract_vars(:ignore, vars) do vars end
  def extract_vars({:var, var}, vars) do [var | vars]end
  def extract_vars({:cons, head, tail}, vars) do
    extract_vars(tail, extract_vars(head, vars))
  end


  def eval(seq) do
    # a new environment is created
    eval_seq(seq, Env.new())
  end

  #A new scope is returned without bindings for the variables in the pattern
  def eval_scope(pattern, env) do
    Env.remove(extract_vars(pattern), env)
  end

  #If it is an expression
  def eval_seq([exp], env) do
    eval_expr(exp, env)
  end

  #If it is a pattern matching expression
  def eval_seq([{:match, ptr, exp} | seq], env) do
    case eval_expr(exp, env) do
      :error ->
        :error

      {:ok, str} ->
        env = eval_scope(ptr, env)

        case eval_match(ptr, str, env) do
          :fail ->
            :error

          {:ok, env} ->
            eval_seq(seq, env)
        end
    end
  end



end
