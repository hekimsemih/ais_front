defmodule AisFrontWeb.MapLive do
  use Phoenix.LiveView

  alias AisFrontWeb.Live.Component.ShipInfos
  alias AisFrontWeb.Live.Component.Search
  alias AisFrontWeb.Live.Component.Svg

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        page_title: "Watch AIS ships in real time",
        dummy: "",
        panel: nil,
        panels: [
          %{id: "search", title: "Search", icon: "search.svg", module: Search, hook: nil},
          %{id: "shipinfos", title: "Ship Infos", icon: "boat.svg", module: ShipInfos, hook: "ChangeInfos"},
          %{id: "attributions", title: "Attributions", icon: "nil.svg", module: Search, hook: nil}
        ],
        shipinfos: [id: 1234, bar: "something"]
      )
    }
  end
  def handle_event("showpanel", %{"panel" => panel}, socket) do
    {:noreply, assign(socket, panel: panel)}
  end
  def handle_event("hidepanel", payload, socket) do
    {:noreply, assign(socket, panel: nil)}
  end
end
