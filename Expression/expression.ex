defmodule Expression do

@type literal() :: {:num, n}
                 | {:var, a}
                 | {:q, n, m}

@type expr() :: {:add, expr(), expr()}
              | {:sub, expr(), expr()}
              | {:mul, expr(), expr()}
              | {:div, expr(), expr()}
              | literal()
end
