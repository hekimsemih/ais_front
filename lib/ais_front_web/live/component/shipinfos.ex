defmodule AisFrontWeb.Live.Component.ShipInfos do
  use Phoenix.LiveComponent

  alias AisFront.Core

  def render(%{shipinfos: nil} = assigns) do
    ~L"""
      <section class="panel-content" phx-hook="ChangeInfos">
        <p>No ship selected. Click on one to see informations about it.</p>
        <button phx-click="changeinfos" phx-value-mmsi="2523601" phx-target="#shipinfos > .panel-content">TEST</button>
      </section>
    """
  end

  def render(%{shipinfos: shipinfos} = assigns) do
    ~L"""
      <section class="panel-content" phx-hook="ChangeInfos">
        <h3><%= @shipinfos.mmsi %></h3>
        <details>
          <summary><b>Raw message</b></summary>
          <table>
            <%= for k <- Map.keys(@shipinfos) |> Enum.filter(& &1 not in [:__meta__, :__struct__, :point]) do %>
            <tr>
              <th><%= k %></th>
              <td><%= Map.get(@shipinfos, k) %></td>
            </tr>
            <% end %>
          </table>
        </details
      </section>
    """
  end

  def handle_event("changeinfos", %{"mmsi" => mmsi}, socket) do
    shipinfos = Core.get_ship_infos(mmsi)
    send(self(), {:updatepanel, %{panel_id: :shipinfos, changes: %{assigns: %{shipinfos: shipinfos}}}})
    {:noreply, assign(socket, shipinfos: shipinfos)}
  end
end
