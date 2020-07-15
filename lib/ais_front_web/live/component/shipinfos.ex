defmodule AisFrontWeb.Live.Component.ShipInfos do
  use Phoenix.LiveComponent

  def preload(list_of_assigns) do
    list_of_assigns
  end

  def render(%{shipinfos: _shipinfos} = assigns) do
    ~L"""
      <section class="panel-content">
        <h3>Ship infos title</h3>
        <table id="ship-infos">
          <%= for {k,v} <- @shipinfos do %>
          <tr>
            <th><%= k %></th>
            <td><%= v %></td>
          </tr>
          <% end %>
        </table>
      </section>
    """
  end
  def render(assigns) do
    ~L"""
      <section class="panel-content">
        <p>No ship selected. Click on one to see informations about it.</p>
      </section>
    """
  end
end
