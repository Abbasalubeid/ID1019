defmodule Deriv do

  #Literals and expressions
  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div, expr(), expr()}
  | {:exp, expr(), literal()}
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
    e = {:ln, {:add, {:mul, {:num, 5}, {:var, :x}}, {:num, 3}}}

    #Derive with respect to x
    d =  deriv(e, :x)

    IO.write("Derivative --> #{pretty_print(d)}\n")
    IO.write("Simplified --> #{pretty_print(simplify(d))}\n")
  end

  def test_div() do

    e = {:div, 1, {:mul, {:num, 4}, {:var, :x}}}

    #Derive with respect to x
    d =  deriv(e, :x)

    IO.inspect(d)

    IO.write("Derivative --> #{pretty_print(d)}\n")
    IO.write("Simplified --> #{pretty_print(simplify(d))}\n")
  end

  def test_div2() do

    e = {:div, 1, {:exp, {:var, :x}, {:num, 2}}}

    #Derive with respect to x
    d =  deriv(e, :x)

    IO.inspect(d)

    IO.write("Derivative --> #{pretty_print(d)}\n")
    IO.write("Simplified --> #{pretty_print(simplify(d))}\n")
  end

  def test_sqrt() do

    e = {:sqrt, {:var, :x}}

    #Derive with respect to x
    d =  deriv(e, :x)

    IO.inspect(d)

    IO.write("Derivative --> #{pretty_print(d)}\n")
    IO.write("Simplified --> #{pretty_print(simplify(d))}\n")
  end

  def test_sin() do

    e = {:sin, {:var, :x}}

    #Derive with respect to x
    d =  deriv(e, :x)

    IO.inspect(d)

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

  #f(x) = x^n --> f´(x) = n * x^n - 1
  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1}}},
      deriv(e, v)
    }
  end

  #If the expression in the denominator has a power higher than one
  def deriv({:div, 1, {:exp, e, {:num, n}}}, v) do  deriv({:exp, e, {:num, -n}}, v) end

  #f(x) = 1/x <--> f(x) = x^-1 --> f´(x) = -x^-2 which is -1/x^2
  def deriv({:div, 1, e}, v) do  deriv({:exp, e, {:num, -1}}, v) end

  #f(x) = ln(x) --> f'(x) = 1/x & f´(g(x)) = f´(g(x)) * g´(x) (chain rule if x is an expression instead of a variable)
  def deriv({:ln, e}, v) do {:mul, {:div, {:num, 1}, e}, deriv(e, v)} end

  #f(x) = √x <--> f(x) = x^1/2 --> f´(x) = 1/2 * x ^ -1/2
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

  #Undefined case
  # def simplify_div(_, {:num, 0}) do nil

  def simplify_div(e, {:num, 1}) do e end
  def simplify_div(e, e) do 1 end
  def simplify_div({:num, n1}, {:num, n2}) do {:num, n1 / n2} end
  def simplify_div(e1, e2) do {:div, e1, e2} end


  def pretty_print ({:num, n}) do "#{n}" end
  def pretty_print ({:var, v}) do "#{v}" end
  def pretty_print ({:add, e1, e2}) do "(#{pretty_print(e1)} + #{pretty_print(e2)})" end
  def pretty_print ({:mul, e1, e2}) do "#{pretty_print(e1)} * #{pretty_print(e2)}" end
  def pretty_print ({:exp, e1, e2}) do "(#{pretty_print(e1)} ^ (#{pretty_print(e2)}))" end
  def pretty_print ({:div, e1, e2}) do "(#{pretty_print(e1)} / #{pretty_print(e2)})" end
  def pretty_print ({:sin, e}) do "sin(#{pretty_print(e)})" end
  def pretty_print ({:cos, e}) do "cos(#{pretty_print(e)})" end

end
