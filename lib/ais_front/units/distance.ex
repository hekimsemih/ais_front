defmodule AisFront.Units.Distance do
  alias __MODULE__
  alias AisFront.Protocols.Convertible

  defstruct value: Decimal.new(0), unit: :m

  @si_unit :m
  @unit_si_ratio %{m: 1, km: 1000, nmi: 1852}
  @possible_units Map.keys(@unit_si_ratio)

  def si_unit(), do: @si_unit
  def unit_si_ratio(), do: @unit_si_ratio
  def possible_units(), do: @possible_units

  def new(value, unit \\ @si_unit) when unit in @possible_units do
    %Distance{value: Decimal.cast(value), unit: unit}
  end

  def to_m(distance), do: Convertible.convert(distance, :m)
  def to_km(distance), do: Convertible.convert(distance, :km)
  def to_nmi(distance), do: Convertible.convert(distance, :nmi)

  defimpl Convertible do
    def possible_units(_distance), do: Distance.possible_units

    def si_unit(_distance), do: Distance.si_unit()
    def si?(distance), do: distance.unit == Distance.si_unit
    def to_si(%Distance{value: value, unit: unit}) do
      unit_si_ratio = Distance.unit_si_ratio[unit]
      %Distance{
        value: Decimal.mult(value, unit_si_ratio),
        unit: Distance.si_unit
      }
    end

    def convert(%Distance{unit: unit} = distance, unit), do: distance
    def convert(distance, to_unit) do
      %Distance{value: value} = to_si(distance)
      unit_si_ratio = Distance.unit_si_ratio[to_unit]
      %Distance{
        value: Decimal.div(value, unit_si_ratio),
        unit: to_unit
      }
    end
  end

  defimpl String.Chars do
    @unit_repr %{m: "m", km: "km", nmi: "nmi"}
    @unit_precision %{m: 2, km: 4, nmi: 4}
    def to_string(%Distance{value: value, unit: unit}) do
      "#{Decimal.round(value, @unit_precision[unit])} #{@unit_repr[unit]}"
    end
  end
end
