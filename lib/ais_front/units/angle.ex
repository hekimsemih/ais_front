defmodule AisFront.Units.Angle do
  alias __MODULE__
  alias AisFront.Protocols.Convertible

  defstruct value: %Decimal{}, unit: :rad

  @si_unit :rad
  @unit_si_ratio %{rad: 1, dd: :math.pi |> Decimal.cast |> Decimal.div(180)}
  @standard_units Map.keys(@unit_si_ratio)
  @compound_degree_units [:dm, :dms]

  def si_unit(), do: @si_unit
  def unit_si_ratio(), do: @unit_si_ratio
  def possible_units(), do: @standard_units ++ @compound_degree_units

  # Cast a tuple of number to a tuple of Decimal
  defp new_decimal_tuple(tuple) do
    tuple
    |> Tuple.to_list
    |> Enum.map(& Decimal.cast(&1))
    |> List.to_tuple
  end

  # Return the value of of the Angle if value and unit are valid arguments for
  # Angle
  defp value_or_error(value, unit) do
    cond do
      unit in @standard_units -> {:ok, Decimal.cast(value)}
      unit in @compound_degree_units ->
        if not is_tuple(value) do
            {:error, "value must be a tuple when unit is a @compound_degree_unit"}
        end
        case value do
          {_d, m} = tuple when m >= 0 -> {:ok, new_decimal_tuple(tuple)}
          {_d, m, s} = tuple when m >= 0 and s >= 0 -> {:ok, new_decimal_tuple(tuple)}
          _ -> {:error, "Bad tuple for angle value with unit #{unit}"}
        end
      true -> {:error, "Bad unit #{unit}"}
    end
  end

  @doc """
  Check if maybe_angle is a valid Angle
  """
  def angle?(%Angle{} = maybe_angle) do
    case value_or_error(maybe_angle.value, maybe_angle.unit) do
      {:ok, _value} -> true
      {:error, _error} -> false
    end
  end
  def angle?(_not_angle), do: false

  @doc """
  Create a new Angle from value and unit
  """
  def new(value, unit \\ @si_unit)
  def new(value, unit) do
    value = case value_or_error(value, unit) do
      {:ok, value} -> value
      {:error, reason} -> raise ArgumentError, message: reason
    end
    %Angle{value: value, unit: unit}
  end

  @doc """
  Convert angle to the rad unit
  """
  def to_rad(angle), do: Convertible.convert(angle, :rad)
  @doc """
  Convert angle to decimal degree unit
  """
  def to_dd(angle), do: Convertible.convert(angle, :dd)
  @doc """
  Convert angle to degree minute unit
  """
  def to_dm(angle), do: Convertible.convert(angle, :dm)
  @doc """
  Convert angle to degree minute second unit
  """
  def to_dms(angle), do: Convertible.convert(angle, :dms)

  defimpl Convertible do
    defp dm_to_dms(%Angle{value: {d, m}, unit: :dm}) do
      m_ = Decimal.round(m, 0, :down)
      s = m
          |> Decimal.sub(m_)
          |> Decimal.mult(60)
      Angle.new({d,m_,s}, :dms)
    end
    defp dd_to_dm(%Angle{value: dd, unit: :dd}) do
      d = Decimal.round(dd, 0, :down)
      m = dd
          |> Decimal.sub(d)
          |> Decimal.mult(60)
          |> Decimal.abs
      Angle.new({d,m}, :dm)
    end
    defp dms_to_dm(%Angle{value: {d,m,s}, unit: :dms}) do
      m = s
          |> Decimal.div(60)
          |> Decimal.add(m)
      Angle.new({d,m}, :dm)
    end
    defp dm_to_dd(%Angle{value: {d,m}, unit: :dm}) do
      value = m
              |> Decimal.div(60)
              |> Decimal.add(d)
      Angle.new(value, :dd)
    end

    def possible_units(_angle), do: Angle.possible_units

    def si_unit(_angle), do: Angle.si_unit()
    def si?(angle), do: angle.unit == Angle.si_unit

    def to_si(%Angle{unit: :dms} = angle), do: angle |> dms_to_dm |> to_si
    def to_si(%Angle{unit: :dm} = angle), do: angle |> dm_to_dd |> to_si
    def to_si(%Angle{value: value, unit: unit}) do
      unit_si_ratio = Angle.unit_si_ratio[unit]
      %Angle{
        value: Decimal.mult(value, unit_si_ratio),
        unit: Angle.si_unit
      }
    end

    @standard_units [:rad, :dd]
    @compound_degree_units [:dm, :dms]
    @verbose_degrees %{
      dms: :degrees_minutes_seconds,
      dm: :degrees_minutes,
      dd: :decimal_degrees
    }
    @verbose_degree_values Map.values(@verbose_degrees)

    def convert(angle, to_unit) when to_unit in @verbose_degree_values do
      convert(angle, @verbose_degrees[to_unit])
    end
    # Is there a better way ?
    def convert(%Angle{unit: :dm} = angle, :dms), do: dm_to_dms(angle)
    def convert(%Angle{unit: :dd} = angle, :dm), do: dd_to_dm(angle)
    def convert(%Angle{unit: :dms} = angle, :dm), do: dms_to_dm(angle)
    def convert(%Angle{unit: :dm} = angle, :dd), do: dm_to_dd(angle)
    def convert(%Angle{unit: :dms} = angle, :dd), do: angle |> dms_to_dm |> convert(:dd)
    def convert(%Angle{unit: :dd} = angle, :dms), do: angle |> dd_to_dm |> convert(:dms)
    def convert(%Angle{} = angle, to_unit) when to_unit in @compound_degree_units do
      angle |> convert(:dd) |> convert(to_unit)
    end

    def convert(%Angle{} = angle, to_unit) when to_unit in @standard_units do
      %Angle{value: value} = to_si(angle)
      unit_si_ratio = Angle.unit_si_ratio[to_unit]
      %Angle{
        value: Decimal.div(value, unit_si_ratio),
        unit: to_unit
      }
    end
  end

  defimpl String.Chars do
    @unit_repr %{rad: "rad", dd: "°", min: "'", sec: "''"}
    @unit_precision %{rad: 8, dd: 6, min: 5, sec: 4}

    def to_string(%Angle{value: {d,m}, unit: :dm}) do
      m = m |> Decimal.round(@unit_precision[:min]) |> Decimal.reduce
      "#{d}#{@unit_repr[:dd]}#{m}#{@unit_repr[:min]}"
    end
    def to_string(%Angle{value: {d,m,s}, unit: :dms}) do
      s = s |> Decimal.round(@unit_precision[:sec]) |> Decimal.reduce
      "#{d}#{@unit_repr[:dd]}#{m}#{@unit_repr[:min]}#{s}#{@unit_repr[:sec]}"
    end
    def to_string(%Angle{value: value, unit: unit}) do
      value = value |> Decimal.round(@unit_precision[unit]) |> Decimal.reduce
      "#{value}#{@unit_repr[unit]}"
    end
  end
end


