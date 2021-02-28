defmodule CovidKiller.CVSNYCrawler do
  use CovidKiller.CrawlServer

  @location "bethpage"

  def handle_info(:crawl, state) do
    {:ok, session} = Wallaby.start_session()

    try do
      availability =
        session
        |> Browser.visit("https://www.cvs.com/immunizations/covid-19-vaccine")
        |> Browser.find(Query.css(~s{[data-modal="vaccineinfo-NY"]}))
        |> Element.click()
        |> Browser.find(
          Query.xpath(
            ~s{//*[contains(text(), "#{@location}")]/parent::td/following-sibling::td/span}
          )
        )
        |> Element.text()

      if !String.contains?(availability, "Fully") do
        CrawlServer.notify(
          "Appointments available at CVS #{@location}.",
          "https://www.cvs.com/vaccine/intake/store/covid-screener/covid-qns",
          __MODULE__
        )

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
