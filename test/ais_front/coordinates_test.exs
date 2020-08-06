defmodule AisFront.Units.CoordinatesTest do
  use ExUnit.Case, async: true

  alias AisFront.Units.{Distance, Angle, ROT}
  alias AisFront.Coordinates
  alias Geo.Point

  @nil_srid_point %Point{coordinates: {1,1}}
  @bad_srid_point %Point{coordinates: {1,1}, srid: -1}
  @srid_3857_point %Point{coordinates: {1,1}, srid: 3857}
  @srid_4326_point %Point{coordinates: {1,1}, srid: 4326}
  @srid_900913_point %Point{coordinates: {1,1}, srid: 900913}

  test "from_point!/1" do
    assert_raise MatchError, fn () -> Coordinates.from_point!(@nil_srid_point) end
    assert_raise MatchError, fn () -> Coordinates.from_point!(@bad_srid_point) end
    assert Coordinates.from_point!(@srid_3857_point) == %Coordinates{
      coordinates: {
        %Distance{unit: :m, value: Decimal.cast(1)},
        %Distance{unit: :m, value: Decimal.cast(1)}
      }, srid: 3857
    }
    assert Coordinates.from_point!(@srid_4326_point) == %Coordinates{
      coordinates: {
        %Angle{unit: :dd, value: Decimal.cast(1)},
        %Angle{unit: :dd, value: Decimal.cast(1)}
      }, srid: 4326
    }
    assert Coordinates.from_point!(@srid_900913_point) == %Coordinates{
      coordinates: {
        %Distance{unit: :m, value: Decimal.cast(1)},
        %Distance{unit: :m, value: Decimal.cast(1)}
      }, srid: 900913
    }
  end

  @bad_srid_coord %Coordinates{coordinates: {Angle.new(1),Angle.new(1)}, srid: -1}
  @bad_unit_coord %Coordinates{coordinates: {ROT.new(1), ROT.new(1)}, srid: 3857}
  @mix_unit_coord %Coordinates{coordinates: {Angle.new(1,:dd), Angle.new(1,:rad)}, srid: 4326}
  @mix_type_coord %Coordinates{coordinates: {Angle.new(1), Distance.new(1)}, srid: 3857}
  @bad_angle %Angle{value: 1, unit: :bad_unit}
  @bad_unit_type_coord %Coordinates{coordinates: {@bad_angle, @bad_angle}, srid: 4326}
  test "to_tuple_string/1 proper Coordinates validation" do
    assert_raise ArgumentError, ~r/srid -?\d+ is not recognized./, fn () -> @bad_srid_coord |> Coordinates.to_tuple_string end
    assert_raise ArgumentError, ~r/coordinates must be of the same type:/, fn () -> @mix_type_coord |> Coordinates.to_tuple_string end
    assert_raise ArgumentError, ~r/coordinates must have accepted unit./, fn () -> @bad_unit_coord |> Coordinates.to_tuple_string end
    assert_raise ArgumentError, ~r/coordinates must be of the same unit:/, fn () -> @mix_unit_coord |> Coordinates.to_tuple_string end
    assert_raise ArgumentError, ~r/bad unit/, fn () -> @bad_unit_type_coord |> Coordinates.to_tuple_string end
  end

  @srid_3857_coord Coordinates.from_point!(%Point{coordinates: {1,1}, srid: 3857})
  @srid_4326_coord Coordinates.from_point!(%Point{coordinates: {1,1}, srid: 4326})
  @srid_900913_coord Coordinates.from_point!(%Point{coordinates: {1,1}, srid: 900913})

  @srid_4326_coord_SW Coordinates.from_point!(%Point{coordinates: {-1,-1}, srid: 4326})
  test "to_tuple_string/1" do
    assert Coordinates.to_tuple_string(@srid_3857_coord) == {"1.00 m", "1.00 m"}
    assert Coordinates.to_tuple_string(@srid_4326_coord) == {"1°", "1°"}
    assert Coordinates.to_tuple_string(@srid_900913_coord) == {"1.00 m", "1.00 m"}
  end
  test "to_tuple_string/2" do
    assert Coordinates.to_tuple_string(@srid_3857_coord, [unit: :km]) == {"0.0010 km", "0.0010 km"}
    assert Coordinates.to_tuple_string(@srid_4326_coord) == {"1°", "1°"}
    assert Coordinates.to_tuple_string(@srid_900913_coord) == {"1.00 m", "1.00 m"}

    assert Coordinates.to_tuple_string(@srid_4326_coord, [compass?: true]) == {"1°E", "1°N"}
    assert Coordinates.to_tuple_string(@srid_4326_coord_SW, [compass?: true]) == {"1°W", "1°S"}
  end
end

