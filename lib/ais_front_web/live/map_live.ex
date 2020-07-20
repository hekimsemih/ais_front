defmodule AisFrontWeb.MapLive do
  use Phoenix.LiveView

  alias AisFront.Core

  alias AisFrontWeb.Live.Component.ShipInfos
  alias AisFrontWeb.Live.Component.Search
  alias AisFrontWeb.Live.Component.Svg

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        page_title: "Watch AIS ships in real time",
        panel_id: nil,
        panels: %{
          search: %{assigns: %{}, title: "Search", icon: "search.svg", module: Search},
          shipinfos: %{assigns: %{shipinfos: nil}, title: "Ship Infos", icon: "boat.svg", module: ShipInfos},
          attributions: %{assigns: %{}, title: "Attributions", icon: "cross.svg", module: Search}
        },
      )
    }
  end
  def handle_event("showpanel", %{"panel_id" => panel_id}, socket) do
    {:noreply, assign(socket, panel_id: String.to_atom(panel_id))}
  end
  def handle_event("hidepanel", _payload, socket) do
    {:noreply, assign(socket, panel_id: nil)}
  end

  defp recursive_merge(val1, nil), do: val1
  defp recursive_merge(nil, val2), do: val2
  defp recursive_merge(map1, map2) when is_map(map1) and is_map(map2) do
    Map.merge(map1, map2, fn _k, v1, v2 -> recursive_merge(v1, v2) end)
  end

  def handle_info({:updatepanel, %{panel_id: panel_id, changes: changes}} = msg, socket) do
    panels = socket.assigns.panels
             |> recursive_merge(%{panel_id => changes})
    socket
    |> assign(:panels, panels)
    |> Map.put(:changed, %{panels: %{panel_id => changes}})
    |> IO.inspect
    IO.inspect(assign(socket, :panels, panels))
    {:noreply, assign(socket, :panels, panels)}
  end
end
