defmodule SseProjects.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SseProjectsWeb.Telemetry,
      SseProjects.Repo,
      {DNSCluster, query: Application.get_env(:sse_projects, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SseProjects.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SseProjects.Finch},
      # Start a worker by calling: SseProjects.Worker.start_link(arg)
      # {SseProjects.Worker, arg},
      # Start to serve requests, typically the last entry
      SseProjectsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SseProjects.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SseProjectsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
