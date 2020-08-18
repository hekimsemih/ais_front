defmodule AisFrontWeb.Live.Component.ShipInfos.General do
  use Phoenix.LiveComponent

  alias AisFront.Core.ShipInfos

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
    """
  end
end

