defmodule CovidKiller.CrawlServer do
  use GenServer

  def start_link(_state) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_state) do
    schedule()

    {:ok, nil}
  end

  def handle_info(:crawl, state) do
    schedule()

    {:noreply, state}
  end

  defp schedule do
    Process.send_after(self(), :crawl, 30_000)
  end
end
