defmodule Expression do

  #If it is just a number, no variable mapping is needed
  def eval({:num, n}, _) do n end
  #Get the value of the variable
  def eval({:var, v}, env) do Map.get(env, v) end

  def eval({:add, e1, e2}, env) do
    add(eval(e1, env), eval(e2, env))
  end

  def eval({:sub, e1, e2}, env) do
    sub(eval(e1, env), eval(e2, env))
  end

  def eval({:mul, e1, e2}, env) do
    mul(eval(e1, env), eval(e2, env))
  end

  def eval({:div, e1, e2}, env) do
    divide(eval(e1, env), eval(e2, env))
  end

  def eval({:q, n1, n2}, _) do {:q, n1, n2} end


  def add({:q, n1, m1}, {:q, n2, m2}) do
    temp1 = m1 * m2
    temp2 = (m1 * n2) + (m2 * n1)
    denominator = temp1 / Integer.gcd(temp1, temp2)
    numerator = temp2 / Integer.gcd(temp1, temp2)
    denominator = round(denominator)
    numerator = round(numerator)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end

  def add({:q, n1, m1}, e) do
    temp1 = m1 * e
    denominator = m1
    numerator = n1 + temp1
    denominator = round(denominator)
    numerator = round(numerator)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end

  def add(e, {:q, n1, m1}) do
    temp1 = m1 * e
    denominator = m1
    numerator = n1 + temp1
    denominator = round(denominator)
    numerator = round(numerator)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end

  def add(e1, e2) do
    e1 +  e2
  end

  def sub({:q, n1, m1}, {:q, n2, m2}) do
    temp1 = m1 * m2
    temp2 = (m2 * n1) - (m1 * n2)
    denominator = temp1 / Integer.gcd(temp1, temp2)
    numerator = temp2 / Integer.gcd(temp1, temp2)
    denominator = round(denominator)
    numerator = round(numerator)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end

  def sub(e, {:q, n1, m1}) do
    temp1 = m1 * e
    denominator = m1
    numerator = temp1 - n1
    denominator = round(denominator)
    numerator = round(numerator)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end

  def sub({:q, n1, m1}, e) do
    temp1 = m1 * e
    denominator = m1
    numerator = n1 - temp1
    denominator = round(denominator)
    numerator = round(numerator)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end


  def sub(e1, e2) do
    e1 - e2
  end

  def mul({:q, n1, m1}, {:q, n2, m2}) do
    temp1 = n1 * n2
    temp2 = m1 * m2

    denominator = temp2 / Integer.gcd(temp1, temp2)
    numerator = temp1 / Integer.gcd(temp1, temp2)

    denominator = round(denominator)
    numerator = round(numerator)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end

  def mul({:q, n1, m1}, e) do
    temp1 = n1 * e
    denominator = m1 / Integer.gcd(temp1, m1)
    numerator = temp1 / Integer.gcd(temp1, m1)

    denominator = round(denominator)
    numerator = round(numerator)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end

  def mul(e, {:q, n1, m1}) do
    temp1 = n1 * e
    denominator = m1 / Integer.gcd(temp1, m1)
    numerator = temp1 / Integer.gcd(temp1, m1)

    denominator = round(denominator)
    numerator = round(numerator)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end

  def mul(e1, e2) do
    e1 * e2
  end

  def divide({:q, n1, m1}, {:q, n2, m2}) do
    temp1 = n1 * m2
    temp2 = m1 * n2

    denominator = temp2 / Integer.gcd(temp1, temp2)
    numerator = temp1 / Integer.gcd(temp1, temp2)

    denominator = round(denominator)
    numerator = round(numerator)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end

  def divide({:q, n1, m1}, e) do
    temp2 = m1 * e

    denominator = temp2 / Integer.gcd(n1, temp2)
    numerator = n1 / Integer.gcd(n1, temp2)

    denominator = round(denominator)
    numerator = round(numerator)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end

  def divide(e, {:q, n1, m1}) do
    temp2 = m1 * e

    denominator = n1 / Integer.gcd(temp2, n1)
    numerator = temp2 / Integer.gcd(n1, temp2)

    denominator = round(denominator)
    numerator = round(numerator)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end

  def divide(e1, e2) do
    answer = e1 / e2
    if is_integer(answer) do
      answer
    else
      print(e1, e2)
    end
  end

  def print(e1, e2) do
    gcd = Integer.gcd(e1, e2)
    numerator = round(e1/gcd)
    denominator = round(e2/gcd)
    if denominator == 1 do
      IO.puts(numerator)
    else
      IO.puts("#{numerator} / #{denominator}")
    end
  end


end
