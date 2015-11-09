defmodule UAInspector.Database.OSs do
  @moduledoc """
  UAInspector operating system information database.
  """

  use UAInspector.Database

  alias UAInspector.Util

  @source_base_url "https://raw.githubusercontent.com/piwik/device-detector/master/regexes"
  @sources         [{ "", "oss.yml", "#{ @source_base_url }/oss.yml" }]

  @ets_counter :oss
  @ets_table   :ua_inspector_database_oss

  def store_entry(data, _type) do
    data    = Enum.into(data, %{})

    %{
      name:    data["name"],
      regex:   Util.build_regex(data["regex"]),
      version: data["version"]
    }
  end
end
