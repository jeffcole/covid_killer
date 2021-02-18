# CovidKiller

This is a small app for periodically checking websites that host Covid vaccination appointment availability, and notifying when availability opens up. It uses [Wallaby](https://hexdocs.pm/wallaby/readme.html) for browser automation.

## Setup

Install Erlang and Elixir. Instructions can be found on the Elixir [installation page](https://elixir-lang.org/install.html). The project contains a [`.tool-versions`](https://github.com/jeffcole/covid_killer/blob/master/.tool-versions) file for use with [asdf](https://asdf-vm.com/).

Install [ChromeDriver](https://chromedriver.chromium.org/). Mac users with Homebrew can install with:

```sh
brew install chromedriver
```

In the cloned project directory, run:

```sh
mix deps.get
# Dependency downloads...

mix run --no-halt
# Compilation and application start...
```

Accept installation of Hex and Rebar if prompted.

# Customization

To tailor the application to your use case, implement a [`CrawlServer`](https://github.com/jeffcole/covid_killer/blob/master/lib/covid_killer/crawl_server.ex) from the patterns in [`CVSNYCrawler`](https://github.com/jeffcole/covid_killer/blob/master/lib/covid_killer/cvs_ny_crawler.ex) and [`NYSCrawler`](https://github.com/jeffcole/covid_killer/blob/master/lib/covid_killer/nys_crawler.ex). Then reference them as children of the [`Application`](https://github.com/jeffcole/covid_killer/blob/master/lib/covid_killer/application.ex).

See the Wallaby [`Browser`](https://hexdocs.pm/wallaby/Wallaby.Browser.html), [`Query`](https://hexdocs.pm/wallaby/Wallaby.Query.html), and [`Element`](https://hexdocs.pm/wallaby/Wallaby.Element.html) APIs for info on how to work with the page.
