defmodule AisFront.RepoBack.Migrations.CreateCoreShipinfosTest do
  use Ecto.Migration

  def up do
    if(Mix.env() == :test) do
      execute "CREATE EXTENSION IF NOT EXISTS postgis"
      create table(:core_shipinfos, primary_key: false) do
        add :callsign, :string
        add :cog, :float
        add :destination, :string, null: false
        add :dim_bow, :integer
        add :dim_port, :integer
        add :dim_starboard, :integer
        add :dim_stern, :integer
        add :draught, :float
        add :eta, :utc_datetime
        add :heading, :integer
        add :imo, :integer
        add :mmsi, :integer, primary_key: true
        add :name, :string, null: false
        add :navstat, :integer
        add :pac, :boolean, default: false
        add :point, :geography
        add :rot, :integer
        add :ship_type, :integer, null: false
        add :sog, :float
        add :time, :utc_datetime, null: false
        add :valid_position, :boolean, default: false
      end
    end
  end
  def down do
    if(Mix.env() == :test) do
      drop table(:core_shipinfos)
    end
  end
end
