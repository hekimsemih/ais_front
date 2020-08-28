defmodule AisFrontWeb.Live.Component.Search do
  use Phoenix.LiveComponent

  alias AisFrontWeb.Live.Component.Svg

  def render(assigns) do
    ~L"""
      <section class="panel-content">
        <form id="search-ship" phx-change="search">
          <div class="field-wrapper">
            <svg>
              <%= live_component @socket, Svg, image: "search.svg" %>
            </svg>
            <input type="text" name="query" placeholder="search for mmsi, name or callsign..." phx-debounce="1000" />
          </div>
        </form>
      </section>
    """
  end
  def handle_event("query", %{"query" => query}, socket) do
  end
end
