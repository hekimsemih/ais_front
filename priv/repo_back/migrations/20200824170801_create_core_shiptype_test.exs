defmodule AisFront.RepoBack.Migrations.CreateCoreShipinfosTest do
  use Ecto.Migration

  def up do
    if(Mix.env() == :test) do
      execute "CREATE EXTENSION IF NOT EXISTS postgis"
      create table(:core_shiptype, primary_key: false) do
        add :details, :string
        add :name, :string, null: false
        add :short_name, :string, null: false
        add :summary, :string, null: false
        add :type_id, :integer, primary_key: true
      end
    end
  end
  def down do
    if(Mix.env() == :test) do
      drop table(:core_shiptype)
    end
  end
end
