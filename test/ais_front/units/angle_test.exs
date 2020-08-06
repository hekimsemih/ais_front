defmodule AisFront.Units.AngleTest do
  use ExUnit.Case, async: true

  alias AisFront.Units.Angle

  test "new/1 with various type" do
    assert Angle.new(1) == %Angle{unit: :rad, value: Decimal.cast(1)}
    assert Angle.new(1.23) == %Angle{unit: :rad, value: Decimal.cast(1.23)}
    assert Angle.new("1.23") == %Angle{unit: :rad, value: Decimal.cast("1.23")}
    assert_raise FunctionClauseError, fn () -> Angle.new(:abc) end
  end
  test "new/2 for various unit" do
    assert Angle.new(1, :rad) == %Angle{unit: :rad, value: Decimal.cast(1)}
    assert Angle.new(1, :dd) == %Angle{unit: :dd, value: Decimal.cast(1)}
    assert Angle.new({1, 1}, :dm) == %Angle{unit: :dm, value: {Decimal.cast(1), Decimal.cast(1)}}
    assert Angle.new({1, 1, 1}, :dms) == %Angle{unit: :dms, value: {Decimal.cast(1), Decimal.cast(1), Decimal.cast(1)}}
    assert_raise ArgumentError, fn () -> Angle.new(1, :bad_unit) end
    assert_raise ArgumentError, fn () -> Angle.new(1, :dm) end
    assert_raise ArgumentError, fn () -> Angle.new(1, :dms) end
  end
  test "various helper converter to_*" do
    distance = Angle.new(1, :rad)
    assert Angle.to_rad(distance) == %Angle{unit: :rad, value: Decimal.cast(1)}
    assert Angle.to_dd(distance) == %Angle{unit: :dd, value: Decimal.cast("57.29577951308232522583526560")}
    assert Angle.to_dm(distance) == %Angle{unit: :dm, value: {Decimal.cast(57), Decimal.cast("17.74677078493951355011593600")}}
    assert Angle.to_dms(distance) == %Angle{unit: :dms, value: {Decimal.cast(57), Decimal.cast("17"), Decimal.cast("44.80624709637081300695616000")}}
    distance = Angle.new(1, :dd)
    assert Angle.to_rad(distance) == %Angle{unit: :rad, value: Decimal.cast("0.01745329251994329444444444444")}
    assert Angle.to_dd(distance) == %Angle{unit: :dd, value: Decimal.cast(1)}
    assert Angle.to_dm(distance) == %Angle{unit: :dm, value: {Decimal.cast(1), Decimal.cast(0)}}
    assert Angle.to_dms(distance) == %Angle{unit: :dms, value: {Decimal.cast(1), Decimal.cast(0), Decimal.cast(0)}}
    distance = Angle.new({1,0}, :dm)
    assert Angle.to_rad(distance) == %Angle{unit: :rad, value: Decimal.cast("0.01745329251994329444444444444")}
    assert Angle.to_dd(distance) == %Angle{unit: :dd, value: Decimal.cast(1)}
    assert Angle.to_dm(distance) == %Angle{unit: :dm, value: {Decimal.cast(1), Decimal.cast(0)}}
    assert Angle.to_dms(distance) == %Angle{unit: :dms, value: {Decimal.cast(1), Decimal.cast(0), Decimal.cast(0)}}
    distance = Angle.new({1,0,0}, :dms)
    assert Angle.to_rad(distance) == %Angle{unit: :rad, value: Decimal.cast("0.01745329251994329444444444444")}
    assert Angle.to_dd(distance) == %Angle{unit: :dd, value: Decimal.cast(1)}
    assert Angle.to_dm(distance) == %Angle{unit: :dm, value: {Decimal.cast(1), Decimal.cast(0)}}
    assert Angle.to_dms(distance) == %Angle{unit: :dms, value: {Decimal.cast(1), Decimal.cast(0), Decimal.cast(0)}}

    distance = Angle.new(-1, :rad)
    assert Angle.to_rad(distance) == %Angle{unit: :rad, value: Decimal.cast(-1)}
    assert Angle.to_dd(distance) == %Angle{unit: :dd, value: Decimal.cast("-57.29577951308232522583526560")}
    assert Angle.to_dm(distance) == %Angle{unit: :dm, value: {Decimal.cast(-57), Decimal.cast("17.74677078493951355011593600")}}
    assert Angle.to_dms(distance) == %Angle{unit: :dms, value: {Decimal.cast(-57), Decimal.cast("17"), Decimal.cast("44.80624709637081300695616000")}}
  end
  test "String.Chars impl" do
    assert Angle.new(1, :rad) |> to_string == "1rad"
    assert Angle.new(1, :dd) |> to_string == "1°"
    assert Angle.new({1,0}, :dm) |> to_string == "1°0'"
    assert Angle.new({1,0,0}, :dms) |> to_string == "1°0'0''"
  end
end


