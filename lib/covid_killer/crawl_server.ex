defmodule CovidKiller.CrawlServer do
  use GenServer
  use Hound.Helpers

  require Logger

  def start_link(_state) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_state) do
    schedule()

    {:ok, nil}
  end

  def handle_info(:crawl, state) do
    Hound.start_session()

    navigate_to("https://am-i-eligible.covid19vaccine.health.ny.gov/")

    location = "Jones Beach - Field 3"

    availablity =
      :xpath
      |> find_element("//*[text() = '#{location}']/following-sibling::td[2]")
      |> inner_text()

    Logger.info(availablity)

    if !String.contains?(availablity, "No Appointments") do
      System.cmd("say", ["Appointments available at #{location}"])
    end

    schedule()

    {:noreply, state}
  after
    Hound.end_session()
  end

  defp schedule do
    Process.send_after(self(), :crawl, 30_000)
  end
end
