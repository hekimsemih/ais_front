defmodule AisFrontWeb.ShipinfosView do
  use AisFrontWeb, :view
  alias AisFrontWeb.ShipinfosView

  alias AisFront.Core.Shipinfos

  def render("index.json", %{shipinfos_with_type: shipinfos_with_type, format: format, view: view}) do
    %{data: render_many(shipinfos_with_type, ShipinfosView, "shipinfos.json", as: :shipinfos_with_type, format: format, view: view)}
  end

  def render("show.json", %{shipinfos_with_type: shipinfos_with_type}) do
    %{data: render_one(shipinfos_with_type, ShipinfosView, "shipinfos.json")}
  end

  defp shipinfos_description(shipinfos) do
    "#{Shipinfos.pretty_name!(shipinfos)}, #{Shipinfos.pretty_date!(shipinfos)}"
  end
  defp shipinfos_heading_or_cog(shipinfos) do
    cond do
      shipinfos.heading != 511 -> shipinfos.heading
      shipinfos.cog >= 360.0 -> 0.0
      true -> shipinfos.cog
    end
  end

  # @aismap_properties [:mmsi, ]
  def render("shipinfos.json", %{shipinfos_with_type: shipinfos_with_type, format: format, view: view}) do
    # keys = Map.keys(value)
    #        |> Enum.filter(& &1 in @aismap_properties)
    # Map.take(value, keys)
    {shipinfos, shiptype} = shipinfos_with_type
    IO.inspect(shipinfos.point)
    p = Geo.JSON.encode!(shipinfos.point)

    %{
      type: "Feature",
      id: shipinfos.mmsi,
      geometry: p,
      geometry_name: "point",
      properties: ""
    }
  end
end
