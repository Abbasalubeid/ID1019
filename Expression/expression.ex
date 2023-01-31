defmodule Expression do


@type expr() :: {:add, expr(), expr()}
              | {:sub, expr(), expr()}
              | {:mul, expr(), expr()}
              | {:div, expr(), expr()}
              | literal()
end
