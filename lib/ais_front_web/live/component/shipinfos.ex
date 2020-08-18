defmodule AisFrontWeb.Live.Component.ShipInfos do
  use Phoenix.LiveComponent

  alias AisFront.Core
  alias AisFront.Core.ShipInfos

  alias AisFrontWeb.Struct.Panel
  alias AisFrontWeb.Live.Component.ShipInfos.None

  def mount(socket) do
    {
      :ok,
      assign(socket,
        opened_details: MapSet.new(["general"]),
        widgets: %{
          analysis: %{summary: "Analysis", module: None},
          general: %{summary: "General", module: AisFrontWeb.Live.Component.ShipInfos.General},
          raw: %{summary: "Raw content", module: AisFrontWeb.Live.Component.ShipInfos.Raw}
        }
      )
    }
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
        <button phx-click="changeinfos" phx-value-mmsi="41291111" phx-target="#shipinfos > .panel-content">TEST</button>
      </section>
    """
  end

  def render(%{shipinfos: _shipinfos} = assigns) do
    ~L"""
      <section class="panel-content" phx-hook="ChangeInfos">
        <h3><%= ShipInfos.pretty_name!(@shipinfos) %></h3>
        <%= for {k, v} <- @widgets do %>
        <details <%= open_details(Atom.to_string(k), @opened_details) %>>
          <summary phx-click="update_details_state" phx-value-details_name=<%= Atom.to_string(k) %> phx-target="#shipinfos > .panel-content">
            <strong><%= v.summary %></strong>
          </summary>
          <div class="details-content">
            <%= live_component @socket, v.module, shipinfos: @shipinfos %>
          </div>
        </details>
        <% end %>
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
