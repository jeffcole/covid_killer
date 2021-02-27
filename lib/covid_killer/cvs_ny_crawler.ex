defmodule CovidKiller.CVSNYCrawler do
  use CovidKiller.CrawlServer

  @location "bethpage"

  def handle_info(:crawl, state) do
    {:ok, session} = Wallaby.start_session()

    try do
      availability =
        session
        |> Browser.visit("https://www.cvs.com/vaccine/intake/store/covid-screener/covid-qns")
        |> Browser.find(
          Query.xpath(~s{//*[@type="radio"]/following-sibling::label[contains(text(), "No")]},
            count: :any
          ),
          fn radio_labels ->
            Enum.each(radio_labels, fn r -> r |> delay() |> Element.click() end)
          end
        )
        |> delay(60000)
        |> Browser.click(Query.button("Continue"))
        |> Browser.click(
          Query.xpath(~s{//*[@type="radio"]/following-sibling::label[contains(text(), "start")]})
        )
        |> delay()
        |> Browser.click(Query.button("Continue"))
        |> Browser.click(Query.option("New York"))
        |> Browser.fill_in(Query.text_field("age"), with: "75")
        |> Browser.click(
          Query.xpath(~s{//*[@type="radio"]/following-sibling::label[contains(text(), "65")]})
        )
        |> Browser.click(Query.css(~s{[type="checkbox"]}))
        |> delay()
        |> Browser.click(Query.button("Confirm"))
        |> delay()
        |> Browser.click(Query.button("Start"))
        |> delay()
        |> Browser.send_keys(Query.text_field("Search"), ["#{@location}, ny", :enter])
        |> Element.text()
        |> IO.inspect()

      if !String.contains?(availability, "sorry") do
        # "Appointments available at CVS #{@location}. "
        # |> String.duplicate(3)
        # |> CrawlServer.notify()

        CrawlServer.log_warn(__MODULE__, availability)
      else
        CrawlServer.log_info(__MODULE__, availability)
      end

      # CrawlServer.schedule()

      {:noreply, state}
    after
      Browser.take_screenshot(session)

      Wallaby.end_session(session)
    end
  end

  defp delay(arg, duration \\ 3000) do
    :timer.sleep(duration)

    Browser.move_mouse_by(arg, 100, 100)

    arg
  end
end
