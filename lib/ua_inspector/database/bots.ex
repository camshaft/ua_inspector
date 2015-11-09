defmodule UAInspector.Database.Bots do
  @moduledoc """
  UAInspector bot information database.
  """

  use UAInspector.Database

  alias UAInspector.Util

  @source_base_url "https://raw.githubusercontent.com/piwik/device-detector/master/regexes"
  @sources         [{ "", "bots.yml", "#{ @source_base_url }/bots.yml" }]

  def store_entry(data, _type) do
    data    = Enum.into(data, %{})

    %{
      category: data["category"],
      name:     data["name"],
      producer: producer_info(data["producer"]),
      regex:    Util.build_regex(data["regex"]),
      url:      data["url"]
    }
  end

  defp producer_info(nil), do: nil
  defp producer_info(info) do
    info = Enum.into(info, %{})

    %{ name: info["name"], url: info["url"] }
  end
end
