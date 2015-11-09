defmodule UAInspector.Database.VendorFragments do
  @moduledoc """
  UAInspector vendor fragment information database.
  """

  use UAInspector.Database

  alias UAInspector.Util

  @source_base_url "https://raw.githubusercontent.com/piwik/device-detector/master/regexes"
  @sources         [{ "", "vendorfragments.yml", "#{ @source_base_url }/vendorfragments.yml" }]

  @ets_counter :vendor_fragments
  @ets_table   :ua_inspector_database_vendor_fragments

  def store_entry({ brand, regexes }, _type) do
    regexes = regexes |> Enum.map( &Util.build_regex/1 )

    %{
      brand:   brand,
      regexes: regexes
    }
  end
end
