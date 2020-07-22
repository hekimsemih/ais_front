defmodule AisFrontWeb.MapLive do
  @moduledoc """
  Liveview module to render the map page
  """
  use Phoenix.LiveView

  alias AisFrontWeb.Live.Component.ShipInfos
  alias AisFrontWeb.Live.Component.Search
  alias AisFrontWeb.Live.Component.Svg

  alias AisFrontWeb.Struct.Panels
  alias AisFrontWeb.Struct.Panel

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        page_title: "Watch AIS ships in real time",
        panel_id: nil,
        panels: %Panels{
          attributions: %Panel{title: "Attributions", icon: "cross.svg", module: Search},
          configuration: %Panel{title: "Configuration", icon: "cross.svg", module: Search},
          help: %Panel{title: "Help", icon: "cross.svg", module: Search},
          infos: %Panel{title: "Easy infos", icon: "cross.svg", module: Search},
          legends: %Panel{title: "Legends", icon: "cross.svg", module: Search},
          positions: %Panel{title: "Live positions", icon: "cross.svg", module: Search},
          search: %Panel{title: "Search", icon: "search.svg", module: Search},
          shipinfos: %Panel{assigns: %{shipinfos: nil}, title: "Ship Infos", icon: "boat.svg", module: ShipInfos},
          tools: %Panel{title: "Tools", icon: "cross.svg", module: Search}
        }
      )
    }
  end

  @doc """
  `showpanel` event will set the proper `panel_id` to the socket assigns to
  allow the chosen panel to be displayed
  """
  def handle_event("showpanel", %{"panel_id" => panel_id}, socket) do
    {:noreply, assign(socket, panel_id: String.to_atom(panel_id))}
  end

  @doc """
  `hidepanel` event will set `panel_id` to `nil` to the socket assigns so that
  the current panel will be hidden
  """
  def handle_event("hidepanel", _payload, socket) do
    {:noreply, assign(socket, panel_id: nil)}
  end

  # Helper function to merge two Panels recursively together
  # Will prioritize map2 if val in both map
  defp recursive_merge(map1 = %{}, map2 = %{}), do: Map.merge(map1, map2, fn _k, v1, v2 -> recursive_merge(v1, v2) end)
  defp recursive_merge(val1, nil), do: val1
  defp recursive_merge(nil, val2), do: val2
  defp recursive_merge(_val1, val2), do: val2
  defp merge_panels(panels1 = %Panels{}, panels2 = %Panels{}), do: recursive_merge(panels1, panels2)

  @doc """
  `:updatepanel` info will change values associated in the socket assigns
  to the `panel_id` to `changes`. See `%Panel{}` for the `changes` structure.
  """
  def handle_info({:updatepanel, %{panel_id: panel_id, changes: changes}}, socket) do
    panels = socket.assigns.panels
             |> merge_panels(struct(Panels, %{panel_id => changes}))
    {:noreply, assign(socket, :panels, panels)}
  end
end
