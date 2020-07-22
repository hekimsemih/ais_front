defmodule AisFrontWeb.Live.Component.ShipInfos do
  use Phoenix.LiveComponent

  alias AisFront.Core
  alias AisFront.Core.ShipInfos

  alias AisFrontWeb.Struct.Panel

  def mount(socket) do
    {:ok, assign(socket, :opened_details, MapSet.new())}
  end

  defp open_details(details_name, opened_details) do
    case details_name in opened_details do
      true -> "open"
      false -> ""
    end
  end

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
        <h3><%= ShipInfos.pretty_name(@shipinfos) %></h3>
        <details <%= open_details("raw", @opened_details) %> phx-click="update_details_state" phx-value-details_name="raw" phx-target="#shipinfos > .panel-content">
          <summary><b>Raw message</b></summary>
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
        </details
      </section>
    """
  end

  def handle_event("changeinfos", %{"mmsi" => mmsi}, socket) do
    shipinfos = Core.get_shipinfos(mmsi)
    send(self(), {:updatepanel, %{panel_id: :shipinfos, changes: %Panel{assigns: %{shipinfos: shipinfos}}}})
    {:noreply, assign(socket, shipinfos: shipinfos)}
  end

  def handle_event("update_details_state", %{"details_name" => details_name}, socket) do
    socket = update(socket, :opened_details, fn od ->
      case details_name in od do
        true -> od |> MapSet.delete(details_name)
        false -> od |> MapSet.put(details_name)
      end
    end)
    {:noreply, socket}
  end
end
