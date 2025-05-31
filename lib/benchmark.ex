defmodule Benchmark do
  @concurrency 100
  @calls_per_user 10
  @size 1000

  defp simulate(module, fun, concurrency, calls_per_user, size, max_concurrency) do
    jobs = for _ <- 1..concurrency, _ <- 1..calls_per_user, do: :job

    jobs
    |> Task.async_stream(
      fn _ ->
        apply(module, fun, [size])
      end,
      max_concurrency: max_concurrency,
      timeout: 10_000
    )
    |> Stream.run()
  end

  def run_benchmark do
    max_conc = 8

    Benchee.run(
      %{
        "traced" => fn ->
          simulate(Observed, :heavy, @concurrency, @calls_per_user, @size, max_conc)
        end,
        "plain" => fn ->
          simulate(Plain, :heavy, @concurrency, @calls_per_user, @size, max_conc)
        end
      },
      time: 5,
      memory_time: 2
    )
  end
end
