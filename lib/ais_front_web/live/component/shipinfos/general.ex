defmodule AisFrontWeb.Live.Component.ShipInfos.General do
  use Phoenix.LiveComponent

  alias AisFront.Core.ShipInfos

  def render(%{shipinfos: _shipinfos} = assigns) do
    ~L"""
    <div class="shipinfos-description">
      <p>
        <strong><%= ShipInfos.pretty_date!(@shipinfos) %></strong>, the vessel 
        <strong><%= ShipInfos.pretty_name!(@shipinfos) %></strong> was located at
        <strong><%= ShipInfos.pretty_point!(@shipinfos, unit: :dms, compass?: true) %></strong>
      </p>
    </div>
    """
  end
end

