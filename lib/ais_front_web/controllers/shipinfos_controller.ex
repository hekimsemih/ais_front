defmodule AisFrontWeb.ShipinfosController do
  use AisFrontWeb, :controller

  alias AisFront.Core

  action_fallback AisFrontWeb.FallbackController

  @index_shipinfos_view %{
    "full" => &Core.list_shipinfos_full/0,
    "large_map" => &Core.list_shipinfos_large_map/0
  }
  def index(conn, %{"format" => format, "view" => view}) do
    render(
      conn,
      "#{view}_index.#{format}",
      shipinfos: @index_shipinfos_view[view].()
    )
  end
  def index(conn, params) do
    params = Map.merge(%{"format" => "json", "view" => "full"}, params)
    index(conn, params)
  end

  @show_shipinfos_view %{
    "full" => &Core.get_shipinfos_full/1,
    "large_map" => &Core.get_shipinfos_large_map/1
  }
  def show(conn, %{"id" => id, "format" => format, "view" => view}) do
    render(
      conn,
      "#{view}_show.#{format}",
      shipinfos: @show_shipinfos_view[view].(id)
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
