defmodule FerryWeb.PageController do
  use FerryWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
