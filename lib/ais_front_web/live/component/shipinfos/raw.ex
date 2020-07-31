defmodule AisFrontWeb.Live.Component.ShipInfos.Raw do
  use Phoenix.LiveComponent

  def render(%{shipinfos: _shipinfos} = assigns) do
    ~L"""
    <table>
      <%= for {k,v} <- @shipinfos do %>
        <%= case k do %>
          <%= :point -> %>
      <tr>
        <th>latitude</th>
        <td><%= elem(v.coordinates, 1) %></td>
      </tr>
      <tr>
        <th>longitude</th>
        <td><%= elem(v.coordinates, 0) %></td>
      </tr>
      <tr>
        <th>srid</th>
        <td><%= v.srid %></td>
      </tr>
          <% _ -> %>
      <tr>
        <th><%= k %></th>
        <td><%= v %></td>
      </tr>
        <% end %>
      <% end %>
    </table>
    """
  end
end
