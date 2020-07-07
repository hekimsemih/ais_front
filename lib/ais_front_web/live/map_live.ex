defmodule AisFrontWeb.MapLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Using Parcel with OpenLayers")}
  end
end
