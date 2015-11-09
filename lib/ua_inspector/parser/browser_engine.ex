defmodule UAInspector.Parser.BrowserEngine do
  @moduledoc """
  UAInspector browser engine information parser.
  """

  use UAInspector.Parser

  alias UAInspector.Database.BrowserEngines

  def parse(ua), do: parse(ua, BrowserEngines.list)


  defp parse(_,  []),                             do: :unknown
  defp parse(ua, [ entry | database ]) do
    if Regex.match?(entry.regex, ua) do
      entry.name
    else
      parse(ua, database)
    end
  end
end
