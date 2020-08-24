defmodule AisFrontWeb.ShipinfosController do
  use AisFrontWeb, :controller

  alias AisFront.Core
  alias AisFront.Core.Shipinfos

  action_fallback AisFrontWeb.FallbackController

  def index(conn, _params) do
    shipinfos = Core.list_shipinfos()
    render(conn, "index.json", shipinfos: shipinfos)
  end

  def create(conn, %{"shipinfos" => shipinfos_params}) do
    with {:ok, %Shipinfos{} = shipinfos} <- Core.create_shipinfos(shipinfos_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.shipinfos_path(conn, :show, shipinfos))
      |> render("show.json", shipinfos: shipinfos)
    end
  end

  def show(conn, %{"id" => id}) do
    shipinfos = Core.get_shipinfos!(id)
    render(conn, "show.json", shipinfos: shipinfos)
  end

  def update(conn, %{"id" => id, "shipinfos" => shipinfos_params}) do
    shipinfos = Core.get_shipinfos!(id)

    with {:ok, %Shipinfos{} = shipinfos} <- Core.update_shipinfos(shipinfos, shipinfos_params) do
      render(conn, "show.json", shipinfos: shipinfos)
    end
  end

  def delete(conn, %{"id" => id}) do
    shipinfos = Core.get_shipinfos!(id)

    with {:ok, %Shipinfos{}} <- Core.delete_shipinfos(shipinfos) do
      send_resp(conn, :no_content, "")
    end
  end
end
