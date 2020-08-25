defmodule AisFrontWeb.ShipinfosView do
  use AisFrontWeb, :view
  alias AisFrontWeb.ShipinfosView

  alias AisFront.Core.Shipinfos

  defp render_view("index.json", %{shipinfos: shipinfos}, view) do
    tf = Enum.count(shipinfos)
    %{
      type: "FeatureCollection",
      totalFeatures: tf,
      features: render_many(shipinfos, ShipinfosView, view)
    }
  end
  defp render_view("show.json", %{shipinfos: shipinfos}) do
    %{data: render_one(shipinfos, ShipinfosView, "shipinfos.json")}
  end

  defp shipinfos_description(shipinfos) do
    "#{Shipinfos.pretty_name!(shipinfos)}, #{Shipinfos.pretty_date!(shipinfos)}"
  end
  defp shipinfos_heading_or_cog(shipinfos) do
    cond do
      shipinfos.heading >= 0 and shipinfos.heading < 360 -> shipinfos.heading
      shipinfos.cog < 0 and shipinfos.cog >= 360.0 -> 511 # not available
      true -> shipinfos.cog
    end
  end

  defp render_geojson(mmsi, geom, properties) do
    %{
      type: "Feature",
      id: mmsi,
      geometry: geom,
      geometry_name: "point",
      properties: properties
    }
  end

  def render("full_index.json", params), do: render_view("index.json", params, "full")
  def render("large_map_index.json", params), do: render_view("index.json", params, "large_map")

  def render("full_show.json", params), do: render_view("show.json", params, "full")
  def render("large_map_show.json", params), do: render_view("show.json", params, "large_map")

  def render("full", %{shipinfos: shipinfos}) do
    geom = Geo.JSON.encode!(shipinfos.point)
    properties = Map.delete(shipinfos, :point)

    render_geojson(shipinfos.mmsi, geom, properties)
  end
  def render("large_map", %{shipinfos: shipinfos}) do
    geom = Geo.JSON.encode!(shipinfos.point)
    description = shipinfos_description(shipinfos)
    h_or_c = shipinfos_heading_or_cog(shipinfos)

    properties = shipinfos
                 |> Map.take([:mmsi, :type, :sog])
                 |> Map.merge(%{description: description, heading: h_or_c})

    render_geojson(shipinfos.mmsi, geom, properties)
  end
end
