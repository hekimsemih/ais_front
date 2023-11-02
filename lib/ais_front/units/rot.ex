defmodule AisFront.Units.ROT do
  alias __MODULE__
  alias AisFront.Protocols.Convertible

  defstruct value: %Decimal{}, unit: :ms

  @si_unit :rad_sec
  @unit_si_ratio %{
    rad_sec: 1,
    deg_sec: "3.141592653589793" |> Decimal.new |> Decimal.div(180),
    deg_min: "3.141592653589793" |> Decimal.new |> Decimal.div(180*60)
  }
  @possible_units Map.keys(@unit_si_ratio) ++ [:ais]

  def si_unit(), do: @si_unit
  def unit_si_ratio(), do: @unit_si_ratio
  def possible_units(), do: @possible_units

  def new(value, unit \\ @si_unit) when unit in @possible_units do
    %ROT{value: Decimal.cast(value), unit: unit}
  end

  def to_rad_sec(rot), do: Convertible.convert(rot, :rad_sec)
  def to_deg_sec(rot), do: Convertible.convert(rot, :deg_sec)
  def to_deg_min(rot), do: Convertible.convert(rot, :deg_min)
  def to_ais(rot), do: Convertible.convert(rot, :ais)

  defimpl Convertible do
    def possible_units(_rot), do: ROT.possible_units

    def si_unit(_rot), do: ROT.si_unit()
    def si?(rot), do: rot.unit == ROT.si_unit
    def to_si(%ROT{value: value, unit: :ais}) do
      v = Decimal.div(value, "4.733")
      deg_min_si_ratio = ROT.unit_si_ratio[:deg_min]
      %ROT{
        value: Decimal.mult(v,v) |> Decimal.mult(deg_min_si_ratio),
        unit: ROT.si_unit
      }
    end
    def to_si(%ROT{value: value, unit: unit}) do
      unit_si_ratio = ROT.unit_si_ratio[unit]
      %ROT{
        value: Decimal.mult(value, unit_si_ratio),
        unit: ROT.si_unit
      }
    end

    def convert(%ROT{unit: unit} = rot, unit), do: rot
    def convert(rot, :ais) do
      %ROT{value: value} = to_si(rot)
      deg_min_si_ratio = ROT.unit_si_ratio[:deg_min]

      positive? = Decimal.positive?(value)
      value = Decimal.div(value, deg_min_si_ratio) 
              |> Decimal.abs
              |> Decimal.sqrt
              |> Decimal.mult("4.733")
      value = case positive? do
        true -> value
        false -> Decimal.mult(-1, value)
      end

      %ROT{
        value: value,
        unit: :ais
      }
    end
    def convert(rot, to_unit) do
      %ROT{value: value} = to_si(rot)
      unit_si_ratio = ROT.unit_si_ratio[to_unit]
      %ROT{
        value: Decimal.div(value, unit_si_ratio),
        unit: to_unit
      }
    end
  end

  defimpl String.Chars do
    @unit_repr %{rad_sec: "rad/s", deg_sec: "°/s", deg_min: "°/min"}
    @unit_precision %{rad_sec: 6, deg_sec: 4, deg_min: 2, ais: 0}
    def to_string(%ROT{value: value, unit: :ais} = rot) do
      rounded = Decimal.round(value, @unit_precision[:ais]) |> Decimal.to_integer
      case rounded do
        127 -> ">5°/30s"
        -127 -> "<-5°/30s"
        128 -> "No turn information"
        _ ->
          deg_min = rot |> ROT.to_deg_min
          "#{deg_min}"
      end
    end
    def to_string(%ROT{value: value, unit: unit}) do
      rounded = Decimal.round(value, @unit_precision[unit])
      case unit do
        :rad_sec -> "#{rounded} #{@unit_repr[unit]}"
        _ -> "#{rounded}#{@unit_repr[unit]}"
      end
    end
  end
end


