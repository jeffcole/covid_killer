defmodule CovidKiller.CrawlServer do
  use GenServer

  def start_link(_state) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_state) do
    schedule_initial()

    {:ok, nil}
  end

  def handle_info(:crawl, state) do
    # schedule_next()

    {:noreply, state}
  end

  defp schedule_initial do
    Process.send_after(self(), :crawl, 1_000)
  end

  defp schedule_next do
    Process.send_after(self(), :crawl, 30_000)
  end
end
