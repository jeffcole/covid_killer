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
        CrawlServer.notify("Appointments available at #{@location}.")

        CrawlServer.log_warn(availability, __MODULE__)
      else
        CrawlServer.log_info(availability, __MODULE__)
      end

      CrawlServer.schedule()

      {:noreply, state}
    after
      Wallaby.end_session(session)
    end
  end
end
