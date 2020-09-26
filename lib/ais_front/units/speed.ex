defmodule AisFront.Units.Speed do
  alias __MODULE__
  alias AisFront.Protocols.Convertible

  defstruct value: %Decimal{}, unit: :ms

  @si_unit :ms
  @unit_si_ratio %{ms: 1, kmh: Decimal.div(1000, 3600), knots: Decimal.div(1852, 3600)}
  @possible_units Map.keys(@unit_si_ratio)

  def si_unit(), do: @si_unit
  def unit_si_ratio(), do: @unit_si_ratio
  def possible_units(), do: @possible_units

  def new(value, unit \\ @si_unit) when unit in @possible_units do
    %Speed{value: Decimal.cast(value), unit: unit}
  end

  def to_ms(speed), do: Convertible.convert(speed, :ms)
  def to_kmh(speed), do: Convertible.convert(speed, :kmh)
  def to_knots(speed), do: Convertible.convert(speed, :knots)

  defimpl Convertible do
    def possible_units(_speed), do: Speed.possible_units

    def si_unit(_speed), do: Speed.si_unit()
    def si?(speed), do: speed.unit == Speed.si_unit
    def to_si(%Speed{value: value, unit: unit}) do
      unit_si_ratio = Speed.unit_si_ratio[unit]
      %Speed{
        value: Decimal.mult(value, unit_si_ratio),
        unit: Speed.si_unit
      }
    end

    def convert(%Speed{unit: unit} = speed, unit), do: speed
    def convert(speed, to_unit) do
      %Speed{value: value} = to_si(speed)
      unit_si_ratio = Speed.unit_si_ratio[to_unit]
      %Speed{
        value: Decimal.div(value, unit_si_ratio),
        unit: to_unit
      }
    end
  end

  defimpl String.Chars do
    @unit_repr %{ms: "m/s", kmh: "km/h", knots: "kn"}
    @unit_precision %{ms: 2, kmh: 2, knots: 2}
    def to_string(%Speed{value: value, unit: unit}) do
      "#{Decimal.round(value, @unit_precision[unit])} #{@unit_repr[unit]}"
    end
  end
end
