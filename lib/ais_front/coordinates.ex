defmodule AisFront.Coordinates do
  alias __MODULE__

  alias AisFront.Units.Angle
  alias AisFront.Units.Distance

  alias AisFront.Protocols.Convertible
  alias Geo.Point

  @possible_srid [3857, 4326, 900913]
  @default_srid 4326
  @possible_units [Angle, Distance]

  @type coordinates_unit() :: Angle | Distance
  @type t() :: %Coordinates{
    coordinates: {coordinates_unit(), coordinates_unit()},
    srid: integer()
  }
  defstruct coordinates: {Angle.new(0, :dd), Angle.new(0, :dd)},
    srid: @default_srid

  defp validate_coordinates(%Coordinates{coordinates: {%ytype{} = y, %xtype{} = x}, srid: srid} = coordinates) do
    cond do
      srid not in @possible_srid ->
        {:error, "srid #{srid} is not recognized."}
      ytype != xtype ->
        {:error, "coordinates must be of the same type: #{xtype} != #{ytype}"}
      ytype not in @possible_units ->
        {:error, "coordinates must have accepted unit."}
      y.unit != x.unit ->
        {:error, "coordinates must be of the same unit:" <>
          " #{x.unit} != #{y.unit}"}
      x.unit not in Convertible.possible_units(x) ->
        {:error, "bad unit #{x.unit} for unit type #{xtype}"}
      true -> {:ok, coordinates}
    end
  end

  @srid_units %{
    "4326": {Angle, :dd},
    "3857": {Distance, :m},
    "900913": {Distance, :m}
  }

  @doc """
  Create a %Coordinates{} from %Geo.Point{}
  """
  @spec from_point!(Point.t()) :: Coordinates.t()
  def from_point!(%Point{coordinates: {y,x}, srid: srid}) do
    {unit_module, default_unit} = @srid_units[:"#{srid}"]
    coordinates = {
      unit_module.new(y, default_unit),
      unit_module.new(x, default_unit)
    }
    %Coordinates{coordinates: coordinates, srid: srid}
    |> validate_coordinates
    |> case do
      {:error, error} -> raise ArgumentError, message: "Bad Coordinates: " <> error
      {:ok, coordinates} -> coordinates
    end
  end

  defp merge_default_opts(opts, default_unit) do
    default_opts = [unit: default_unit, compass?: false]
    Keyword.merge(default_opts, opts)
  end

  defp compass(y, x) do
    [
      {y, "W", "E"},
      {x, "S", "N"}
    ]
    |> Enum.map(fn {coord, neg, pos} ->
      compass = if String.first(coord) == "-", do: neg, else: pos
      coord = String.trim_leading(coord, "-")
      "#{coord}#{compass}"
    end
    )
    |> List.to_tuple
  end

  @possible_opts_key [:unit, :compass?]

  @doc """
  Return the coordinates as formatted string in a tuple.

  Set :unit opt to specify the unit in which you want the coordinates to be outputed.
  Possible unit type depends on coordinates srid.

  Set :compass? opt to true if you want the coordinates to add compass indicator
  """
  @spec to_tuple_string(Coordinates.t(), keyword()) :: {String.t(), String.t()}
  def to_tuple_string(%Coordinates{coordinates: {y, x}} = coordinates, opts \\ []) do
    case validate_coordinates(coordinates) do
      {:error, error} -> raise ArgumentError, message: "Bad Coordinates: " <> error
      {:ok, _coordinates} -> :ok
    end
    opts = merge_default_opts(opts, x.unit)

    unit = Keyword.get(opts, :unit)
    compass? = Keyword.get(opts, :compass?)

    y = Convertible.convert(y, unit) |> to_string
    x = Convertible.convert(x, unit) |> to_string

    case compass? do
      true -> compass(y, x)
      false -> {y, x}
    end
  end
end
