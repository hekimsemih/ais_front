defmodule AisFront.Core.ShipInfos do
  use Ecto.Schema
  import Ecto.Changeset

  alias Geo.Point

  alias __MODULE__
  alias AisFront.Units.{Angle, Distance, Speed, ROT}
  alias AisFront.Coordinates

  defimpl Jason.Encoder do
    def encode(value, opts) do
      point = Geo.JSON.encode!(value.point)
      keys = Map.keys(value)
             |> Enum.filter(& &1 not in [:__struct__, :__meta__, :point])
      m = Map.take(value, keys)
          |> Map.put(:point, point)
      Jason.Encode.map(m, opts)
    end
  end

  defimpl Enumerable do
    def count(_panels), do: {:error, __MODULE__}
    def member?(_, _), do: {:error, __MODULE__}
    def slice(_), do: {:error, __MODULE__}

    def reduce(shipinfos, {:cont, acc}, fun), do: reduce_list(Map.to_list(shipinfos), {:cont, acc}, fun)

    defp reduce_list(_, {:halt, acc}, _fun), do: {:halted, acc}
    defp reduce_list(list, {:suspend, acc}, fun), do: {:suspended, acc, &reduce_list(list, &1, fun)}
    defp reduce_list([], {:cont, acc}, _fun), do: {:done, acc}
    defp reduce_list([{key, _value}|t], {:cont, acc}, fun) when key in [:__struct__, :__meta__], do: reduce_list(t, {:cont, acc}, fun)
    # defp reduce_list([{:point, point}|t], {:cont, acc}, fun), do: reduce_list(t, fun.(point.coordinates, acc), fun)
    defp reduce_list([h|t], {:cont, acc}, fun), do: reduce_list(t, fun.(h, acc), fun)
  end

  @primary_key {:mmsi, :integer, autogenerate: false}
  schema "core_shipinfos" do
    field :callsign, :string
    field :cog, :float
    field :destination, :string
    field :dim_bow, :integer
    field :dim_port, :integer
    field :dim_starboard, :integer
    field :dim_stern, :integer
    field :draught, :float
    field :eta, :utc_datetime
    field :heading, :integer
    field :imo, :integer
    field :name, :string
    field :navstat, :integer
    field :pac, :boolean, default: false
    field :point, Geo.PostGIS.Geometry
    field :rot, :integer
    field :ship_type, :integer
    field :sog, :float
    field :time, :utc_datetime
    field :valid_position, :boolean, default: false
  end

  @doc false
  def changeset(shipinfos, attrs) do
    shipinfos
    |> cast(attrs, [:mmsi, :time, :point, :valid_position, :cog, :sog, :heading, :pac, :rot, :navstat, :imo, :callsign, :name, :ship_type, :dim_bow, :dim_stern, :dim_port, :dim_starboard, :eta, :draught, :destination])
    |> validate_required([:mmsi, :time, :point])
  end

  @doc """
  Return a shipinfos field in a corresponding unit
  """
  def field_to_unit({key, value} = _field) do
    cond do
      key in [:dim_bow, :dim_port, :dim_starboard, :dim_stern, :draught]->
        Distance.new(value, :m)
      key in [:cog, :heading] ->
        Angle.new(value, :dd)
      key in [:rot] ->
        ROT.new(value, :ais)
      key in [:sog] ->
        Speed.new(value, :knots)
      key in [:point] ->
        Coordinates.from_point!(value)
      true -> if value in ["", nil], do: "-", else: value
    end
  end

  @doc """
  Return various meta information associated to a field key

  TODO: Maybe somewhere else. UI side ? needed for translation.
  """
  def field_meta({key, _value} = _field) do
    case key do
      :callsign ->
        %{
          short_desc: "callsign",
          long_desc: "radio callsign identifier",
        }
      :cog ->
        %{
          short_desc: "COG",
          long_desc: "Course Over Ground",
        }
      :destination ->
        %{
          short_desc: "destination",
          long_desc: "destination",
        }
      :dim_bow ->
        %{
          short_desc: "ship bow",
          long_desc: "dimension from ais to ship bow",
        }
      :dim_port ->
        %{
          short_desc: "ship port",
          long_desc: "dimension from ais to ship port",
        }
      :dim_starboard ->
        %{
          short_desc: "ship starboard",
          long_desc: "dimension from ais to ship starboard",
        }
        :dim_stern ->
        %{
          short_desc: "ship stern",
          long_desc: "dimension from ais to ship stern",
        }
        :draught ->
        %{
          short_desc: "draught",
          long_desc: "draught of the ship",
        }
        :eta ->
        %{
          short_desc: "ETA",
          long_desc: "Estimated Time of Arrival",
        }
        :heading ->
        %{
          short_desc: "heading",
          long_desc: "where the ship is heading. May be different from COG",
        }
        :imo ->
        %{
          short_desc: "IMO number",
          long_desc: "International Maritime Organisation number",
        }
        :mmsi ->
        %{
          short_desc: "MMSI",
          long_desc: "the MMSI identifier",
        }
        :name ->
        %{
          short_desc: "name",
          long_desc: "name of the ship",
        }
        :navstat ->
        %{
          short_desc: "navstat",
          long_desc: "AIS navigation information",
        }
        :pac ->
        %{
          short_desc: "position accuracy",
          long_desc: "0 - low accuracy, 1 - high accuracy",
        }
        :point ->
        %{
          short_desc: "point",
          long_desc: "geographic data informations",
        }
        :rot ->
        %{
          short_desc: "rate of turn",
          long_desc: "rate of turn",
        }
        :ship_type ->
        %{
          short_desc: "ship type",
          long_desc: "AIS ship type ",
        }
        :sog ->
        %{
          short_desc: "SOG",
          long_desc: "Speed Over Ground",
        }
        :time ->
        %{
          short_desc: "time",
          long_desc: "date and time when the position was emitted",
        }
        :valid_position ->
        %{
          short_desc: "valid position",
          long_desc: "whether or not the position is considered a valid one by the GPS",
        }
    end
  end

  @doc """
  Return a well-formated name for the ship based on the availability of name and callsign.

  ## Examples

      iex> alias AisFront.Core.ShipInfos
      iex> %ShipInfos{name: "alpha", callsign: "FE3G", mmsi: 1234} |> ShipInfos.pretty_name!
      "alpha@FE3G (1234)"
      iex> %ShipInfos{name: "", callsign: "FE3G", mmsi: 1234} |> ShipInfos.pretty_name!
      "@FE3G (1234)"
      iex> %ShipInfos{name: "beta", callsign: "", mmsi: 1234} |> ShipInfos.pretty_name!
      "beta (1234)"
      iex> %ShipInfos{name: "", callsign: "", mmsi: 1234} |> ShipInfos.pretty_name!
      "(1234)"

  """
  def pretty_name!(shipinfos) do
    {shipinfos.name, shipinfos.callsign, shipinfos.mmsi}
    |> (fn
      {"", "", m} -> "(#{m})"
      {n, "", m} -> "#{n} (#{m})"
      {n, c, m} -> "#{n}@#{c} (#{m})"
    end).()
  end

  @doc """
  Return the date diff in a humanized format

      iex> alias AisFront.Core.ShipInfos
      iex> %ShipInfos{time: DateTime.add(DateTime.utc_now, 40, :second)} |> ShipInfos.pretty_date!
      "in 40 seconds"
      iex> %ShipInfos{time: DateTime.add(DateTime.utc_now, -40, :second)} |> ShipInfos.pretty_date!
      "40 seconds ago"
      iex> %ShipInfos{time: DateTime.add(DateTime.utc_now, 1, :second)} |> ShipInfos.pretty_date!
      "now"
      iex> %ShipInfos{time: DateTime.add(DateTime.utc_now, 100000, :second)} |> ShipInfos.pretty_date!
      "in 1 day and 3 hours"

  """
  def pretty_date!(shipinfos) do
    now = DateTime.utc_now
    dt = DateTime.diff(now, shipinfos.time)
    pretty_dt =
      dt
      |> Timex.Duration.from_seconds
      |> Timex.Format.Duration.Formatters.Humanized.format
      |> String.split(", ")
      |> Enum.take(2)
      |> Enum.join(" and ")
    cond do
      dt > 30 -> Enum.join([pretty_dt, "ago"], " ")
      dt < -30 -> Enum.join(["in", pretty_dt], " ")
      true -> "now"
    end
  end

  @doc """
  Return a point in various formats dependending on srid unit type
  """
  def pretty_point!(shipinfos, opts \\ [])
  def pretty_point!(%ShipInfos{point: %Point{} = point}, opts) do
    {x, y} = point
             |> Coordinates.from_point!
             |> Coordinates.to_tuple_string(opts)
    "#{y}, #{x}"
  end
end
