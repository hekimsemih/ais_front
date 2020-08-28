defmodule AisFront.Core.Shipinfos do
  use Ecto.Schema
  import Ecto.Changeset

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

  @derive {Phoenix.Param, key: :mmsi}
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
end
