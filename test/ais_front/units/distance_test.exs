defmodule AisFront.Units.DistanceTest do
  use ExUnit.Case, async: true

  alias AisFront.Units.Distance

  test "new/1 with various type" do
    assert Distance.new(1) == %Distance{unit: :m, value: Decimal.cast(1)}
    assert Distance.new(1.23) == %Distance{unit: :m, value: Decimal.cast(1.23)}
    assert Distance.new("1.23") == %Distance{unit: :m, value: Decimal.cast("1.23")}
    assert_raise FunctionClauseError, fn () -> Distance.new(:abc) end
  end
  test "new/2 for various unit" do
    assert Distance.new(1, :m) == %Distance{unit: :m, value: Decimal.cast(1)}
    assert Distance.new(1, :km) == %Distance{unit: :km, value: Decimal.cast(1)}
    assert Distance.new(1, :nmi) == %Distance{unit: :nmi, value: Decimal.cast(1)}
    assert_raise FunctionClauseError, fn () -> Distance.new(1, :bad_unit) end
  end
  test "various helper converter to_*" do
    distance = Distance.new(1, :m)
    assert Distance.to_m(distance) == %Distance{unit: :m, value: Decimal.cast(1)}
    assert Distance.to_km(distance) == %Distance{unit: :km, value: Decimal.cast(0.001)}
    assert Distance.to_nmi(distance) == %Distance{unit: :nmi, value: Decimal.div(1, 1852)}
    distance = Distance.new(1, :km)
    assert Distance.to_m(distance) == %Distance{unit: :m, value: Decimal.cast(1000)}
    assert Distance.to_km(distance) == %Distance{unit: :km, value: Decimal.cast(1)}
    assert Distance.to_nmi(distance) == %Distance{unit: :nmi, value: Decimal.div(1000, 1852)}
    distance = Distance.new(1, :nmi)
    assert Distance.to_m(distance) == %Distance{unit: :m, value: Decimal.cast(1852)}
    assert Distance.to_km(distance) == %Distance{unit: :km, value: Decimal.cast(1.852)}
    assert Distance.to_nmi(distance) == %Distance{unit: :nmi, value: Decimal.cast(1)}
  end
  test "String.Chars impl" do
    assert Distance.new(1, :m) |> to_string == "1.00 m"
    assert Distance.new(1, :km) |> to_string == "1.0000 km"
    assert Distance.new(1, :nmi) |> to_string == "1.0000 nmi"
  end
end

