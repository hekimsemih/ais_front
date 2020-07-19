defmodule AisFront.Core.ShipInfos do
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
  def changeset(ship_infos, attrs) do
    ship_infos
    |> cast(attrs, [:mmsi, :time, :valid_position, :cog, :sog, :heading, :pac, :rot, :navstat, :imo, :callsign, :name, :ship_type, :dim_bow, :dim_stern, :dim_port, :dim_starboard, :eta, :draught, :destination])
    |> validate_required([:mmsi, :time, :valid_position, :cog, :sog, :heading, :pac, :rot, :navstat, :imo, :callsign, :name, :ship_type, :dim_bow, :dim_stern, :dim_port, :dim_starboard, :eta, :draught, :destination])
  end
end
