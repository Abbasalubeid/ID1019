defmodule Deriv do

  #Literals and expressions
  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div, expr(), expr()}
  | {:exp, expr(), literal()}
  | {:ln, expr()}

  def test1() do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}
        }
    #Derive with respect to x
   d =  deriv(e, :x)
   x = 5
   c = calc(d, :x, x)
   IO.write("Expression --> #{print(e)}\n")
   IO.write("Derivative --> #{print(d)}\n")
   IO.write("Simplified --> #{print(simplify(d))}\n")
   IO.write("Calculated when x = #{x} --> #{print(simplify(c))}\n")
  end

  def test2() do
    e = {:add,
          {:exp, {:var, :x}, {:num, 3}},
          {:num, 4}
        }
   #Derive with respect to x
   d =  deriv(e, :x)
   x = 4
   c = calc(d, :x, x)
   IO.write("Expression --> #{print(e)}\n")
   IO.write("Derivative --> #{print(d)}\n")
   IO.write("Simplified --> #{print(simplify(d))}\n")
   IO.write("Calculated when x = #{x} --> #{print(simplify(c))}\n")
  end

  def test3() do
    e = {:ln, {:add, {:var, :x}, {:num, 3}}}

   #Derive with respect to x
    d =  deriv(e, :x)
    #  x = 4
    #  c = calc(d, :x, x)

    #  IO.write("Expression --> #{print(e)}\n")
    #  IO.write("Derivative --> #{print(d)}\n")
    #  IO.write("Simplified --> #{print(simplify(d))}\n")
    #  IO.write("Calculated when x = #{x} --> #{print(simplify(c))}\n")
  end

  #Order of the definitions matter

  #f´(c) = 0
  def deriv({:num, _}, _) do {:num, 0} end

  #f´(x) = 1
  def deriv({:var, v},  v) do {:num, 1} end

  #f´(c) = 0
  def deriv({:var, _}, _) do {:num, 0} end

  #f´(x) + g´(x)
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end

  #f´(x) * g(x) + f(x) * g´(x)
  def deriv({:mul, e1, e2}, v) do
    {:add,
      {:mul, deriv(e1, v), e2},
      {:mul, e1, deriv(e2, v)}}
  end

  #f(x) = x^n --> f´(x) = n * x^n - 1
  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1}}},
      deriv(e, v)
    }
  end

  #f(x) = ln(x) --> f'(x) = 1/x & f´(g(x)) = f´(g(x)) * g´(x) (chain rule if x is an expression instead of a variable)
  def deriv({:ln, e}, v) do {:mul, {:div, 1, e}, deriv(e, v)} end


  #Extra
  def calc({:num, n}, _, _) do {:num, n} end
  def calc({:var, v}, v, n) do {:num, n} end
  def calc({:var, v}, _, _) do {:var, v} end
  def calc({:add, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:mul, e1, e2}, v, n) do
    {:mul, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:exp, e1, e2}, v, n) do
    {:exp, calc(e1, v, n), calc(e2, v, n)}
  end


  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end

  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end

  def simplify({:div, e1, e2}) do
    simplify_div(simplify(e1), simplify(e2))
  end

  #Final simplification, when nothing can be simplified
  def simplify(e) do e end

  def simplify_add({:num, 0}, e) do e end
  def simplify_add(e, {:num, 0}) do e end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e) do e end
  def simplify_mul(e, {:num, 1}) do e end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e, {:num, 1}) do e end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1,n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  def simplify_div(e1, e2) do {:exp, e1, e2} end


  def print ({:num, n}) do "#{n}" end
  def print ({:var, v}) do "#{v}" end
  def print ({:add, e1, e2}) do "(#{print(e1)} + #{print(e2)})" end
  def print ({:mul, e1, e2}) do "#{print(e1)} * #{print(e2)}" end
  def print ({:exp, e1, e2}) do "#{print(e1)} ^ #{print(e2)}" end

end
