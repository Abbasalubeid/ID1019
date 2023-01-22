defmodule Deriv do

  #Literals and expressions
  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div, expr(), expr()}
  | {:exp, expr(), literal()}
  | {:neg, expr()}
  | {:ln, expr()}
  | {:sqrt, expr()}
  | {:sin, expr()}
  | {:cos, expr()}

  def test_add() do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}
        }
    #Derive with respect to x
    d =  deriv(e, :x)
    x = 5
    c = calc(d, :x, x)
    IO.write("Expression --> #{pretty_print(e)}\n")
    IO.write("Derivative --> #{pretty_print(d)}\n")
    IO.write("Simplified --> #{pretty_print(simplify(d))}\n")
    IO.write("Calculated when x = #{x} --> #{pretty_print(simplify(c))}\n")
  end

  def test_mul() do
    e = {:mul, {:var, :x}, {:num, 4}}
    #Derive with respect to x
    d =  deriv(e, :x)
    x = 5
    c = calc(d, :x, x)
    IO.write("Expression --> #{pretty_print(e)}\n")
    IO.write("Derivative --> #{pretty_print(d)}\n")
    IO.write("Simplified --> #{pretty_print(simplify(d))}\n")
    IO.write("Calculated when x = #{x} --> #{pretty_print(simplify(c))}\n")
  end

  def test_exp() do
    e =  {:mul, {:num, 4}, {:exp, {:var, :x}, {:num, -1}}}

    #Derive with respect to x
    d =  deriv(e, :x)
    x = 5
    c = calc(d, :x, x)
    IO.write("Expression --> #{pretty_print(e)}\n")
    IO.write("Derivative --> #{pretty_print(d)}\n")
    IO.write("Simplified --> #{pretty_print(simplify(d))}\n")
    IO.write("Calculated when x = #{x} --> #{pretty_print(simplify(c))}\n")
  end

  def test_ln() do
    # e = {:ln, {:num, 5}}  Check, gives 0
    # e = {:ln, {:var, :y}} Check, gives 0
    # e = {:ln, {:var, :x}} Check, gives 1/x
    # e = {:ln, {:mul, {:num, 5}, {:var, :x}}} Check, gives 1/x
    # e = {:ln, {:add, {:num, 5}, {:var, :x}}} Check, gives 1/(5+x)
    e = {:ln, {:add, {:mul, {:num, 5}, {:var, :x}}, {:num, 3}}}

    #Derive with respect to x
    d =  deriv(e, :x)

    IO.write("Derivative --> #{pretty_print(d)}\n")
    IO.write("Simplified --> #{pretty_print(simplify(d))}\n")
  end

  def test_div() do
    # e = {:div, 1, {:exp, {:num, 4}, {:num, 2}}} Check, gives 0
    # e = {:div, 1, {:var, :y}} Check, gives 0
    # e = {:div, 1, {:num, 4}}  Check, gives 0
    # e = {:div, 1, {:add, {:num, 4}, {:var, :x}}} Check, gives -1/(4 + x)^ 2
    e = {:div, 1, {:mul, {:num, 4}, {:var, :x}}}

    #Derive with respect to x
    d =  deriv(e, :x)

    IO.inspect(d)

    IO.write("Derivative --> #{pretty_print(d)}\n")
    IO.write("Simplified --> #{pretty_print(simplify(d))}\n")
  end

  def test_sqrt() do
    # e = {:sqrt, {:var, :x}} Check, gives 1/2√x
    # e = {:sqrt, {:add, {:num, 3}, {:var, :x}}} Check, gives1/2√(3+x)
    # e = {:sqrt, {:num, 5}} Check, gives 0
    e = {:sqrt, {:mul, {:num, 3}, {:var, :x}}}

    #Derive with respect to x
    d =  deriv(e, :x)

    IO.inspect(d)

    IO.write("Derivative --> #{pretty_print(d)}\n")
    IO.write("Simplified --> #{pretty_print(simplify(d))}\n")
  end

  def test_sin() do
    # e = {:sin, {:var, :x}} Check, gives cos(x)
    # e = {:sin, {:var, :y}} Check, gives 0
    # e = {:sin, {:num, 3}}  Check, gives 0
    # e = {:sin, {:add, {:num, 3}, {:var, :x}}} Check, gives cos(3 + x)
    e = {:sin, {:mul, {:num, 3}, {:var, :x}}}

    #Derive with respect to x
    d =  deriv(e, :x)

    IO.write("Derivative --> #{pretty_print(d)}\n")
    IO.write("Simplified --> #{pretty_print(simplify(d))}\n")
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

  #f´(u^n) = n * u^n - 1 * u´ (General power rule)
  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1}}},
      deriv(e, v)
    }
  end

  #f(x) = 1/u(x) --> f´(x) = - u´(x)/u(x)^2 (Reciprocal rule)
  def deriv({:div, 1, e}, v) do {:neg, {:div, deriv(e, v), {:exp, e, {:num, 2}}}} end

  #f(x) = ln(x) --> f'(x) = 1/x & f´(g(x)) = f´(g(x)) * g´(x) (chain rule if x is an expression instead of a variable)
  def deriv({:ln, e}, v) do {:mul, {:div, {:num, 1}, e}, deriv(e, v)} end

  #f(x) = √x <--> f(x) = x^1/2 --> f´(x) = 1/2 * x ^ -1/2, uses the chain rule in the definition of the exponent derivative above
  def deriv({:sqrt, e}, v) do deriv({:exp, e, {:num, 1/2}}, v) end

  #f(x) = sin(x) --> f´(x) = cos(x) & f´(g(x)) = f´(g(x)) * g´(x) (chain rule if x is an expression instead of a variable)
  def deriv({:sin, e}, v) do {:mul, {:cos, e}, deriv(e, v)} end


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

  def simplify({:neg, e}) do
    simplify_neg(simplify(e))
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
  def simplify_exp(e, {:num, 0.5}) do {:sqrt, e} end
  def simplify_exp(e, {:num, -0.5}) do {:div, {:num,  1}, {:sqrt, e}} end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1,n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  def simplify_neg({:neg, {:num, 0}}) do {:num, 0} end
  def simplify_neg({:num, n}) do {:neg, n} end
  def simplify_neg(e) do {:neg, e} end

  #Undefined case
  # def simplify_div(_, {:num, 0}) do nil

  def simplify_div({:num, 0}, _) do {:num, 0} end
  def simplify_div(e, {:num, 1}) do e end
  def simplify_div(e, e) do 1 end
  def simplify_div({:num, n1}, {:num, n2}) do {:num, n1 / n2} end
  def simplify_div(e1, e2) do {:div, e1, e2} end

  def pretty_print ({:num, n}) do "#{n}" end
  def pretty_print ({:var, v}) do "#{v}" end
  def pretty_print ({:add, e1, e2}) do "(#{pretty_print(e1)} + #{pretty_print(e2)})" end
  def pretty_print ({:mul, e1, e2}) do "#{pretty_print(e1)} * #{pretty_print(e2)}" end
  def pretty_print ({:exp, e1, e2}) do "(#{pretty_print(e1)}) ^ #{pretty_print(e2)}" end
  def pretty_print ({:div, e1, e2}) do "(#{pretty_print(e1)} / #{pretty_print(e2)})" end
  def pretty_print ({:sqrt, e}) do "√(#{pretty_print(e)})" end
  def pretty_print ({:sin, e}) do "sin(#{pretty_print(e)})" end
  def pretty_print ({:cos, e}) do "cos(#{pretty_print(e)})" end
  def pretty_print ({:neg, e}) do "-#{pretty_print(e)}" end

end
