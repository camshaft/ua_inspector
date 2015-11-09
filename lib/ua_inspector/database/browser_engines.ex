defmodule UAInspector.Database.BrowserEngines do
  @moduledoc """
  UAInspector browser engine information database.
  """

  use UAInspector.Database

  alias UAInspector.Util

  @source_base_url "https://raw.githubusercontent.com/piwik/device-detector/master/regexes/client"
  @sources         [{ "", "browser_engines.yml", "#{ @source_base_url }/browser_engine.yml" }]

  def store_entry(data, _type) do
    data    = Enum.into(data, %{})

    %{
      name:  data["name"],
      regex: Util.build_regex(data["regex"])
    }
  end
end
