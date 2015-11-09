defmodule UAInspector do
  @moduledoc """
  UAInspector Application
  """

  use Application

  alias UAInspector.Config
  alias UAInspector.Databases
  alias UAInspector.ShortCodeMaps

  def start(_type, _args) do
    options  = [ strategy: :one_for_one, name: UAInspector.Supervisor ]

    sup = Supervisor.start_link([], options)
    :ok = Config.database_path |> Databases.load()
    :ok = Config.database_path |> ShortCodeMaps.load()

    sup
  end


  @doc """
  Checks if a user agent is a known bot.
  """
  @spec bot?(String.t) :: boolean
  defdelegate bot?(ua), to: UAInspector.Parser

  @doc """
  Parses a user agent.
  """
  @spec parse(String.t) :: map
  defdelegate parse(ua), to: UAInspector.Parser

  @doc """
  Parses a user agent without checking for bots.
  """
  @spec parse_client(String.t) :: map
  defdelegate parse_client(ua), to: UAInspector.Parser
end
