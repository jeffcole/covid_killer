defmodule CovidKiller.Application do
  use Application

  @impl true
  def start(_type, _args) do
    {:ok, _} = Application.ensure_all_started(:wallaby)

    children = [
      CovidKiller.CVSNYCrawler
      # CovidKiller.NYSCrawler
    ]

    opts = [
      strategy: :one_for_one,
      name: CovidKiller.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
