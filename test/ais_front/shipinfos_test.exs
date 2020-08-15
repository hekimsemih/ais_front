defmodule AisFront.Core.ShipInfosTest do
  use ExUnit.Case, async: true
  doctest AisFront.Core.ShipInfos

  # @srid_not_recognized %ShipInfos{point: %Point{coordinates: {5.4321, -1.2}}}
  # @srid_4326 %ShipInfos{point: %Point{coordinates: {5.4321, -1.2}, srid: 4326}}
  # @pp_srid_4326 {"5.4321°", "-1.2°"}
end
