defmodule TelemetryPlayground.Tracer do
  use GenServer

  def start_link(_opts),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @impl true
  def init(_state) do
    traced_modules = Application.get_env(:telemetry_playground, :traced_modules, [])

    Enum.each(traced_modules, fn mod ->
      :code.load_file(mod)
      :erlang.trace_pattern({mod, :_, :_}, [{:_, [], [{:return_trace}]}], [:local, :meta])
    end)

    {:ok, %{traced_modules: traced_modules}}
  end

  @impl true
  def handle_info({:trace_ts, _pid, :call, {mod, fun, _args}, _ts}, state) do
    if fun in [:__info__, :module_info] do
      IO.inspect({:call, mod, fun})
    end

    {:noreply, state}
  end

  def handle_info({:trace_ts, _pid, :return_from, {mod, fun, arity}, result, _ts}, state) do
    if fun in [:__info__, :module_info] do
      IO.inspect({mod, fun, arity, result}, label: "FUNCTION RETURNED")
    end

    {:noreply, state}
  end

  def handle_info({:trace, _pid, :call, {mod, fun, _args}}, state) do
    if fun in [:__info__, :module_info] do
      IO.inspect({:call, mod, fun})
    end

    {:noreply, state}
  end

  def handle_info({:trace, _pid, :return_from, {mod, fun, arity}, result}, state) do
    if fun in [:__info__, :module_info] do
      IO.inspect({mod, fun, arity, result}, label: "FUNCTION RETURNED")
    end

    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
