defmodule AisFrontWeb.Live.Component.ShipInfos.General do
  use Phoenix.LiveComponent

  alias AisFront.Core.ShipInfos

  defp coordinates(shipinfos) do
    coordinates = shipinfos.point.coordinates
                  |> Tuple.to_list
                  |> Enum.join(",")
    "[#{coordinates}]"
  end
  def render(%{shipinfos: _shipinfos} = assigns) do
    ~L"""
    <div id="shipinfos-description">
      <p>
        <strong><%= ShipInfos.pretty_date!(@shipinfos) %></strong>, the vessel
        <%= if @shipinfos.name != "" do %>
          known as <strong><%= @shipinfos.name %></strong>
        <% end %>
        identified with
        <%= if @shipinfos.callsign != "" do %>
          radio callsign <strong><%= @shipinfos.callsign %></strong> and
        <% end %>
          mmsi number <strong><%= @shipinfos.mmsi %></strong>
        was located at
        <strong><%= ShipInfos.pretty_point!(@shipinfos, unit: :dms, compass?: true) %></strong>
      </p>
    </div>
    <hr/>
    <div id="shipinfos-jump">
      <h4>Jump to ship:</h4>
      <ul>
       <li class="jump-button" title="large">
         <svg class="large-jump" onclick="jumpto(<%= coordinates(@shipinfos) %>, 6)">
           <%= live_component @socket, Svg, image: "boat.svg" %>
         </svg>
       </li>
       <li class="jump-button" title="medium">
         <svg class="medium-jump" onclick="jumpto(<%= coordinates(@shipinfos) %>, 12)">
           <%= live_component @socket, Svg, image: "boat.svg" %>
         </svg>
       </li>
       <li class="jump-button" title="close">
         <svg class="close-jump" onclick="jumpto(<%= coordinates(@shipinfos) %>, 18)">
           <%= live_component @socket, Svg, image: "boat.svg" %>
         </svg>
       </li>
      </ul>
    </div>
    """
  end
end
