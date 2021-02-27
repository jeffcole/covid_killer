defmodule CovidKiller.CrawlServer do
  require Logger

  @voice "Samantha"

  defmacro __using__(_) do
    quote do
      use GenServer, restart: :temporary

      alias Wallaby.{
        Browser,
        Element,
        Query
      }

      alias CovidKiller.CrawlServer

      def start_link(_state) do
        GenServer.start_link(__MODULE__, nil)
      end

      def init(_state) do
        CrawlServer.schedule()

        {:ok, nil}
      end
    end
  end

  def schedule do
    # Process.send_after(self(), :crawl, 30_000)
    Process.send_after(self(), :crawl, 100)
  end

  def notify(message) do
    # TODO Play William Tell Overture finale, trigger Rube Goldberg machine,
    # Bat Signal, etc.
    System.cmd("say", ["-v", "#{@voice}", message])
  end

  def log_info(module, message) do
    module
    |> get_name()
    |> (&Logger.info("#{&1}: #{message}")).()
  end

  def log_warn(module, message) do
    module
    |> get_name()
    |> (&Logger.warn("#{&1}: ******************** #{message} ********************")).()
  end

  defp get_name(module) do
    module
    |> Module.split()
    |> List.last()
  end
end
