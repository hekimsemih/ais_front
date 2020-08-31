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
        <form phx-change="search" phx-target="#search-ship-query">
          <div id="search-ship-query" class="field-wrapper">
            <svg class="field-icon">
              <%= live_component @socket, Svg, image: "search.svg" %>
            </svg>
            <input type="text" name="query" class="field-content" placeholder="search for mmsi, name or callsign..." autofocus phx-debounce="200" />
          </div>
        </form>
        <div id="search-ship-results" <%= if @results == [], do: "class=hide" %>>
        <%= for ship <- @results do %>
          <div class="field-wrapper ship-result"
              onmouseover="debouncedOverSearchResult(<%= FullShipinfos.str_coordinates(ship) %>, <%= ship.mmsi %>)"
              onclick="showShip(<%= ship.mmsi %>)">
            <svg class="field-icon ship-icon <%= ship.type_short_name %>">
              <%= live_component @socket, Svg, image: "boat.svg" %>
            </svg>
            <div class="field-content">
              <table>
                <tr>
                  <th>mmsi</th>
                  <td><%= FullShipinfos.field_to_unit({:mmsi, ship.mmsi}) %></td>
                </tr>
                <tr>
                  <th>name</th>
                  <td><%= FullShipinfos.field_to_unit({:name, ship.name}) %></td>
                </tr>
                <tr>
                  <th>callsign</th>
                  <td><%= FullShipinfos.field_to_unit({:callsign, ship.callsign}) %></td>
                </tr>
              </table>
            </div>
          </div>
        <% end %>
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
