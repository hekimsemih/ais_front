defmodule AisFrontWeb.ShipinfosControllerTest do
  use AisFrontWeb.ConnCase

  alias AisFront.RepoBack

  alias AisFront.Core
  # alias AisFront.Core.Shipinfos

  @create_attrs %{callsign: "some callsign", cog: 120.5, destination: "some destination", dim_bow: 42, dim_port: 42, dim_starboard: 42, dim_stern: 42, draught: 120.5, eta: "2010-04-17T14:00:00Z", heading: 42, imo: 42, mmsi: 42, name: "some name", navstat: 42, pac: true, point: %Geo.Point{coordinates: {1,1}, srid: 4326}, rot: 42, ship_type: 42, sog: 120.5, time: "2010-04-17T14:00:00Z", valid_position: true}
  # @update_attrs %{callsign: "some updated callsign", cog: 456.7, destination: "some updated destination", dim_bow: 43, dim_port: 43, dim_starboard: 43, dim_stern: 43, draught: 456.7, eta: "2011-05-18T15:01:01Z", heading: 43, imo: 43, name: "some updated name", navstat: 43, pac: false, point: %Geo.Point{coordinates: {2,2}, srid: 4326}, rot: 43, ship_type: 43, sog: 456.7, time: "2011-05-18T15:01:01Z", valid_position: false}
  # @invalid_attrs %{callsign: nil, cog: nil, destination: nil, dim_bow: nil, dim_port: nil, dim_starboard: nil, dim_stern: nil, draught: nil, eta: nil, heading: nil, imo: nil, name: nil, navstat: nil, pac: nil, point: nil, rot: nil, ship_type: nil, sog: nil, time: nil, valid_position: nil}

  def fixture(:shipinfos) do
    {:ok, shipinfos} = Core.create_shipinfos(@create_attrs)
    shipinfos
  end

  setup %{conn: conn} do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(RepoBack)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all shipinfos", %{conn: conn} do
      conn = get(conn, Routes.shipinfos_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  # describe "create shipinfos" do
  #   test "renders shipinfos when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.shipinfos_path(conn, :create), shipinfos: @create_attrs)
  #     assert %{"mmsi" => mmsi} = json_response(conn, 201)["data"]

  #     conn = get(conn, Routes.shipinfos_path(conn, :show, mmsi))

  #     assert %{
  #              "mmsi" => mmsi
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.shipinfos_path(conn, :create), shipinfos: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update shipinfos" do
  #   setup [:create_shipinfos]

  #   test "renders shipinfos when data is valid", %{conn: conn, shipinfos: %Shipinfos{mmsi: mmsi} = shipinfos} do
  #     conn = put(conn, Routes.shipinfos_path(conn, :update, shipinfos), shipinfos: @update_attrs)
  #     assert %{
  #              "mmsi" => ^mmsi
  #            } = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.shipinfos_path(conn, :show, mmsi))

  #     assert %{
  #              "mmsi" => mmsi
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, shipinfos: shipinfos} do
  #     conn = put(conn, Routes.shipinfos_path(conn, :update, shipinfos), shipinfos: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete shipinfos" do
  #   setup [:create_shipinfos]

  #   test "deletes chosen shipinfos", %{conn: conn, shipinfos: shipinfos} do
  #     conn = delete(conn, Routes.shipinfos_path(conn, :delete, shipinfos))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.shipinfos_path(conn, :show, shipinfos))
  #     end
  #   end
  # end

  # defp create_shipinfos(_) do
  #   shipinfos = fixture(:shipinfos)
  #   %{shipinfos: shipinfos}
  # end
end
