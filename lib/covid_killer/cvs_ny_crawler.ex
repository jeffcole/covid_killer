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
        "Appointments available at CVS #{@location}. "
        |> String.duplicate(3)
        |> CrawlServer.notify()

        CrawlServer.log_warn(__MODULE__, availability)
      else
        CrawlServer.log_info(__MODULE__, availability)
      end

      CrawlServer.schedule()

      {:noreply, state}
    after
      Wallaby.end_session(session)
    end
  end
end
