defmodule AisFrontWeb.ShipinfosController do
  use AisFrontWeb, :controller

  alias AisFront.Core
  alias AisFront.Core.Shipinfos

  action_fallback AisFrontWeb.FallbackController

  defp shipinfos_view(view) do
    case view do
      "full" -> Core.list_shipinfos_full
      "large_map" -> Core.list_shipinfos_large_map
    end
  end

  def index(conn, %{"format" => format, "view" => view}) do
    render(
      conn,
      "#{view}_index.#{format}",
      shipinfos: shipinfos_view(view)
    )
  end
  def index(conn, params) do
    params = Map.merge(%{"format" => "json", "view" => "full"}, params)
    index(conn, params)
  end

  def show(conn, %{"id" => id, "format" => format, "view" => view}) do
    render(
      conn,
      "#{view}_show.#{format}",
      shipinfos: shipinfos_view(view)
    )
  end
  def show(conn, params) do
    params = Map.merge(%{"format" => "json", "view" => "full"}, params)
    show(conn, params)
  end

  # def create(conn, %{"shipinfos" => shipinfos_params}) do
  #   with {:ok, %Shipinfos{} = shipinfos} <- Core.create_shipinfos(shipinfos_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", Routes.shipinfos_path(conn, :show, shipinfos))
  #     |> render("show.json", shipinfos: shipinfos)
  #   end
  # end


  # def update(conn, %{"id" => id, "shipinfos" => shipinfos_params}) do
  #   shipinfos = Core.get_shipinfos!(id)

  #   with {:ok, %Shipinfos{} = shipinfos} <- Core.update_shipinfos(shipinfos, shipinfos_params) do
  #     render(conn, "show.json", shipinfos: shipinfos)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   shipinfos = Core.get_shipinfos!(id)

  #   with {:ok, %Shipinfos{}} <- Core.delete_shipinfos(shipinfos) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
