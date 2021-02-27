defmodule CovidKiller.NYSCrawler do
  use CovidKiller.CrawlServer

  @location "Jones Beach"

  def handle_info(:crawl, state) do
    {:ok, session} = Wallaby.start_session()

    try do
      availability =
        session
        |> Browser.visit("https://am-i-eligible.covid19vaccine.health.ny.gov/")
        |> Browser.find(
          Query.xpath(~s{//*[contains(text(), "#{@location}")]/following-sibling::td[2]})
        )
        |> Element.text()

      if !String.contains?(availability, "No Appointments") do
        "Appointments available at #{@location}. "
        |> String.duplicate(3)
        |> CrawlServer.notify()

        CrawlServer.log_warn(__MODULE__, availability)
      else
        CrawlServer.log_info(__MODULE__, availability)
      end

      # CrawlServer.schedule()

      {:noreply, state}
    after
      Wallaby.end_session(session)
    end
  end
end
