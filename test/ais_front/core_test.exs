defmodule AisFront.CoreTest do
  use AisFront.DataCase

  alias AisFront.Core
  alias AisFront.RepoBack

  describe "core_shipinfos" do
    alias AisFront.Core.ShipInfos

    @valid_attrs %{callsign: "some callsign", cog: 120.5, destination: "some destination", dim_bow: 42, dim_port: 42, dim_starboard: 42, dim_stern: 42, draught: 120.5, eta: "2010-04-17T14:00:00Z", heading: 42, imo: 42, mmsi: 42, name: "some name", navstat: 42, pac: true, point: %Geo.Point{coordinates: {1,1}, srid: 4326}, rot: 42, ship_type: 42, sog: 120.5, time: "2010-04-17T14:00:00Z", valid_position: true}
    @update_attrs %{callsign: "some updated callsign", cog: 456.7, destination: "some updated destination", dim_bow: 43, dim_port: 43, dim_starboard: 43, dim_stern: 43, draught: 456.7, eta: "2011-05-18T15:01:01Z", heading: 43, imo: 43, mmsi: 43, name: "some updated name", navstat: 43, pac: false, point: %Geo.Point{coordinates: {2,2}, srid: 4326}, rot: 43, ship_type: 43, sog: 456.7, time: "2011-05-18T15:01:01Z", valid_position: false}
    @invalid_attrs %{callsign: nil, cog: nil, destination: nil, dim_bow: nil, dim_port: nil, dim_starboard: nil, dim_stern: nil, draught: nil, eta: nil, heading: nil, imo: nil, mmsi: nil, name: nil, navstat: nil, pac: nil, point: nil, rot: nil, ship_type: nil, sog: nil, time: nil, valid_position: nil}

    def shipinfos_fixture(attrs \\ %{}) do
      {:ok, shipinfos} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_shipinfos()

      shipinfos
    end

    setup do
      # Explicitly get a connection before each test
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(RepoBack)
    end

    test "list_core_shipinfos/0 returns all core_shipinfos" do
      shipinfos = shipinfos_fixture()
      assert Core.list_core_shipinfos() == [shipinfos]
    end

    test "get_shipinfos!/1 returns the shipinfos with given mmsi" do
      shipinfos = shipinfos_fixture()
      assert Core.get_shipinfos!(shipinfos.mmsi) == shipinfos
    end

    test "create_shipinfos/1 with valid data creates a shipinfos" do
      assert {:ok, %ShipInfos{} = shipinfos} = Core.create_shipinfos(@valid_attrs)
      assert shipinfos.callsign == "some callsign"
      assert shipinfos.cog == 120.5
      assert shipinfos.destination == "some destination"
      assert shipinfos.dim_bow == 42
      assert shipinfos.dim_port == 42
      assert shipinfos.dim_starboard == 42
      assert shipinfos.dim_stern == 42
      assert shipinfos.draught == 120.5
      assert shipinfos.eta == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert shipinfos.heading == 42
      assert shipinfos.imo == 42
      assert shipinfos.mmsi == 42
      assert shipinfos.name == "some name"
      assert shipinfos.navstat == 42
      assert shipinfos.pac == true
      assert shipinfos.rot == 42
      assert shipinfos.ship_type == 42
      assert shipinfos.sog == 120.5
      assert shipinfos.time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert shipinfos.valid_position == true
    end

    test "create_shipinfos/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_shipinfos(@invalid_attrs)
    end

    test "update_shipinfos/2 with valid data updates the shipinfos" do
      shipinfos = shipinfos_fixture()
      assert {:ok, %ShipInfos{} = shipinfos} = Core.update_shipinfos(shipinfos, @update_attrs)
      assert shipinfos.callsign == "some updated callsign"
      assert shipinfos.cog == 456.7
      assert shipinfos.destination == "some updated destination"
      assert shipinfos.dim_bow == 43
      assert shipinfos.dim_port == 43
      assert shipinfos.dim_starboard == 43
      assert shipinfos.dim_stern == 43
      assert shipinfos.draught == 456.7
      assert shipinfos.eta == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert shipinfos.heading == 43
      assert shipinfos.imo == 43
      assert shipinfos.mmsi == 43
      assert shipinfos.name == "some updated name"
      assert shipinfos.navstat == 43
      assert shipinfos.pac == false
      assert shipinfos.rot == 43
      assert shipinfos.ship_type == 43
      assert shipinfos.sog == 456.7
      assert shipinfos.time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert shipinfos.valid_position == false
    end

    test "update_shipinfos/2 with invalid data returns error changeset" do
      shipinfos = shipinfos_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_shipinfos(shipinfos, @invalid_attrs)
      assert shipinfos == Core.get_shipinfos!(shipinfos.mmsi)
    end

    test "delete_shipinfos/1 deletes the shipinfos" do
      shipinfos = shipinfos_fixture()
      assert {:ok, %ShipInfos{}} = Core.delete_shipinfos(shipinfos)
      assert_raise Ecto.NoResultsError, fn -> Core.get_shipinfos!(shipinfos.mmsi) end
    end

    test "change_shipinfos/1 returns a shipinfos changeset" do
      shipinfos = shipinfos_fixture()
      assert %Ecto.Changeset{} = Core.change_shipinfos(shipinfos)
    end
  end
end
