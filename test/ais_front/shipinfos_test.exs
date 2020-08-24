defmodule AisFront.Core.ShipinfosTest do
  use ExUnit.Case, async: true
  doctest AisFront.Core.Shipinfos

  # @srid_not_recognized %Shipinfos{point: %Point{coordinates: {5.4321, -1.2}}}
  # @srid_4326 %Shipinfos{point: %Point{coordinates: {5.4321, -1.2}, srid: 4326}}
  # @pp_srid_4326 {"5.4321°", "-1.2°"}
end
