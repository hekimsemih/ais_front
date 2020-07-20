defmodule AisFrontWeb.Live.Component.Svg do
  @moduledoc """
  Svg component render SVG image as valid html tags. This component should live
  between a <svg> tag (see: [https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html#module-svg-support])

  This component allow to manipulate SVG image style via css for example.
  """
  use Phoenix.LiveComponent
  alias Phoenix.HTML
  require Logger

  def update(%{image: image}, socket) do
    :code.priv_dir(:ais_front)
    |> Path.join("static/images")
    |> Path.join(image)
    |> File.read
    |> case do
      {:ok, content} ->
        {:ok, assign(socket, content: content)}
      {:error, err} ->
        Logger.error "Can't read svg component #{image} #{err}"
        {:ok, socket}
    end
  end

  def render(%{content: _content} = assigns) do
    ~L"""
    <%= HTML.raw @content %>
    """
  end
  def render(%{} = assigns) do
    ~L"""
    """
  end
end
