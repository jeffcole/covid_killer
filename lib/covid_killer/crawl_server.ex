defmodule CovidKiller.CrawlServer do
  require Logger

  @voice "Samantha"

  defmacro __using__(_) do
    quote do
      use GenServer

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
    Process.send_after(self(), :crawl, 30_000)
  end

  def notify(message, uri, module) do
    # TODO Play William Tell Overture finale, trigger Rube Goldberg machine,
    # Bat Signal, etc.
    System.cmd("terminal-notifier", [
      "-title",
      get_name(module),
      "-message",
      message,
      "-open",
      uri
    ])

    message
    |> List.duplicate(3)
    |> Enum.join(" ")
    |> (&System.cmd("say", ["-v", "#{@voice}", &1])).()
  end

  def log_info(message, module) do
    module
    |> get_name()
    |> (&Logger.info("#{&1}: #{message}")).()
  end

  def log_warn(message, module) do
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
