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
  def field_to_unit(key, value) do
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
      true -> value
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
    point
    |> Coordinates.from_point!
    |> Coordinates.to_tuple_string(opts)
  end
end
