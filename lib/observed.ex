defmodule Observed do
  def heavy(n) do
    Enum.reduce(1..n, 0, fn x, acc -> :math.sqrt(x) + acc end)
  end
end
