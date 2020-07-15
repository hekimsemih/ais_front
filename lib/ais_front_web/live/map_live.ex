defmodule AisFrontWeb.MapLive do
  use Phoenix.LiveView

  alias AisFrontWeb.Live.Component.ShipInfos
  alias AisFrontWeb.Live.Component.Search

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        page_title: "Watch AIS ships in real time",
        dummy: "",
        panel: nil,
        panels: [
          %{id: "shipinfos", title: "Ship Infos", module: ShipInfos, hook: "ChangeInfos"},
          %{id: "search", title: "Search", module: Search, hook: nil}
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
