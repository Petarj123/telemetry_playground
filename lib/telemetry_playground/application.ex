defmodule TelemetryPlayground.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TelemetryPlaygroundWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:telemetry_playground, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TelemetryPlayground.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TelemetryPlayground.Finch},
      # Start a worker by calling: TelemetryPlayground.Worker.start_link(arg)
      # {TelemetryPlayground.Worker, arg},
      # Start to serve requests, typically the last entry
      TelemetryPlaygroundWeb.Endpoint,
      TelemetryPlayground.Tracer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TelemetryPlayground.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TelemetryPlaygroundWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
