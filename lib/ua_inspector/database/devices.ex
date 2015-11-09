defmodule UAInspector.Database.Devices do
  @moduledoc """
  UAInspector device information database.
  """

  use UAInspector.Database

  alias UAInspector.Util

  # files ordered according to
  # https://github.com/piwik/device-detector/blob/master/DeviceDetector.php
  # to prevent false detections
  @source_base_url "https://raw.githubusercontent.com/piwik/device-detector/master/regexes/device"
  @sources         [
    { "hbbtv",   "devices.televisions.yml",           "#{ @source_base_url }/televisions.yml" },
    { "regular", "devices.consoles.yml",              "#{ @source_base_url }/consoles.yml" },
    { "regular", "devices.car_browsers.yml",          "#{ @source_base_url }/car_browsers.yml" },
    { "regular", "devices.cameras.yml",               "#{ @source_base_url }/cameras.yml" },
    { "regular", "devices.portable_media_player.yml", "#{ @source_base_url }/portable_media_player.yml" },
    { "regular", "devices.mobiles.yml",               "#{ @source_base_url }/mobiles.yml" }
  ]

  def store_entry({ brand, data }, type) do
    data    = Enum.into(data, %{})
    models  = parse_models(data)

    %{
      brand:  brand,
      models: models,
      device: data["device"],
      regex:  Util.build_regex(data["regex"]),
      type:   type
    }
  end

  defp parse_models(data) do
    device = data["device"]

    if data["model"] do
      [%{
        brand:  nil,
        device: device,
        model:  data["model"],
        regex:  Util.build_regex(data["regex"])
      }]
    else
      Enum.map(data["models"], fn(model) ->
        model = Enum.into(model, %{})

        %{
          brand:  model["brand"],
          device: model["device"] || device,
          model:  model["model"],
          regex:  Util.build_regex(model["regex"])
        }
      end)
    end
  end
end
