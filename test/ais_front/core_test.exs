defmodule AisFront.CoreTest do
  use AisFront.DataCase

  alias AisFront.Core

  describe "core_shipinfos" do
    alias AisFront.Core.ShipInfos

    @valid_attrs %{callsign: "some callsign", cog: 120.5, destination: "some destination", dim_bow: 42, dim_port: 42, dim_starboard: 42, dim_stern: 42, draught: 120.5, eta: "2010-04-17T14:00:00Z", heading: 42, imo: 42, mmsi: 42, name: "some name", navstat: 42, pac: true, rot: 42, ship_type: 42, sog: 120.5, time: "2010-04-17T14:00:00Z", valid_position: true}
    @update_attrs %{callsign: "some updated callsign", cog: 456.7, destination: "some updated destination", dim_bow: 43, dim_port: 43, dim_starboard: 43, dim_stern: 43, draught: 456.7, eta: "2011-05-18T15:01:01Z", heading: 43, imo: 43, mmsi: 43, name: "some updated name", navstat: 43, pac: false, rot: 43, ship_type: 43, sog: 456.7, time: "2011-05-18T15:01:01Z", valid_position: false}
    @invalid_attrs %{callsign: nil, cog: nil, destination: nil, dim_bow: nil, dim_port: nil, dim_starboard: nil, dim_stern: nil, draught: nil, eta: nil, heading: nil, imo: nil, mmsi: nil, name: nil, navstat: nil, pac: nil, rot: nil, ship_type: nil, sog: nil, time: nil, valid_position: nil}

    def ship_infos_fixture(attrs \\ %{}) do
      {:ok, ship_infos} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_ship_infos()

      ship_infos
    end

    test "list_core_shipinfos/0 returns all core_shipinfos" do
      ship_infos = ship_infos_fixture()
      assert Core.list_core_shipinfos() == [ship_infos]
    end

    test "get_ship_infos!/1 returns the ship_infos with given id" do
      ship_infos = ship_infos_fixture()
      assert Core.get_ship_infos!(ship_infos.id) == ship_infos
    end

    test "create_ship_infos/1 with valid data creates a ship_infos" do
      assert {:ok, %ShipInfos{} = ship_infos} = Core.create_ship_infos(@valid_attrs)
      assert ship_infos.callsign == "some callsign"
      assert ship_infos.cog == 120.5
      assert ship_infos.destination == "some destination"
      assert ship_infos.dim_bow == 42
      assert ship_infos.dim_port == 42
      assert ship_infos.dim_starboard == 42
      assert ship_infos.dim_stern == 42
      assert ship_infos.draught == 120.5
      assert ship_infos.eta == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert ship_infos.heading == 42
      assert ship_infos.imo == 42
      assert ship_infos.mmsi == 42
      assert ship_infos.name == "some name"
      assert ship_infos.navstat == 42
      assert ship_infos.pac == true
      assert ship_infos.rot == 42
      assert ship_infos.ship_type == 42
      assert ship_infos.sog == 120.5
      assert ship_infos.time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert ship_infos.valid_position == true
    end

    test "create_ship_infos/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_ship_infos(@invalid_attrs)
    end

    test "update_ship_infos/2 with valid data updates the ship_infos" do
      ship_infos = ship_infos_fixture()
      assert {:ok, %ShipInfos{} = ship_infos} = Core.update_ship_infos(ship_infos, @update_attrs)
      assert ship_infos.callsign == "some updated callsign"
      assert ship_infos.cog == 456.7
      assert ship_infos.destination == "some updated destination"
      assert ship_infos.dim_bow == 43
      assert ship_infos.dim_port == 43
      assert ship_infos.dim_starboard == 43
      assert ship_infos.dim_stern == 43
      assert ship_infos.draught == 456.7
      assert ship_infos.eta == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert ship_infos.heading == 43
      assert ship_infos.imo == 43
      assert ship_infos.mmsi == 43
      assert ship_infos.name == "some updated name"
      assert ship_infos.navstat == 43
      assert ship_infos.pac == false
      assert ship_infos.rot == 43
      assert ship_infos.ship_type == 43
      assert ship_infos.sog == 456.7
      assert ship_infos.time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert ship_infos.valid_position == false
    end

    test "update_ship_infos/2 with invalid data returns error changeset" do
      ship_infos = ship_infos_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_ship_infos(ship_infos, @invalid_attrs)
      assert ship_infos == Core.get_ship_infos!(ship_infos.id)
    end

    test "delete_ship_infos/1 deletes the ship_infos" do
      ship_infos = ship_infos_fixture()
      assert {:ok, %ShipInfos{}} = Core.delete_ship_infos(ship_infos)
      assert_raise Ecto.NoResultsError, fn -> Core.get_ship_infos!(ship_infos.id) end
    end

    test "change_ship_infos/1 returns a ship_infos changeset" do
      ship_infos = ship_infos_fixture()
      assert %Ecto.Changeset{} = Core.change_ship_infos(ship_infos)
    end
  end
end
