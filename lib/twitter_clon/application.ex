defmodule TwitterClon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TwitterClon.Repo,
      # Start the Telemetry supervisor
      TwitterClonWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TwitterClon.PubSub},
      # Start the Endpoint (http/https)
      TwitterClonWeb.Endpoint
      # Start a worker by calling: TwitterClon.Worker.start_link(arg)
      # {TwitterClon.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TwitterClon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TwitterClonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
