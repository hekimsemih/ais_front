defmodule AisFront.Units.ROTTest do
  use ExUnit.Case, async: true

  alias AisFront.Units.ROT

  test "new/1 with various type" do
    assert ROT.new(1) == %ROT{unit: :rad_sec, value: Decimal.cast(1)}
    assert ROT.new(1.23) == %ROT{unit: :rad_sec, value: Decimal.cast(1.23)}
    assert ROT.new("1.23") == %ROT{unit: :rad_sec, value: Decimal.cast("1.23")}
    assert_raise FunctionClauseError, fn () -> ROT.new(:abc) end
  end

  test "new/2 for various unit" do
    assert ROT.new(1, :rad_sec) == %ROT{unit: :rad_sec, value: Decimal.cast(1)}
    assert ROT.new(1, :deg_sec) == %ROT{unit: :deg_sec, value: Decimal.cast(1)}
    assert ROT.new(1, :deg_min) == %ROT{unit: :deg_min, value: Decimal.cast(1)}
    assert ROT.new(1, :ais) == %ROT{unit: :ais, value: Decimal.cast(1)}
    assert_raise FunctionClauseError, fn () -> ROT.new(1, :bad_unit) end
  end

  test "various helper converter to_*" do
    rot = ROT.new(1, :rad_sec)
    assert ROT.to_rad_sec(rot) == %ROT{unit: :rad_sec, value: Decimal.cast(1)}
    assert ROT.to_deg_sec(rot) == %ROT{unit: :deg_sec, value: Decimal.cast("57.29577951308232522583526560")}
    assert ROT.to_deg_min(rot) == %ROT{unit: :deg_min, value: Decimal.cast("3437.746770784939513550115935")}
    assert ROT.to_ais(rot) == %ROT{unit: :ais, value: Decimal.cast("277.5066826603824091962777254")}
    rot = ROT.new(1, :deg_sec)
    assert ROT.to_rad_sec(rot) == %ROT{unit: :rad_sec, value: Decimal.cast("0.01745329251994329444444444444")}
    assert ROT.to_deg_sec(rot) == %ROT{unit: :deg_sec, value: Decimal.cast(1)}
    assert ROT.to_deg_min(rot) == %ROT{unit: :deg_min, value: Decimal.cast("59.99999999999999999999999998")}
    assert ROT.to_ais(rot) == %ROT{unit: :ais, value: Decimal.cast("36.66166035519940823510692627")}
    rot = ROT.new(1, :deg_min)
    assert ROT.to_rad_sec(rot) == %ROT{unit: :rad_sec, value: Decimal.cast("0.0002908882086657215740740740741")}
    assert ROT.to_deg_sec(rot) == %ROT{unit: :deg_sec, value: Decimal.cast("0.01666666666666666666666666667")}
    assert ROT.to_deg_min(rot) == %ROT{unit: :deg_min, value: Decimal.cast(1)}
    assert ROT.to_ais(rot) == %ROT{unit: :ais, value: Decimal.cast("4.733")}
    rot = ROT.new(1, :ais)
    assert ROT.to_rad_sec(rot) == %ROT{unit: :rad_sec, value: Decimal.cast("0.00001298533350762635016556744008")}
    assert ROT.to_deg_sec(rot) == %ROT{unit: :deg_sec, value: Decimal.cast("0.0007440048055567992835888446723")}
    assert ROT.to_deg_min(rot) == %ROT{unit: :deg_min, value: Decimal.cast("0.04464028833340795701533068032")}
    assert ROT.to_ais(rot) == %ROT{unit: :ais, value: Decimal.cast(1)}
  end

  test "String.Chars impl" do
    assert ROT.new(1, :rad_sec) |> to_string == "1.000000 rad/s"
    assert ROT.new(1, :deg_sec) |> to_string == "1.0000°/s"
    assert ROT.new(1, :deg_min) |> to_string == "1.00°/min"

    assert ROT.new(1, :ais) |> to_string == "0.04°/min"
    assert ROT.new(127, :ais) |> to_string == ">5°/30s"
    assert ROT.new(-127, :ais) |> to_string == "<-5°/30s"
    assert ROT.new(128, :ais) |> to_string == "No turn information"
  end
end


