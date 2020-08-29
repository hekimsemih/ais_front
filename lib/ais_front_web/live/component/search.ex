defmodule AisFrontWeb.Live.Component.Search do
  use Phoenix.LiveComponent

  alias AisFront.Core.FullShipinfos
  alias AisFrontWeb.Live.Component.Svg
  alias AisFront.Core

  def mount(socket) do
    {
      :ok,
      assign(socket,
        results: []
      )
    }
  end
  def render(assigns) do
    ~L"""
      <section class="panel-content">
        <form id="search-ship-query" phx-change="search" phx-target="#search-ship-query">
          <div class="field-wrapper">
            <svg>
              <%= live_component @socket, Svg, image: "search.svg" %>
            </svg>
            <input type="text" name="query" placeholder="search for mmsi, name or callsign..." phx-debounce="200" />
          </div>
        </form>
        <div id="search-ship-results" <%= if @results == [], do: "class=hide" %>>
          <table>
          <%= for ship <- @results do %>
            <tr class="ship-result"
                onmouseover="debouncedOverSearchResult(<%= FullShipinfos.str_coordinates(ship) %>, <%= ship.mmsi %>)"
                onclick="showShip(<%= ship.mmsi %>)">
              <td class="ship-result-icon">
                <svg>
                  <%= live_component @socket, Svg, image: "boat.svg" %>
                </svg>
              </td>
              <td class="ship-result-data">
                <table>
                  <tr>
                    <th>mmsi</th>
                    <td><%= ship.mmsi %></td>
                  </tr>
                  <tr>
                    <th>name</th>
                    <td><%= ship.name %></td>
                  </tr>
                  <tr>
                    <th>callsign</th>
                    <td><%= ship.callsign %></td>
                  </tr>
                </table>
              </td>
            <tr>
          <% end %>
          </table>
        </div>
      </section>
    """
  end
  def handle_event("search", %{"query" => query}, socket) do
    results = case query do
      "" -> []
      query -> Core.get_ships_by_identifiers(query)
    end
    {:noreply, assign(socket, results: results)}
  end
end
