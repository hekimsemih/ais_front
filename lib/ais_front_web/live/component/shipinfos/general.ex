defmodule AisFrontWeb.Live.Component.Shipinfos.General do
  use Phoenix.LiveComponent

  alias AisFront.Core.FullShipinfos
  alias AisFrontWeb.Live.Component.Svg
  alias AisFront.Units.Distance

  defp ship_width(shipinfos) do
    width = shipinfos.dim_port + shipinfos.dim_starboard
    cond do
      63 in [shipinfos.dim_port, shipinfos.dim_starboard] -> ">= 63.0 m"
      width > 0 -> Distance.new(shipinfos.dim_port + shipinfos.dim_starboard, :m) |> to_string
      true -> "Not available"
    end
  end
  defp ship_length(shipinfos) do
    length = shipinfos.dim_bow + shipinfos.dim_stern
    cond do
      511 in [shipinfos.dim_bow, shipinfos.dim_stern] -> ">= 511.0 m"
      length > 0 -> Distance.new(shipinfos.dim_bow + shipinfos.dim_stern, :m) |> to_string
      true -> "Not available"
    end
  end
  defp coordinates(shipinfos) do
    coordinates = shipinfos.point.coordinates
                  |> Tuple.to_list
                  |> Enum.join(",")
    "[#{coordinates}]"
  end
  def render(%{shipinfos: _shipinfos} = assigns) do
    ~L"""
    <article id="shipinfos-jump">
      <h4>Jump to ship:</h4>
      <ul>
        <li class="jump-button" title="large" onclick="jumpto(<%= coordinates(@shipinfos) %>, 6)">
          <svg class="large-jump">
            <%= live_component @socket, Svg, image: "boat.svg" %>
          </svg>
        </li>
        <li class="jump-button" title="medium" onclick="jumpto(<%= coordinates(@shipinfos) %>, 12)">
          <svg class="medium-jump">
            <%= live_component @socket, Svg, image: "boat.svg" %>
          </svg>
        </li>
        <li class="jump-button" title="close" onclick="jumpto(<%= coordinates(@shipinfos) %>, 18)">
          <svg class="close-jump">
            <%= live_component @socket, Svg, image: "boat.svg" %>
          </svg>
        </li>
      </ul>
    </article>
    <article id="shipinfos-description">
      <p>
        <strong><%= FullShipinfos.pretty_date!(@shipinfos) %></strong>, the vessel
        <%= if @shipinfos.name != "" do %>
          known as <strong><%= @shipinfos.name %></strong>
        <% end %>
        identified with
        <%= if @shipinfos.callsign != "" do %>
          radio callsign <strong><%= @shipinfos.callsign %></strong> and
        <% end %>
        mmsi number <strong><%= @shipinfos.mmsi %></strong>
        was located at
        <strong><%= FullShipinfos.pretty_point!(@shipinfos, unit: :dms, compass?: true) %></strong>
        <%= if @shipinfos.sog > 0.5 do %>
          sailing at <strong><%= FullShipinfos.field_to_unit({:sog, @shipinfos.sog}) |> to_string %></strong>
        <% end %>
        <%= if @shipinfos.destination != "" do %>
          towards <strong><%= FullShipinfos.field_to_unit({:destination, @shipinfos.destination}) |> to_string %></strong>
        <% end %>
      </p>
    </article>
    <article id="shipinfos-dimensions">
      <table>
        <tr>
          <td><%= ship_width(@shipinfos) %></td>
          <td>
            <svg id="boat-repr">
              <%= live_component @socket, Svg, image: "boat-dim.svg" %>
            </svg>
          </td>
        </tr>
        <tr>
          <td></td>
          <td><%= ship_length(@shipinfos) %></td>
        </tr>
      </table>
    </article>
    """
  end
end
