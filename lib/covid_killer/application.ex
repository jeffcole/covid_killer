defmodule CovidKiller.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CovidKiller.CrawlServer
    ]

    opts = [strategy: :one_for_one, name: CovidKiller.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
