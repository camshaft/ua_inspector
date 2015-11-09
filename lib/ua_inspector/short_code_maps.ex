defmodule UAInspector.ShortCodeMaps do
  @moduledoc """
  Module to coordinate individual parser short code maps.
  """

  alias UAInspector.ShortCodeMap

  @doc """
  Sends a request to load a database to the internal server.
  """
  @spec load(String.t) :: :ok
  def load(nil),  do: :ok
  def load(path) do
    :ok = ShortCodeMap.DeviceBrands.load(path)
    :ok = ShortCodeMap.OSs.load(path)
  end
end
