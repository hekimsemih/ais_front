defmodule AisFrontWeb.ShipinfosView do
  use AisFrontWeb, :view
  alias AisFrontWeb.ShipinfosView

  alias AisFront.Core.Shipinfos

  def render("index.json", %{shipinfos: shipinfos}) do
    %{data: render_many(shipinfos, ShipinfosView, "shipinfos.json")}
  end

  def render("show.json", %{shipinfos: shipinfos}) do
    %{data: render_one(shipinfos, ShipinfosView, "shipinfos.json")}
  end

  defp shipinfos_description(shipinfos) do
    "#{Shipinfos.pretty_name!(shipinfos)}, #{Shipinfos.pretty_date!(shipinfos)}"
  end
  defp shipinfos_heading_or_cog(shipinfos) do
    cond do
      heading != 511 -> heading
      cog >= 360.0 -> 0.0
      true -> cog
    end
  end
  @aismap_properties [:mmsi, ]
  def render("shipinfos.json", %{shipinfos: shipinfos}) do
    keys = Map.keys(value)
           |> Enum.filter(& &1 in @aismap_properties)
    Map.take(value, keys)

    %{
      type: "Feature",
      id: shipinfos.mmsi,
      geometry: Geo.JSON.encode!(shipinfos.point),
      geometry_name: "point",
      properties:
    }
    %{mmsi: shipinfos.mmsi}
  end
end
