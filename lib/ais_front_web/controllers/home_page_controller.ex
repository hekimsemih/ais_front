defmodule AisFrontWeb.HomePageController do
  use AisFrontWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
